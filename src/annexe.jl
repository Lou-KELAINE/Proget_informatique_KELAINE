# Auteur: Lou KELAINE
# Ce fichier contient toutes les fonctions annexes utilisées par les différents algorithmes

# Permet d'afficher une map, utilisée par la fonction afficheMapTerminal de main.jl
function afficher_map(grille)
    print(" ")
    for i in 1: length(grille) # Affiche les numéros de colonnes (modulo 10 pour pouvoir aligner)
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
            elseif ((i,j) in chemin[2:(length(chemin)-1)])
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
    if ((i + 1 <= width) && (grille[i+1][j] != '@')) #bas
        push!(liste_voisins, (i+1,j))
    end
    if ((i - 1 >= 1) && (grille[i-1][j] != '@')) #haut
        push!(liste_voisins, (i-1,j))
    end
    if ((j - 1 >= 1) && (grille[i][j-1] != '@')) #gauche
        push!(liste_voisins, (i,j-1))
    end
    if ((j + 1 <= height) && (grille[i][j+1] != '@')) #droite
        push!(liste_voisins, (i,j+1))
    end
    return liste_voisins
end

# Donne le coût de déplacement vers un point de la grille
function cout(point, grille)
    (i,j) = point
    if (grille[i][j] == 'S' || grille[i][j] == 'T') # Coût de 5 pour le sable et les arbres
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