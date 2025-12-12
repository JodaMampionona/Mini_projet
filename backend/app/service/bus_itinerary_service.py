import psycopg2
import networkx as nx
from app.repository.bus_stop_link_repository import BusStopLinkRepository


class BusItineraryService:
    def __init__(self):
        self.linkRepo = BusStopLinkRepository()

    # TODO : les graph_edges par id au lieu de par nom
    # TODO : retourner au lieu d'afficher

    def get_bus_itinerary(self, start: str, destination: str):

        links = self.linkRepo.get_links_ordered_by_bus()

        # Création Graphe et itinéraire
        G = nx.Graph()
        itinerary = {}
        # ajout dictionnaires pour traduire ID -> nom 
        stop_names = {}   
        bus_names = {}   

        # Organiser arrêts par bus
        arrets_par_bus = {}
        for link in links:
            id_bus = link.bus.id
            id_arret = link.stop.id 
            nom_arret = link.stop.name
            ordre = link.rank
            
            #  ajout: stocker le nom pour l’étape finale
            stop_names[id_arret] = link.stop.name
            bus_names[id_bus] = link.bus.name
            
            if id_bus not in arrets_par_bus:
                arrets_par_bus[id_bus] = []
            arrets_par_bus[id_bus].append((ordre, id_arret))

        # tri des arrêts par "rank"
        for id_bus in arrets_par_bus:
            arrets_par_bus[id_bus].sort(key=lambda x: x[0])  # tri par ordre
            arrets_par_bus[id_bus] = [arret[1] for arret in arrets_par_bus[id_bus]]  # extraire juste l'id

        # création des arcs avec les ID
        for id_bus, liste_arrets in arrets_par_bus.items():
            for i in range(len(liste_arrets)-1):
                G.add_edge(liste_arrets[i], liste_arrets[i+1], bus=id_bus)  # bus stocké en ID

        # 🔥 Convertir start/destination (nom) → id
        start_id = None
        dest_id = None
        for sid, name in stop_names.items():
            if name == start:
                start_id = sid
            if name == destination:
                dest_id = sid

        if start_id is None:
            print('depart invalide')
            return
        if dest_id is None:
            print('destination invalide')
            return

        try:
            
            chemin = nx.shortest_path(G, source=start_id, target=dest_id)
            print("Chemin trouvé (ID) :", chemin)

            bus_actuel = None
            debut_segment = chemin[0]

            for i in range(len(chemin)-1):
                bus_id = G[chemin[i]][chemin[i+1]]['bus']  # 🔥 CHANGEMENT : bus_id au lieu de bus_name

                if bus_id != bus_actuel:
                    if bus_actuel is not None:
                        # 🔥 CHANGEMENT : reconstruire noms via dictionnaires
                        itinerary[bus_names[bus_actuel]] = (
                            stop_names[debut_segment],
                            stop_names[chemin[i]]
                        )

                    bus_actuel = bus_id
                    debut_segment = chemin[i]

            # Ajout du dernier segment (arrêt final)
            itinerary[bus_names[bus_actuel]] = (
                stop_names[debut_segment],
                stop_names[chemin[-1]]
            )

        except nx.NetworkXNoPath:
            print('aucun chemin trouvé')

        return itinerary
