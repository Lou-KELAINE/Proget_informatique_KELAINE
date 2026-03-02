# On récupère les fonctions annexes
include("annexe.jl")

function Dijkstra(G, vD, vA)
    t1 = time() # On garde le temps en début d'exécution, utilisé pour calculer le temps d'execution
    height = length(G)
    width = length(G[1])
    cpt = 0 # Compteur du nombre de points visités
    if (vD == vA) # Dans le cas où le départ et l'arrivée sont les mêmes
        afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)]) # Affichage correspondant à celui de l'énoncé
        println("\nBFS\n\nSolution :\n CPUtime (s) : ", (time() - t1),"\n Distance D -> A : 0 \n Number of states evaluated : 0\n Path D -> A\n  ", vD)
        return
    end
    if (G[vA[1]][vA[2]] == '@') # Si le point d'arrivée est dans un '@' 
        afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)])
        println(string("\nDrijkstra\n\nCPUtime (s) : ", (time() - t1), "\nNumber of states evaluated : 0\nIl est impossible d'aller au point ", vA, " en partant du point ", vD))
        return
    end
    distance = fill(Inf, height, width) # Matrice stockant la distance d'un point au point de départ
    precedent = fill((0,0), height, width) # Matrice dans laquelle chaque point est associé son prédécesseur
    permanent = falses(height, width) # Matrice associant à chaque point un booléen indiquant s'il est permanent
    distance[vD[1],vD[2]] = 0 # Le point de départ est à une distance nulle de lui même
    while true # La boucle n'a pas de condition d'arrêt, il y a des return qui s'en occupent
        u = nothing
        min_dist = Inf
        for i in 1:height
            for j in 1:width
                if (!(permanent[i,j]) && (distance[i,j] < min_dist))
                    min_dist = distance[i,j]
                    u = (i,j)
                end
            end
        end
        if (u == vA)
            chemin = trouve_chemin(precedent, vD, vA, []) #On récupère le chemin menant à l'arrivée
            afficher_map_avec_chemin(G, vD, vA, chemin) # Affichage demandé par l'énoncé
            println("\nDrijkstra\n\nSolution :\n CPUtime (s) : ", (time() - t1),"\n Distance D -> A : ", cout_chemin(chemin,G), "\n Number of states evaluated : ", cpt + 1, "\n Path D -> A\n  ", string_chemin(chemin))
            return
        end
        if (isnothing(u))
            afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)])
                println(string("\nDrijkstra\n\nCPUtime (s) : ", (time() - t1), "\nNumber of states evaluated : ", cpt + 1, "\nIl est impossible d'aller au point ", vA, " en partant du point ", vD))  # Si la liste est vide, alors le point d'arrivée est inaccessible
            return
        end
        permanent[u[1],u[2]] = true # On rend le point permanent, pour ne plus le visiter
        cpt += 1
        S = voisins_valides(u, G)
        for v in S
            if !permanent[v[1],v[2]]
                nouv_dist = min(distance[v[1],v[2]], distance[u[1],u[2]] + cout(v, G))
                if nouv_dist != distance[v[1],v[2]] # Si l'on met à jour distance(v)
                    distance[v[1],v[2]] = nouv_dist
                    precedent[v[1],v[2]] = u
                end
            end
        end
    end
end