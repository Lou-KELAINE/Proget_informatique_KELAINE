# Auteur: Lou KELAINE
# Ce fichier contient toutes les fonctions annexes utilisées par les différents algorithmes

# Permet d'afficher une map, utilisée par la fonction afficheMapTerminal de main.jl
function afficher_map(grille)
    print(" ")
    for i in 1: length(grille[1]) # Affiche les numéros de colonnes (modulo 10 pour pouvoir aligner)
        print(i%10)
    end
    print("\n")
    for i in 1:length(grille) # Affiche les numéros des lignes avec lesdites lignes
        println(string(i%10, grille[i]))
    end
end

# Permet d'afficher une map avec les points de départ et d'arrivée, utilisée par les algorithmes lors de l'affichage final
function afficher_map_avec_chemin(grille, vD, vA, chemin)
    for i in 1:length(grille)
        for j in 1:length(grille[1]) # Pour chaque point, on affiche sa valeur, sauf pour les points de départ et arrivée où l'on affiche respectivement D et A
            if ((i,j) == vD)
                print('D')
            elseif ((i,j) == vA)
                print('A')
            elseif ((i,j) in chemin[2:(length(chemin)-1)]) # On met un X sur chaque point du chemin
                print('X')
            else
                print(grille[i][j])
            end
        end
        println("")
    end
end

# Pour un point sur une grille, donne la liste de ses voisins sur lesquels il est possible de se déplacer
function voisins_valides(point, grille)
    liste_voisins = []
    (i,j) = point
    height = length(grille)
    width = length(grille[1])
    if ((i - 1 >= 1) && !(grille[i-1][j] in ['@','T'])) #haut
        push!(liste_voisins, (i-1,j))
    end
    if ((j + 1 <= width) && !(grille[i][j+1] in ['@','T'])) #droite
        push!(liste_voisins, (i,j+1))
    end
    if ((i + 1 <= height) && !(grille[i+1][j] in ['@','T'])) #bas
        push!(liste_voisins, (i+1,j))
    end
    if ((j - 1 >= 1) && !(grille[i][j-1] in ['@','T'])) #gauche
        push!(liste_voisins, (i,j-1))
    end
    return liste_voisins
end


# Donne le coût de déplacement vers un point de la grille
function cout(point, grille)
    (i,j) = point
    if (grille[i][j] == 'S') # Coût de 5 pour le sable
        return 5
    elseif grille[i][j] == 'W' # Coût de 8 pour l'eau
        return 8
    else 
        return 1 # Coût de 1 pour le reste
    end
end

# Permet de retrouver le chemin allant du point de départ au point d'arrivée en utilisant une matrice d'antécédants
function trouve_chemin(antecedants, dep, arr, liste)
    pushfirst!(liste, arr)
    if (dep == arr) # On arrête lorsque l'on a retrouvé le point de départ
        return liste
    else
        return trouve_chemin(antecedants, dep, antecedants[arr[1],arr[2]], liste) # Appel récursif sur l'antécédant du point
    end
end

# Donne la chaîne de caractères représentant le chemin du point de départ au point d'arrivée
function string_chemin(l)
    ch = ""
    for i in 2:length(l) # On affiche le point suivu d'une flèche
        ch = string(ch , l[i-1], "->")
    end
    ch = string(ch , l[length(l)]) # On affiche le dernier point
    return ch
end

# Détermine le coût total d'un chermin
function cout_chemin(l, grille)
    total = 0
    for i in 2:length(l) # On ne compte pas le coût du point de départ, puisque l'on y est déjà
        total += cout(l[i], grille)
    end
    return total
end

# Fonction heuristique
function heuristique(a,b)
    return abs(a[1]-b[1]) + abs(a[2]-b[2])
end

# A partir de maintenant se trouvent les fonctions ajoutées pour le problème des liste_AMRs

