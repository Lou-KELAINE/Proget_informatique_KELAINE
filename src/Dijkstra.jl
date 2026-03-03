# On récupère les fonctions annexes
include("annexe.jl")
using DataStructures

function Dijkstra(G, vD, vA)
    t1 = time() # On garde le temps en début d'exécution, utilisé pour calculer le temps d'execution
    height = length(G)
    width = length(G[1])
    cpt = 0 # Compteur du nombre de points visités
    if (vD == vA) # Dans le cas où le départ et l'arrivée sont les mêmes
        t2 = (time() - t1)
        afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)]) # Affichage correspondant à celui de l'énoncé
        println("\nBFS\n\nSolution :\n CPUtime (s) : ", t2,"\n Distance D -> A : 0 \n Number of states evaluated : 0\n Path D -> A\n  ", vD)
        return
    end
    if (G[vA[1]][vA[2]] in ['@','T']) # Si le point d'arrivée est dans un '@' ou dans un 'T'
        t2 = (time() - t1)
        afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)])
        println(string("\nDrijkstra\n\nCPUtime (s) : ", t2, "\nNumber of states evaluated : 0\nIl est impossible d'aller au point ", vA, " en partant du point ", vD))
        return
    end
    L = PriorityQueue{Tuple{Int,Int}, Float64}() # File avec priorité, à chaque point est associée sa distance au départ
    precedent = fill((0,0), height, width) # Matrice dans laquelle chaque point est associé son prédécesseur
    permanent = falses(height, width) # Matrice associant à chaque point un booléen indiquant s'il est permanent
    for i in 1:height
        for j in 1:width
            if !(G[i][j] in ['@','T'])
                enqueue!(L, (i,j), Inf) # On remplie la file 
            end
        end
    end
    L[vD] = 0 # Le point de départ est à une distance nulle de lui même
    while !isempty(L)
        u, v = peek(L) # On récupère la première valeur de la file (aka celle avec la distance la plus basse), elle sera supprimée de la liste après
        if (u == vA)
            chemin = trouve_chemin(precedent, vD, vA, []) #On récupère le chemin menant à l'arrivée
            t2 = (time() - t1)
            afficher_map_avec_chemin(G, vD, vA, chemin) # Affichage demandé par l'énoncé
            println("\nDrijkstra\n\nSolution :\n CPUtime (s) : ", t2,"\n Distance D -> A : ", cout_chemin(chemin,G), "\n Number of states evaluated : ", cpt + 1, "\n Path D -> A\n  ", string_chemin(chemin))
            return
        end
        if (v == Inf) # Si il n'y a plus de point accessible
            t2 = (time() - t1)
            afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)])
            println(string("\nDrijkstra\n\nCPUtime (s) : ", t2, "\nNumber of states evaluated : ", cpt + 1, "\nIl est impossible d'aller au point ", vA, " en partant du point ", vD))  # Si la liste est vide, alors le point d'arrivée est inaccessible
            return
        end
        permanent[u[1],u[2]] = true # On rend le point permanent, pour ne plus le visiter
        cpt += 1
        S = voisins_valides(u, G)
        for s in S
            if !permanent[s[1],s[2]]
                nouv_dist = min(L[s], L[u] + cout(s, G))
                if nouv_dist != L[s] # Si l'on met à jour distance(s)
                    L[s] = nouv_dist
                    precedent[s[1],s[2]] = u
                end
            end
        end
        delete!(L, u) # Nous n'avons plus besoin de u, nous pouvons le supprimer
    end
end