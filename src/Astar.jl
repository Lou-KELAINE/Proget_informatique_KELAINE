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
    f = fill(Inf, height, width) # Matrice associant à chaque point la distance supposée de vD à vA en passant par ce point
    L = [vD]
    if (vD == vA) # Dans le cas où le départ et l'arrivée sont les mêmes
        afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)]) # Affichage correspondant à celui de l'énoncé
        println("\nBFS\n\nSolution :\n CPUtime (s) : ", (time() - t1),"\n Distance D -> A : 0 \n Number of states evaluated : 0\n Path D -> A\n  ", vD)
        return
    end
    if (G[vA[1]][vA[2]] == '@') # Si le point d'arrivée est dans un '@' 
        afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)])
        println(string("\nA*\n\nCPUtime (s) : ", (time() - t1), "\nNumber of states evaluated : 0\nIl est impossible d'aller au point ", vA, " en partant du point ", vD))
        return
    end
    g[vD[1], vD[2]] = 0
    f[vD[1], vD[2]] = heuristique(vD, vA)
    precedent[vD[1], vD[2]] = (0,0)
    while L != []
        u = nothing # On cherche le point avec le f le plus bas du tableau
        min_f = Inf
        indice = 1
        ind_min = 1
        for elt in L # Calcul du point le plus proche
            if f[elt[1],elt[2]] < min_f
                u = elt
                min_f = f[elt[1],elt[2]]
                ind_min = indice
            end
            indice += 1
        end
        if (u == vA) # Si l'on atteint l'arrivée
            chemin = trouve_chemin(precedent, vD, vA, []) #On récupère le chemin menant à l'arrivée
            afficher_map_avec_chemin(G, vD, vA, chemin) # Affichage demandé par l'énoncé
            println("\nA*\n\nSolution :\n CPUtime (s) : ", (time() - t1),"\n Distance D -> A : ", cout_chemin(chemin,G), "\n Number of states evaluated : ", cpt + 1, "\n Path D -> A\n  ", string_chemin(chemin))
            return
        end
        permanent[u[1],u[2]] = true # On rend le point permanent, pour ne plus le visiter
        L[ind_min] = L[end] # On attribue à la case de u la dernière valeur du tableau puis on supprime cette dernière (pour éviter d'avoir à décaler le tableau si on supprime au milieu)
        pop!(L)
        cpt += 1
        S = voisins_valides(u, G)
        for v in S
            if !permanent[v[1],v[2]]
                nouv_g = min(g[v[1],v[2]], g[u[1],u[2]] + cout(v, G))
                if nouv_g != g[v[1],v[2]] # Si l'on met à jour g(v) et f(v)
                    precedent[v[1],v[2]] = u
                    g[v[1],v[2]] = nouv_g
                    f[v[1],v[2]] = nouv_g + heuristique(v, vA)
                    push!(L, v)
                end
            end
        end
    end
    afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)])
    println(string("\nA*\n\nCPUtime (s) : ", (time() - t1), "\nNumber of states evaluated : ", cpt, "\nIl est impossible d'aller au point ", vA, " en partant du point ", vD))  # Si la liste est vide, alors le point d'arrivée est inaccessible
    return
end