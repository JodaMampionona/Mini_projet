import psycopg2
import networkx as nx
from app.dao.bus_stop_link_dao import BusStopLinkDAO


class BusItineraryService:
    def __init__(self):
        self.linkDAO = BusStopLinkDAO()

    # TODO : les graph_edges par id au lieu de par nom
    # TODO : retourner au lieu d'afficher

    def get_bus_itinerary(self, start: str, destination: str):

        links = self.linkDAO.get_links_ordered_by_bus()

        # Création Graphe
        G = nx.Graph()

        # Organiser arrêts par bus
        arrets_par_bus = {}
        for link in links:
            id_bus = link.bus.id
            nom_arret = link.stop.name
            ordre = link.rank
            if id_bus not in arrets_par_bus:
                arrets_par_bus[id_bus] = []
            arrets_par_bus[id_bus].append(nom_arret)

        # Créer les arcs
        for id_bus, liste_arrets in arrets_par_bus.items():
            for i in range(len(liste_arrets)-1):
                G.add_edge(liste_arrets[i], liste_arrets[i+1], bus=id_bus)

        # vérifier si les arrêts existent
        if start not in G:
            print('depart invalide')
            return
        if destination not in G:
            print('destination invalide')
            return

        try:
            chemin = nx.shortest_path(G, source=start, target=destination)
            print("Chemin trouvé :", chemin)
            # Regrouper par bus
            bus_actuel = None
            debut_segment = chemin[0]
            for i in range(len(chemin)-1):
                bus = G[chemin[i]][chemin[i+1]]['bus']
                # Si changement de bus ou premier arrêt
                if bus != bus_actuel:
                    # Si ce n'est pas le premier segment, afficher le précédent
                    if bus_actuel is not None:
                        print(
                            f"Prendre le bus {bus_actuel} de {debut_segment} → {chemin[i]}")
                    # Nouveau segment
                    bus_actuel = bus
                    debut_segment = chemin[i]
            # Afficher le dernier segment
            print(
                f"Prendre le bus {bus_actuel} de {debut_segment} → {destination}")
        except nx.NetworkXNoPath:
            print("Aucun chemin trouvé entre ces deux arrêts.")
