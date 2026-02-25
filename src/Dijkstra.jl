# On récupère les fonctions annexes
include("annexe.jl")

function Dijkstra(G, vD, vA)
    t1 = time() # On garde le temps en début d'exécution, utilisé pour calculer le temps d'execution
    height = length(G)
    width = length(G[1])
    cpt = 0 # Compteur du nombre de points visités
    distance = Dict() # Dictionnaire ayant pour clé un point, pour valeur sa distance au point de départ
    precedent = Dict() # Dictionnaire ayant pour clé un point, pour valeur son prédécesseur
    permanent = Dict() # Dictionnaire ayant pour clé un point, pour valeur un booléen indiquant s'il est permanent
    L = []
    for i in 1:height # Initialisation des dictionnaires et de la liste
        for j in 1:width
            if G[i][j] != '@'
                distance[(i,j)] = Inf
                precedent[(i,j)] = (0,0)
                permanent[(i,j)] = false
                push!(L, (i,j))
            end
        end
    end
    distance[vD] = 0 # Le point de départ est à une distance nulle de lui même
    while L != []
        u = nothing
        min_dist = Inf
        indice = 1
        ind_min = 1
        for elt in L # Calcul du point le plus proche
            if distance[elt] < min_dist
                u = elt
                min_dist = distance[elt]
                ind_min = indice
            end
            indice += 1
        end
        permanent[u] = true # On rend le point permanent, pour ne plus le visiter
        deleteat!(L, ind_min) # Et on le supprime de la liste
        cpt += 1
        S = voisins_valides(u, G)
        for v in S
            if !permanent[v]
                nouv_dist = min(distance[v], distance[u] + cout(v, G))
                if nouv_dist != distance[v] # Si l'on met à jour distance(v)
                    distance[v] = nouv_dist
                    precedent[v] = u
                end
            end
        end
    end
    afficher_map_avec_DA(G, vD, vA) # Affichage demandé par l'énoncé
    chemin = trouve_chemin(precedent, vD, vA, []) #On récupère le chemin menant à l'arrivée
    println("\nBFS\n\nSolution :\n CPUtime (s) : ", (time() - t1)*(1e-6),"\n Distance D -> A : ", cout_chemin(chemin,G), "\n Number of states evaluated : ", cpt + 1, "\n Path D -> A\n  ", string_chemin(chemin))
end