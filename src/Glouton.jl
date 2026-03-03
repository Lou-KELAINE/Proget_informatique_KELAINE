# On récupère les fonctions annexes
include("annexe.jl")
using DataStructures

function Glouton(G, vD, vA)
    t1 = time()
    cpt = 0  # Compteur du nombre de points visités
    height = length(G)
    width = length(G[1])
    precedent = fill((0,0), height, width) # Matrice dans laquelle chaque point est associé son prédécesseur
    if (vD == vA) # Dans le cas où le départ et l'arrivée sont les mêmes
        t2 = (time() - t1)
        afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)]) # Affichage correspondant à celui de l'énoncé
        println("\nBFS\n\nSolution :\n CPUtime (s) : ", t2,"\n Distance D -> A : 0 \n Number of states evaluated : 0\n Path D -> A\n  ", vD)
        return
    end
    if (G[vA[1]][vA[2]] in ['@','T']) # Si le point d'arrivée est dans un '@' ou un 'T'
        t2 = (time() - t1)
        afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)])
        println(string("\nGlouton\n\nCPUtime (s) : ", t2, "\nNumber of states evaluated : 0\nIl est impossible d'aller au point ", vA, " en partant du point ", vD))
        return
    end
    precedent[vD[1],vD[2]] = vD # On met le prédécesseur du point de départ à lui même
    L = PriorityQueue{Tuple{Int,Int}, Float64}() # File avec priorité, à chaque point est associée sa valeur f
    enqueue!(L, vD, heuristique(vD, vA))
    while L != []
        u, v = peek(L)
        if (u == vA) # Si on trouve le point d'arrivée
            chemin = trouve_chemin(precedent, vD, vA, []) #On récupère le chemin menant à l'arrivée
            t2 = (time() - t1)
            afficher_map_avec_chemin(G, vD, vA, chemin) # Affichage demandé par l'énoncé
            println("\nGlouton\n\nSolution :\n CPUtime (s) : ", t2,"\n Distance D -> A : ", cout_chemin(chemin,G), "\n Number of states evaluated : ", cpt + 1, "\n Path D -> A\n  ", string_chemin(chemin))
            return
        end
        cpt += 1
        S = voisins_valides(u, G)
        for s in S
            if (precedent[s[1],s[2]] == (0,0)) # Si l'on a pas déjà visité le point
                enqueue!(L, s, heuristique(s, vA))
                precedent[s[1],s[2]] = u
            end
        end
        delete!(L, u)
    end
    t2 = (time() - t1)
    afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)])
    println(string("\nGlouton\n\nCPUtime (s) : ", t2, "\nNumber of states evaluated : ", cpt, "\nIl est impossible d'aller au point ", vA, " en partant du point ", vD))  # Si la liste est vide, alors le point d'arrivée est inaccessible
    return
end