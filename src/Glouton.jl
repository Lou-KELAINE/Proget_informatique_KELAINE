# On récupère les fonctions annexes
include("annexe.jl")

function Glouton(G, vD, vA)
    t1 = time()
    L = [vD]
    precedent = fill((0,0), height, width) # Matrice dans laquelle chaque point est associé son prédécesseur
    cpt = 0  # Compteur du nombre de points visités
    height = length(G)
    width = length(G[1])
    if (G[vA[1]][vA[2]] == '@') # Si le point d'arrivée est dans un '@' 
        afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)])
        println(string("\nGlouton\n\nCPUtime (s) : ", (time() - t1), "\nIl est impossible d'aller au point ", vA, " en partant du point ", vD))
        return
    end
    precedent[vD[1],vD[2]] = vD # On met le prédécesseur du point de départ à lui même
    while L != []
        u = nothing # On cherche le point de la liste ayant l'heuristique le plus bas
        min_h = Inf
        indice = 1
        ind_min = 1
        for elt in L
            h = heuristique(elt, vA)
            if (h < min_h)
                u = elt
                min_h = h
                ind_min = indice
            end
            indice += 1
        end
        if (u == vA) # Si on trouve le point d'arrivée
            chemin = trouve_chemin(precedent, vD, vA, []) #On récupère le chemin menant à l'arrivée
            afficher_map_avec_chemin(G, vD, vA, chemin) # Affichage demandé par l'énoncé
            println("\nGlouton\n\nSolution :\n CPUtime (s) : ", (time() - t1),"\n Distance D -> A : ", cout_chemin(chemin,G), "\n Number of states evaluated : ", cpt + 1, "\n Path D -> A\n  ", string_chemin(chemin))
            return
        end
        L[ind_min] = L[end] # On attribue à la case de u la dernière valeur du tableau puis on supprime cette dernière (pour éviter d'avoir à décaler le tableau si on supprime au milieu)
        pop!(L)
        cpt += 1
        S = voisins_valides(u, G)
        for v in S
            if (precedent[v[1],v[2]] == (0,0)) # Si l'on a pas déjà visité le point
                push!(L, v)
                precedent[v[1],v[2]] = u
            end
        end
    end
    afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)])
    println(string("\nGlouton\n\nCPUtime (s) : ", (time() - t1), "\nIl est impossible d'aller au point ", vA, " en partant du point ", vD))  # Si la liste est vide, alors le point d'arrivée est inaccessible
    return
end