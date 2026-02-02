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

    # TODO : les graph_edges par id au lieu de par nom
    # TODO : retourner au lieu d'afficher

    def init_graph(self):
        links = self.linkRepo.get_links_ordered_by_rank()
        self.graph = nx.Graph()  # ❗ inchangé

        # Organiser arrêts par bus
        arrets_par_bus = {}
        for link in links:
            id_bus = link.bus.id
            id_arret = link.stop.id

            if id_bus not in arrets_par_bus:
                arrets_par_bus[id_bus] = []
            arrets_par_bus[id_bus].append(id_arret)

        # Créer les arcs
        for id_bus, liste_id_arrets in arrets_par_bus.items():
            for i in range(len(liste_id_arrets) - 1):
                self.graph.add_edge(
                    liste_id_arrets[i],
                    liste_id_arrets[i + 1],
                    id_bus=id_bus
                )

    """
    Renvoie une liste de segments
    """
    def get_bus_itinerary(
        self,
        start_lat: float,
        start_lon: float,
        destination_lat: float,
        destination_lon: float
    ):
        itinerary_named = []

        start_stop = self.get_nearest_bus_stop(start_lat, start_lon)
        destination_stop = self.get_nearest_bus_stop(destination_lat, destination_lon)

        if start_stop is None or destination_stop is None:
            return itinerary_named

        start_id = start_stop.id
        destination_id = destination_stop.id

        if start_id not in self.graph or destination_id not in self.graph:
            print("Départ et/ou destination invalides.")
            return itinerary_named

        try:
            chemin = nx.shortest_path(
                self.graph,
                source=start_id,
                target=destination_id
            )

            # Construire les segments de bus DANS L'ORDRE
            itinerary = []
            bus_actuel = None
            debut_segment = chemin[0]

            for i in range(len(chemin) - 1):
                id_bus = self.graph[chemin[i]][chemin[i + 1]]['id_bus']
                if id_bus != bus_actuel:
                    if bus_actuel is not None:
                        itinerary.append(
                            (bus_actuel, debut_segment, chemin[i])
                        )
                    bus_actuel = id_bus
                    debut_segment = chemin[i]

            itinerary.append((bus_actuel, debut_segment, chemin[-1]))

            # Transformer les IDs en noms
            bus_ids = list({segment[0] for segment in itinerary})
            stop_ids = set()
            for bus_id, start, end in itinerary:
                stop_ids.update([start, end])

            buses = self.busRepo.get_by_ids(bus_ids)
            stops = self.stopRepo.get_by_ids(list(stop_ids))

            bus_map = {bus.id: bus.name for bus in buses}
            stop_map = {
                stop.id: BusStop(
                    id=stop.id,
                    name=stop.name,
                    lat=stop.lat,
                    lon=stop.lon
                )
                for stop in stops
            }

            for bus_id, start_id, end_id in itinerary:
                itinerary_named.append({
                    "bus": bus_map[bus_id],
                    "from": stop_map[start_id].name,
                    "to": stop_map[end_id].name,
                    "lat": stop_map[start_id].lat,
                    "lon": stop_map[start_id].lon
                })

            return itinerary_named

        except nx.NetworkXNoPath:
            print("Aucun chemin trouvé.")
            return itinerary_named

    """
    Trouve l'arrêt le plus proche (corrigé)
    """
    def get_nearest_bus_stop(self, lat: float, lon: float) -> BusStop | None:
        stops = self.stopRepo.get_all()
        nearest_stop = None
        min_distance = float('inf')

        for stop in stops:
            distance = ((stop.lat - lat) ** 2 + (stop.lon - lon) ** 2) ** 0.5
            if distance < min_distance:
                min_distance = distance
                nearest_stop = stop

        return nearest_stop