# Même chose que trouve_chemin, en mettant cette fois plusieurs fois la même case en cas de coûts supérieurs à 1, utilisée pour la version AMR du problème
function trouve_chemin_doublons(grille, antecedants, dep, arr, tps, liste)
    cout_case = cout(arr, grille)
    for i in 1:cout_case # On met la case autant de fois que nécéssaire
        pushfirst!(liste, (arr, 0)) # Puisqu'il n'est pas possible de connaître à l'avance le nombre de cases parcourues, on met d'abord le temps à 0
    end
    if (dep == arr) # On arrête lorsque l'on a retrouvé le point de départ
        for i in 1:length(liste) # On met le temps à jour
            liste[i] = (liste[i][1], tps-1+i) # Obligé de créér un nouveau tuple car leur modification semble interdite en Julia?
        end
        return liste
    else
        return trouve_chemin_doublons(grille, antecedants, dep, antecedants[arr[1],arr[2]], tps, liste) # Appel récursif sur l'antécédant du point
    end
end

# Fonction vérifiant s'il y a une collision entre 2 AMRs, renvoie le point et le moment de la collision le cas échant
function verif_collision(occup, chemin)
    for i in 1:(length(chemin) -1) # On vérifie l'acccesibilité de chaque point du chemin (hormis le point de départ)
        for (amr, t) in occup[chemin[i+1][1][1], chemin[i+1][1][2]] # On regarde tous les instants où le point suivant est occupé
            if ((t == chemin[i+1][2]) || ((t == (chemin[i+1][2] -1)) && ((amr, t+1) in occup[chemin[i][1][1],chemin[i][1][2]]))) # Si il y a déjà un AMR à cette case au temps t ou qu'il y a un croisement
                return (chemin[i+1][1], i+1) # On renvoie la position de la collision
            end
        end
    end
    return ((0,0),0) # Si il n'y a pas de collision
end

# Fonction rajoutant un symbole donné à un point précis de la grille
function rajoute_symbole(G, x, y, symb)
    H = copy(G)
    ligne = ""
    for i in 1:length(H[x]) # On parcourt la ligne du symbole
        if (i == y) # On met le symbole si on est à la bonne position...
            ligne = string(ligne, symb)
        else # ..et on met le symbole d'origine sinon
            ligne = string(ligne, H[x][i])
        end
    end
    H[x] = ligne
    return H
end

# Fonction crééant le dictonnaire des temps
function positions_temps(liste_chemins)
    dico = Dict{Int, Vector{Tuple{Int, Tuple{Int,Int}}}}() # Dictionnaire ayant pour clé le temps t, pour valeur la liste des numéros des AMRs et leur position
    for i in 1:length(liste_chemins) # Pour chaque AMR on rajoute son numéro et sa position à chaque temps
        for ((point), t) in liste_chemins[i]
            if !(haskey(dico, t))
                dico[t] = [(i, point)]
            else
                push!(dico[t], (i, point))
            end
        end
    end
    return dico
end

# Fonction affichant la grille à chaque temps
function affiche_grille_temps(G, dico_temps)
    for temps in 1:maximum(keys(dico_temps)) # On fait un affichage à chaque unité de temps
        liste_points = dico_temps[temps] # On récupère les AMRs se trouvant sur la grille à ce temps
        print(string("\nt=", temps, "\n")) # On affiche le temps actuel...
        for (num, point) in liste_points
            print(string("AMR", num, ": ", point, "   ")) # ... et les AMRs présents avec leur position
        end
        print("\n")
        H = copy(G)
        for (num, point) in liste_points # On rajoute les numéros des AMRs à leur position respective
            H = rajoute_symbole(H, point[1], point[2], string(num))
        end
        for i in 1:length(H) # Et on imprime la nouvelle grille
            println(H[i])
        end
    end
end

# Fonction donnant le temps pris pour que tous les AMRs atteignent leur destination
function temps_max(liste_chemins)
    max = 0
    for i in 1:length(liste_chemins)
        if liste_chemins[i][end][2] > max
            max = liste_chemins[i][end][2]
        end
    end
    return max
end

# Fonction calculant le nombre de pas d'un chemin
function nb_pas(chemin, G)
    nb = 0
    i = 1
    long = length(chemin)
    while i < long
        nb += 1
        i += cout(chemin[i][1], G)
    end
    return nb
end