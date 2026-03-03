# On récupère les fonctions annexes
include("annexe.jl")

function Astar(G, vD, vA)
    t1 = time() # On garde le temps en début d'exécution, utilisé pour calculer le temps d'execution
    height = length(G)
    width = length(G[1])
    cpt = 0 # Compteur du nombre de points visités
    precedent = fill((0,0), height, width) # Matrice dans laquelle chaque point est associé son prédécesseur
    permanent = falses(height, width) # Matrice associant à chaque point un booléen indiquant s'il est permanent
    g = fill(Inf, height, width) # Matrice associant à chaque point le coût minimal pour aller de vD à ce point
    if (vD == vA) # Dans le cas où le départ et l'arrivée sont les mêmes
        t2 = (time() - t1)
        afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)]) # Affichage correspondant à celui de l'énoncé
        println("\nBFS\n\nSolution :\n CPUtime (s) : ", t2,"\n Distance D -> A : 0 \n Number of states evaluated : 0\n Path D -> A\n  ", vD)
        return
    end
    if (G[vA[1]][vA[2]] in ['@','T']) # Si le point d'arrivée est dans un '@' ou un 'T'
        t2 = (time() - t1)
        afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)])
        println(string("\nA*\n\nCPUtime (s) : ", t2, "\nNumber of states evaluated : 0\nIl est impossible d'aller au point ", vA, " en partant du point ", vD))
        return
    end
    g[vD[1], vD[2]] = 0
    precedent[vD[1], vD[2]] = (0,0)
    L = PriorityQueue{Tuple{Int,Int}, Float64}() # File avec priorité, à chaque point est associée sa valeur f
    enqueue!(L, vD, heuristique(vD, vA))
    while L != []
        u, v = peek(L)
        if (u == vA) # Si l'on atteint l'arrivée
            chemin = trouve_chemin(precedent, vD, vA, []) #On récupère le chemin menant à l'arrivée
            t2 = (time() - t1)
            afficher_map_avec_chemin(G, vD, vA, chemin) # Affichage demandé par l'énoncé
            println("\nA*\n\nSolution :\n CPUtime (s) : ", t2,"\n Distance D -> A : ", cout_chemin(chemin,G), "\n Number of states evaluated : ", cpt + 1, "\n Path D -> A\n  ", string_chemin(chemin))
            return
        end
        permanent[u[1],u[2]] = true # On rend le point permanent, pour ne plus le visiter
        cpt += 1
        S = voisins_valides(u, G)
        for s in S
            if !permanent[s[1],s[2]]
                nouv_g = min(g[s[1],s[2]], g[u[1],u[2]] + cout(s, G))
                if nouv_g != g[s[1],s[2]] # Si l'on met à jour g(s) et f(s)
                    precedent[s[1],s[2]] = u
                    g[s[1],s[2]] = nouv_g
                    L[s] = nouv_g + heuristique(s, vA)
                end
            end
        end
        delete!(L, u)
    end
    t2 = (time() - t1)
    afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)])
    println(string("\nA*\n\nCPUtime (s) : ", t2, "\nNumber of states evaluated : ", cpt, "\nIl est impossible d'aller au point ", vA, " en partant du point ", vD))  # Si la liste est vide, alors le point d'arrivée est inaccessible
    return
end