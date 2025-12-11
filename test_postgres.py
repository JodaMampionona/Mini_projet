import psycopg2
import networkx as nx

try:
    conn = psycopg2.connect(
        host="localhost",
        database="betax",
        user="postgres",
        password="mdp",
        port=5432
    )

    print("Connexion réussie !")

except Exception as e:
    print("Erreur :", e)
    
cur = conn.cursor()

# Récupérer les arrêts avec les bus
cur.execute("""
    SELECT ab.id_bus, a.nom_arret, ab.ordre
    FROM bus_arret ab
    JOIN arret a ON ab.id_arret = a.id_arret
    ORDER BY ab.id_bus, ab.ordre
""")
rows = cur.fetchall()
cur.close()
conn.close()

# Création Graphe 
G = nx.Graph()

arrets_par_bus = {}

#Organiser arrêts par bus
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
destination = input("Entrez votre arrêt de destination : ")

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
                print(f"Prendre le bus {bus_actuel} de {debut_segment} → {chemin[i]}")

            # Nouveau segment
            bus_actuel = bus
            debut_segment = chemin[i]

    # Afficher le dernier segment
    print(f"Prendre le bus {bus_actuel} de {debut_segment} → {destination}")

except nx.NetworkXNoPath:
    print("Aucun chemin trouvé entre ces deux arrêts.")
