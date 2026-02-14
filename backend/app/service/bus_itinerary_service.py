import math
import networkx as nx
import requests
from app.repository.bus_stop_link_repository import BusStopLinkRepository
from app.repository.bus_stop_repository import BusStopRepository
from app.repository.bus_repository import BusRepository
from app.model.bus_stop_model import BusStop

class BusItineraryService:

    def __init__(self):
        self.linkRepo = BusStopLinkRepository()
        self.stopRepo = BusStopRepository()
        self.busRepo = BusRepository()
        self.graph = None
        self.init_graph()

    # ---------------------------------------------------------
    # OUTILS GPS & CALCULS
    # ---------------------------------------------------------
    def haversine_distance(self, lat1, lon1, lat2, lon2):
        """Calcule la distance en km entre deux points GPS."""
        R = 6371  # Rayon de la Terre en km
        phi1 = math.radians(lat1)
        phi2 = math.radians(lat2)
        dphi = math.radians(lat2 - lat1)
        dlambda = math.radians(lon2 - lon1)

        a = math.sin(dphi / 2) ** 2 + \
            math.cos(phi1) * math.cos(phi2) * math.sin(dlambda / 2) ** 2

        return 2 * R * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    def get_nearest_stop(self, lat, lon):
        """Trouve l'arrêt le plus proche d'un point GPS donné."""
        stops = self.stopRepo.get_all()
        nearest = None
        min_dist = float("inf")

        for stop in stops:
            dist = self.haversine_distance(lat, lon, stop.lat, stop.lon)
            if dist < min_dist:
                min_dist = dist
                nearest = stop
        return nearest

    # ---------------------------------------------------------
    # CONSTRUCTION DU GRAPHE (NETWORKX)
    # ---------------------------------------------------------
    def init_graph(self):
        links = self.linkRepo.get_links_ordered_by_rank()
        self.graph = nx.Graph()
        arrets_par_bus = {}

        for link in links:
            bus_id = link.bus.id
            stop_id = link.stop.id
            arrets_par_bus.setdefault(bus_id, []).append(stop_id)

        # Liaisons normales entre arrêts d'une même ligne
        for bus_id, stops in arrets_par_bus.items():
            for i in range(len(stops) - 1):
                self.graph.add_edge(
                    (stops[i], bus_id),
                    (stops[i + 1], bus_id),
                    weight=1
                )

        # Correspondances
        PENALTY_BUS_CHANGE = 50
        all_stops = set()
        for stops in arrets_par_bus.values():
            all_stops.update(stops)

        for stop_id in all_stops:
            buses = [bus_id for bus_id, stops in arrets_par_bus.items() if stop_id in stops]
            for i in range(len(buses)):
                for j in range(i + 1, len(buses)):
                    self.graph.add_edge(
                        (stop_id, buses[i]),
                        (stop_id, buses[j]),
                        weight=PENALTY_BUS_CHANGE
                    )

    # ---------------------------------------------------------
    # ALGORITHMES D'ITINÉRAIRE
    # ---------------------------------------------------------
    def get_bus_itinerary(self, start_id: int, destination_id: int):
        """Calcule le meilleur itinéraire entre deux IDs d'arrêts."""
        itinerary_named = []
        start_nodes = [n for n in self.graph.nodes if n[0] == start_id]
        end_nodes = [n for n in self.graph.nodes if n[0] == destination_id]

        if not start_nodes or not end_nodes:
            return itinerary_named

        best_path = None
        best_cost = float("inf")

        for s in start_nodes:
            for e in end_nodes:
                try:
                    cost = nx.dijkstra_path_length(self.graph, s, e, weight="weight")
                    if cost < best_cost:
                        best_cost = cost
                        best_path = nx.dijkstra_path(self.graph, s, e, weight="weight")
                except nx.NetworkXNoPath:
                    continue

        if not best_path:
            return itinerary_named

        # Transformation du chemin Dijkstra en segments de bus
        itinerary = []
        bus_actuel = best_path[0][1]
        debut = best_path[0][0]

        for i in range(1, len(best_path)):
            stop_id, bus_id = best_path[i]
            if bus_id != bus_actuel:
                itinerary.append((bus_actuel, debut, best_path[i - 1][0]))
                bus_actuel = bus_id
                debut = stop_id

        itinerary.append((bus_actuel, debut, best_path[-1][0]))

        # Récupération des noms pour l'affichage
        bus_ids = {seg[0] for seg in itinerary}
        stop_ids = {s for _, s, e in itinerary for s in (s, e)}
        buses = self.busRepo.get_by_ids(list(bus_ids))
        stops = self.stopRepo.get_by_ids(list(stop_ids))

        bus_map = {b.id: b.name for b in buses}
        stop_map = {s.id: s for s in stops}

        for bus_id, s_id, e_id in itinerary:
            itinerary_named.append({
                "bus": bus_map[bus_id],
                "from": stop_map[s_id].name,
                "to": stop_map[e_id].name,
                "start_lat": stop_map[s_id].lat,
                "start_lon": stop_map[s_id].lon,
                "end_lat": stop_map[e_id].lat,
                "end_lon": stop_map[e_id].lon
            })
        return itinerary_named

    def get_bus_itinerary_by_gps(self, start_lat, start_lon, dest_lat, dest_lon):
        """Itinéraire entre deux points GPS."""
        start_stop = self.get_nearest_stop(start_lat, start_lon)
        end_stop = self.get_nearest_stop(dest_lat, dest_lon)
        if not start_stop or not end_stop:
            return []
        return self.get_bus_itinerary(start_stop.id, end_stop.id)

    # ---------------------------------------------------------
    # GESTION DES BUS ET RECHERCHE
    # ---------------------------------------------------------
    def get_buses_simple_list(self):
        buses = self.busRepo.get_all()

        return [{"bus_id": b.id, "bus_name": b.name, "itinerary" : [
            self.stopRepo.get_first_stop(b.id),
            self.stopRepo.get_last_stop(b.id)
        ]} for b in buses]


    def get_bus_details_with_stops(self, bus_id: int):
        """Retourne les détails d'un bus et son itinéraire complet (tous les arrêts)."""
        bus = self.busRepo.get_by_id(bus_id)
        if not bus:
            return None

        all_links = self.linkRepo.get_links_ordered_by_rank()
        bus_links = [link for link in all_links if link.bus.id == bus_id]

        stops_itinerary = []
        for link in bus_links:
            stops_itinerary.append({
                "id": link.stop.id,
                "name": link.stop.name,
                "lat": link.stop.lat,
                "lon": link.stop.lon,
                "order": link.rank
            })

        return {
            "bus_id": bus.id,
            "bus_name": bus.name,
            "itinerary": stops_itinerary
        }

    def search_nearby_stops(self, query: str, radius_km: float = 0.5):
        """Recherche un lieu via Photon (focus Tana) et trouve les arrêts proches."""
        # Priorité Antananarivo : lat=-18.8792, lon=47.5079
        photon_url = f"https://photon.komoot.io/api/?q={query}&limit=1&lat=-18.8792&lon=47.5079"

        try:
            response = requests.get(photon_url, timeout=5, headers={"User-Agent": "beTax/1.0"})
            data = response.json()

            if not data['features']:
                return {"error": "Lieu non trouvé", "stops": []}

            # Photon : [longitude, latitude]
            lon = data['features'][0]['geometry']['coordinates'][0]
            lat = data['features'][0]['geometry']['coordinates'][1]
            place_name = data['features'][0]['properties'].get('name', query)

            all_stops = self.stopRepo.get_all()
            nearby_stops = []

            for stop in all_stops:
                dist = self.haversine_distance(lat, lon, stop.lat, stop.lon)
                if dist <= radius_km:
                    nearby_stops.append({
                        "id": stop.id,
                        "name": stop.name,
                        "lat": stop.lat,
                        "lon": stop.lon,
                        "distance_m": round(dist * 1000)
                    })


            nearby_stops.sort(key=lambda x: x['distance_m'])

            return {
                "search_place": place_name,
                "coordinates": {"lat": lat, "lon": lon},
                "stops": nearby_stops
            }
        except Exception as e:
            return {"error": str(e), "stops": []}