import psycopg2
import networkx as nx
from app.repository.bus_stop_link_repository import BusStopLinkRepository
from app.repository.bus_stop_repository import BusStopRepository
from app.repository.bus_repository import BusRepository


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
            for i in range(len(liste_id_arrets)-1):
                self.graph.add_edge(
                    liste_id_arrets[i], liste_id_arrets[i+1], id_bus=id_bus)

    """
     renvoie une list 
        [
            {
                'bus': 'D Ambohidratrimo', 
                'from': 'Terminus D Ambohidratrimo', 
                'to': 'Imerinafovoany'
            },
            ...
        ]
    """

    def get_bus_itinerary(self, start_id: int, destination_id: int):

        itinerary = {}
        itinerary_named = []

        if start_id not in self.graph or destination_id not in self.graph:
            print("Depart et/ou destination invalides.")
            return itinerary_named

        try:
            chemin = nx.shortest_path(
                self.graph, source=start_id, target=destination_id)
            print("Chemin trouvé :", chemin)
            # Regrouper par bus
            bus_actuel = None
            debut_segment = chemin[0]
            for i in range(len(chemin)-1):
                id_bus = self.graph[chemin[i]][chemin[i+1]]['id_bus']
                # Si changement de bus ou premier arrêt
                if id_bus != bus_actuel:
                    # Si ce n'est pas le premier segment, afficher le précédent
                    if bus_actuel is not None:
                        itinerary[bus_actuel] = (debut_segment, chemin[i])
                    # Nouveau segment
                    bus_actuel = id_bus
                    debut_segment = chemin[i]
            # Afficher le dernier segment
            itinerary[bus_actuel] = (debut_segment, chemin[-1])

            # --- Transformer les IDs en noms ---
            bus_ids = list(itinerary.keys())
            stop_ids = set()
            for seg in itinerary.values():
                stop_ids.update(seg)

            buses = self.busRepo.get_by_ids(bus_ids)
            stops = self.stopRepo.get_by_ids(list(stop_ids))

            bus_map = {bus.id: bus.name for bus in buses}
            stop_map = {stop.id: stop.name for stop in stops}

            for bus_id, (start_id, end_id) in itinerary.items():
                itinerary_named.append({
                    "bus": bus_map[bus_id],
                    "from": stop_map[start_id],
                    "to": stop_map[end_id]
                })
            print(itinerary_named)
            return itinerary_named

        except nx.NetworkXNoPath:
            print('aucun chemin trouvé')
        finally:
            return itinerary_named
