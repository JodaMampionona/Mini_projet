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
        self.graph = nx.Graph()

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
                    liste_id_arrets[i], liste_id_arrets[i + 1], id_bus=id_bus
                )

    """
    Renvoie une liste de segments :
        [
            {
                'bus': 'D Ambohidratrimo', 
                'from': 'Terminus D Ambohidratrimo', 
                'to': 'Imerinafovoany',
                'lat': -18.879123,
                lon: 47.531234
            },
            ...
        ]
    """

    def get_bus_itinerary(self, start_id: int, destination_id: int):
        itinerary_named = []

        if start_id not in self.graph or destination_id not in self.graph:
            print("Départ et/ou destination invalides.")
            return itinerary_named

        try:
            chemin = nx.shortest_path(
                self.graph, source=start_id, target=destination_id
            )
            print("Chemin trouvé :", chemin)

            # Construire les segments de bus DANS L'ORDRE
            itinerary = []  # Liste de tuples (bus_id, start_id, end_id)
            bus_actuel = None
            debut_segment = chemin[0]

            for i in range(len(chemin) - 1):
                id_bus = self.graph[chemin[i]][chemin[i + 1]]['id_bus']
                if id_bus != bus_actuel:
                    if bus_actuel is not None:
                        itinerary.append(
                            (bus_actuel, debut_segment, chemin[i]))
                    bus_actuel = id_bus
                    debut_segment = chemin[i]

            # Ajouter le dernier segment
            itinerary.append((bus_actuel, debut_segment, chemin[-1]))

            # Transformer les IDs en noms
            bus_ids = list({segment[0] for segment in itinerary})
            stop_ids = set()
            for bus_id, start, end in itinerary:
                stop_ids.update([start, end])

            buses = self.busRepo.get_by_ids(bus_ids)
            stops = self.stopRepo.get_by_ids(list(stop_ids))

            bus_map = {bus.id: bus.name for bus in buses}
            stop_map = {stop.id: BusStop(
                id=stop.id, name=stop.name, lat=stop.lat, lon=stop.lon) for stop in stops}

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
