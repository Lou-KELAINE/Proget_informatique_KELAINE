# On récupère les fonctions annexes
include("annexe.jl")

function BFS(G, vD, vA)
    t1 = time() # On garde le temps en début d'exécution, utilisé pour calculer le temps d'execution
    if (vD == vA) # Dans le cas où le départ et l'arrivée sont les mêmes
        t2 = (time() - t1)
        afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)]) # Affichage correspondant à celui de l'énoncé
        println("\nBFS\n\nSolution :\n CPUtime (s) : ", t2,"\n Distance D -> A : 0 \n Number of states evaluated : 0\n Path D -> A\n  ", vD)
        return
    end
    if (G[vA[1]][vA[2]] in ['@','T']) # Si le point d'arrivée est dans un '@' ou un 'T'
        t2 = (time() - t1)
        afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)])
        println(string("\nBFS\n\nCPUtime (s) : ", t2, "\nNumber of states evaluated : 0\nIl est impossible d'aller au point ", vA, " en partant du point ", vD))
        return
    end
    cpt = 0 # Compteur du nombre de points visités
    height = length(G)
    width = length(G[1])
    F = Vector{Tuple{Int,Int}}(undef, height*width) # Tableau représentant la file
    deb = 1 # J'utilise un indice de début et fin pour ne pas avoir à supprimer des valeurs (et donc devoir décaler tout le tableau)
    fin = 1
    F[deb] = vD
    precedent = fill((0,0), height, width)
    precedent[vD[1],vD[2]] = vD # On met le prédécesseur du point de départ à lui même
    while deb <= fin
        u = F[deb]
        deb += 1
        S = voisins_valides(u, G)
        for v in S
            if v == vA # Si l'on trouve le point d'arrivée
                precedent[v[1],v[2]] = u # On met à jour son prédécesseur 
                chemin = trouve_chemin(precedent, vD, vA, []) # On récupère le chemin accedant à ce point
                t2 = (time() - t1)
                afficher_map_avec_chemin(G, vD, vA, chemin)
                println("\nBFS\n\nSolution :\n CPUtime (s) : ", t2,"\n Distance D -> A : ", cout_chemin(chemin,G), "\n Number of states evaluated : ", cpt + 1, "\n Path D -> A\n  ", string_chemin(chemin)) # Affichage demandé par l'énoncé
                return
            elseif precedent[v[1],v[2]] == (0,0) # Si le point n'a pas déjà été visité
                cpt += 1
                precedent[v[1],v[2]] = u # On met à jour son prédécesseur
                fin += 1
                F[fin] = v
                
            end
        end
    end
    t2 = (time() - t1)
    afficher_map_avec_chemin(G, vD, vA, [(0,0),(0,0),(0,0)])
    println(string("\nBFS\n\nCPUtime (s) : ", t2, "\nNumber of states evaluated : ", cpt, "\nIl est impossible d'aller au point ", vA, " en partant du point ", vD)) # Si la liste est vide, alors le point d'arrivée est inaccessible
    return
end