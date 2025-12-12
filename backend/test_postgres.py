import psycopg2
import networkx as nx
from app.db.db_helper import DBHelper
from app.dao.bus_stop_link_dao import BusStopLinkDAO

conn = DBHelper().get_connection()
cur = conn.cursor()

cur.execute("""
    SELECT links.bus_id, stops.name, links.rank
    FROM bus_stop_links links
    JOIN bus_stops as stops ON links.stop_id = stops.id
    ORDER BY links.bus_id, links.rank
""")
rows = cur.fetchall()
cur.close()
conn.close()

# Création Graphe
G = nx.Graph()

arrets_par_bus = {}

# Organiser arrêts par bus
for id_bus, nom_arret, ordre in rows:
    if id_bus not in arrets_par_bus:
        arrets_par_bus[id_bus] = []
    arrets_par_bus[id_bus].append(nom_arret)

# Créer les arcs
for id_bus, liste_arrets in arrets_par_bus.items():
    for i in range(len(liste_arrets)-1):
        G.add_edge(liste_arrets[i], liste_arrets[i+1], bus=id_bus)

# Recherche d’itinéraire
depart = input("Entrez votre arrêt de départ : ")
if depart not in G:
    print('depart invalide')

destination = input("Entrez votre arrêt de destination : ")
if destination not in G:
    print('destination invalide')

# gérer si depart ou destination pas dans graphe

try:
    chemin = nx.shortest_path(G, source=depart, target=destination)
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
