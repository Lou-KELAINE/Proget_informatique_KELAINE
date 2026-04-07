# Auteur: Lou KELAINE
# Ce fichier contient l'algorithme de résolution des problèmes d'AMRs

# On récupère la fonction AStar2
include("AStar2.jl")

function AMR(G, liste_AMRs) # liste_AMRs est une liste de triplets (numéro, départ, arrivée, temps de départ)
    t1 = time() # On garde le temps en début d'exécution, utilisé pour calculer le temps d'execution
    height = length(G)
    width = length(G[1])
    liste_chemins = Vector(undef, length(liste_AMRs)) # Liste contenant chacun des chemins optimaux des AMRs
    AMRs_trie = sort(liste_AMRs, by = x -> x[4]) # On trie la liste des AMRs par leur temps de départ
    chemin  = AStar2(G, AMRs_trie[1][2], AMRs_trie[1][3], AMRs_trie[1][4]) # On calcule le chemin optimal pour le 1er AMR
    if (chemin == []) # Si l'arrivée du 1er est inaccessible
        println("\nLe 1er AMR a une destination innateignable, peu importe l'ordre de passage! Faites attention à ce que tous les AMRs aient un départ et une arrivée cohérente!")
        return
    end
    liste_chemins[AMRs_trie[1][1]] = chemin # Pas de contrainte supplémentaire pour le premier AMR, on rajoute directement son chemin optimal
    occup_cases = [[] for i in 1:height, j in 1:width] # Matrice dans laquelle se trouve à chaque point une liste des AMRs qui l'occupe à un certain temps, sous forme du couple (#AMR, t)
    for (point, tps) in liste_chemins[1] # On marque quelles cases sont prises par l'AMR1 et à quels moments
        push!(occup_cases[point[1], point[2]], (AMRs_trie[1][1],tps))
    end
    for num_amr in 2:length(AMRs_trie) # On s'attaque aux AMRs suivants
        G_contr = copy(G) # On copie la grille si besoin de bloquer des cases en plus
        chemin = AStar2(G_contr, AMRs_trie[num_amr][2], AMRs_trie[num_amr][3], AMRs_trie[num_amr][4]) # On calcule le chemin optimal de l'AMR
        if (chemin == []) # Si l'arrivée est innateignable
            println("\nL'un des AMRs a une destination innateignable, peu importe l'ordre de passage! Faites attention à ce que tous les AMRs aient un départ et une arrivée cohérente!")
            return
        else
            collision = verif_collision(occup_cases, chemin) # On vérifie s'il y a une collision dans le chemin de l'AMR
            while (collision[1] != (0,0)) # On retente jusqu'à ne plus avoir de collision
                G_contr = rajoute_symbole(G_contr, collision[1][1], collision[1][2], "@") # On rajoute un "mur" pour bloquer l'accès
                nouv_chemin = AStar2(G_contr, chemin[collision[2] - 1][1], AMRs_trie[num_amr][3], AMRs_trie[num_amr][4] + collision[2] - 2) # On part du point précédant la collision
                if (nouv_chemin == []) # Si l'AMR est bloqué
                    println("\nL'un des AMRs est bloqué!!! Essayez peut-être de changer la configuration ou l'ordre dans la liste!")
                    println("Attention: l'ordre de calcul des déplacements des AMRs est celui de la liste et non par temps de départ! Cela peut modifier les contraintes!")
                    return
                else
                    chemin = [chemin[1:(collision[2] - 2)]; nouv_chemin] # On raccroche les chemins pré et post-collision
                    collision = verif_collision(occup_cases, chemin)
                end
            end
            liste_chemins[AMRs_trie[num_amr][1]] = chemin # Une fois que le bon chemin est trouvé, on le rajoute à la liste...
            for (point, tps) in chemin # ...et on marque les cases occupées
                push!(occup_cases[point[1], point[2]], (AMRs_trie[num_amr][1],tps))
            end
        end
    end
    affiche_grille_temps(G, positions_temps(liste_chemins)) # On affiche les grilles à chaque temps
    println(string("\nTous les AMRs ont atteint leur destination (t=", temps_max(liste_chemins), ")"))
    for i in 1:length(liste_AMRs) # Et on montre les distances, coûts et temps des déplacements des AMRs
        println(string(" ", i, " : ", nb_pas(liste_chemins[i], G), " pas   coût=", length(liste_chemins[i])-1, "   (mission t=", liste_AMRs[i][4], "->t=", liste_chemins[i][end][2], ")"))
    end
    print(string("\nTemps d'éxécution: ", time() - t1, "s")) # Puis on rajoute le temps d'exécution
end