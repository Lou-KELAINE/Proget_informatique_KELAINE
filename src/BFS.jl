# On récupère les fonctions annexes
include("annexe.jl")

function BFS(G, vD, vA)
    t1 = time() # On garde le temps en début d'exécution, utilisé pour calculer le temps d'execution
    if (vD == vA) # Dans le cas où le départ et l'arrivée sont les mêmes
        afficher_map_avec_DA(G, vD, vA) # Affichage correspondant à celui de l'énoncé
        println("\nBFS\n\nSolution :\n CPUtime (s) : ", (time() - t1)*(1e-6),"\n Distance D -> A : 0 \n Number of states evaluated : 0\n Path D -> A\n  ", vD)
        return
    end
    cpt = 0 # Compteur du nombre de points visités
    height = length(G)
    width = length(G[1])
    F = [vD] # File utilisée pour l'algorithme BFS
    predecesseurs = fill((0,0), (height, width)) # Matrice dans laquelle l'élément à la position (i,j) est le "prédécesseur" dudit point
    predecesseurs[vD[1],vD[2]] = vD # Le point de départ est son propre prédécesseur
    while F != []
        u = popfirst!(F)
        S = voisins_valides(u, G)
        for s in S
            if s == vA # Si l'on trouve le point d'arrivée
                afficher_map_avec_DA(G, vD, vA)
                predecesseurs[s[1],s[2]] = u # On met à jour son prédécesseur
                chemin = trouve_chemin(predecesseurs, vD, vA, []) # On récupère le chemin accedant à ce point
                println("\nBFS\n\nSolution :\n CPUtime (s) : ", (time() - t1)*(1e-6),"\n Distance D -> A : ", cout_chemin(chemin,G), "\n Number of states evaluated : ", cpt + 1, "\n Path D -> A\n  ", string_chemin(chemin)) # Affichage demandé par l'énoncé
                return
            elseif predecesseurs[s[1],s[2]] == (0,0) # Si le point n'a pas déjà été visité
                cpt += 1
                predecesseurs[s[1],s[2]] = u # On met à jour son prédécesseur
                push!(F, s) # On l'empile
                
            end
        end
    end
    afficher_map_avec_DA(G, vD, vA)
    println(string("Il est impossible d'aller au point ", vA, " en partant du point ", vD)) # Si la file est vide, alors le point d'arrivée est inaccessible
    return
end