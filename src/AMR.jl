# On récupère la fonction AStar2
include("AStar2.jl")

function AMR(G, liste_AMRs) # liste_AMRs est une liste de triplets (départ, arrivée, temps de départ)
    liste_chemins = Vector{Vector{Tuple{Int,Int},Int}}(undef, length(liste_AMRs)) # Liste contenant chacun des chemins optimaux des AMRs
    liste_chemins[1] = AStar2(G, liste_AMRs[1][1], liste_AMRs[1][2], liste_AMRs[1][3]) # Pas de contrainte supplémentaire pour le premier AMR, on rajoute directement son chemin optimal
    occup_cases = fill([], height, width) # Matrice dans laquelle se trouve à chaque point une liste des AMRs qui l'occupe à un certain temps, sous forme du couple (#AMR, t)
    for (point, tps) in liste_chemins[1]
        push!(occup_cases[point[1], point[2]], (1,tps))
    end
    for num_amr in 2:length(liste_AMRs)
        G_contr = copy(G) # On copie la grille si besoin de bloquer des cases en plus
        chemin = AStar2(G_contr, liste_AMRs[num_amr][1], liste_AMRs[num_amr][2], liste_AMRs[num_amr][3])
        collision = verif_collision(occup_cases, chemin) 
        while (collision != (0,0))
            G_contr[collision[1], collision[2]] = '@'
            chemin = AStar2(G_contr, liste_AMRs[num_amr][1], liste_AMRs[num_amr][2], liste_AMRs[num_amr][3])
            collision = verif_collision(occup_cases, chemin)
        end
        liste_chemins[num_arr] = chemin
        for (point, tps) in chemin
            push!(occup_cases[point[1], point[2]], (1,tps))
        end
    end
end