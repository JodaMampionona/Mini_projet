import math
import networkx as nx
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

    # -------------------------
    # OUTILS GPS
    # -------------------------
    def haversine_distance(self, lat1, lon1, lat2, lon2):
        R = 6371  # Rayon de la Terre en km
        phi1 = math.radians(lat1)
        phi2 = math.radians(lat2)
        dphi = math.radians(lat2 - lat1)
        dlambda = math.radians(lon2 - lon1)

        a = math.sin(dphi / 2) ** 2 + \
            math.cos(phi1) * math.cos(phi2) * math.sin(dlambda / 2) ** 2

        return 2 * R * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    def get_nearest_stop(self, lat, lon):
        stops = self.stopRepo.get_all()
        nearest = None
        min_dist = float("inf")

        for stop in stops:
            dist = self.haversine_distance(
                lat, lon, stop.lat, stop.lon
            )
            if dist < min_dist:
                min_dist = dist
                nearest = stop

        return nearest

    # -------------------------
    # CONSTRUCTION DU GRAPHE
    # -------------------------
    def init_graph(self):
        links = self.linkRepo.get_links_ordered_by_rank()
        self.graph = nx.Graph()

        arrets_par_bus = {}

        for link in links:
            bus_id = link.bus.id
            stop_id = link.stop.id

            arrets_par_bus.setdefault(bus_id, []).append(stop_id)

        # Liaisons normales
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
            buses = [
                bus_id for bus_id, stops in arrets_par_bus.items()
                if stop_id in stops
            ]
            for i in range(len(buses)):
                for j in range(i + 1, len(buses)):
                    self.graph.add_edge(
                        (stop_id, buses[i]),
                        (stop_id, buses[j]),
                        weight=PENALTY_BUS_CHANGE
                    )

    # -------------------------
    # ALGO EXISTANT (INCHANGÉ)
    # -------------------------
    def get_bus_itinerary(self, start_id: int, destination_id: int):
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
                    cost = nx.dijkstra_path_length(
                        self.graph, s, e, weight="weight"
                    )
                    if cost < best_cost:
                        best_cost = cost
                        best_path = nx.dijkstra_path(
                            self.graph, s, e, weight="weight"
                        )
                except nx.NetworkXNoPath:
                    continue

        if not best_path:
            return itinerary_named

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

        bus_ids = {seg[0] for seg in itinerary}
        stop_ids = {s for _, s, e in itinerary for s in (s, e)}

        buses = self.busRepo.get_by_ids(list(bus_ids))
        stops = self.stopRepo.get_by_ids(list(stop_ids))

        bus_map = {b.id: b.name for b in buses}
        stop_map = {s.id: s for s in stops}

        for bus_id, start_id, end_id in itinerary:
            itinerary_named.append({
                "bus": bus_map[bus_id],
                "from": stop_map[start_id].name,
                "to": stop_map[end_id].name,
                "lat": stop_map[start_id].lat,
                "lon": stop_map[start_id].lon
            })

        return itinerary_named

    # -------------------------
    # NOUVELLE MÉTHODE GPS
    # -------------------------
    def get_bus_itinerary_by_gps(
        self,
        start_lat: float,
        start_lon: float,
        end_lat: float,
        end_lon: float
    ):
        start_stop = self.get_nearest_stop(start_lat, start_lon)
        end_stop = self.get_nearest_stop(end_lat, end_lon)

        if not start_stop or not end_stop:
            return []

        return self.get_bus_itinerary(start_stop.id, end_stop.id)
