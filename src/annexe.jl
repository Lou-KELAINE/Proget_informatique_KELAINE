function afficher_map(grille)
    print(" ")
    for i in 1: length(grille)
        print(i%10)
    end
    print("\n")
    for i in 1:length(grille)
        println(string(i%10, grille[i]))
    end
end

function afficher_map_avec_DA(grille, vD, vA)
    for i in 1:length(grille)
        for j in 1:length(grille[1])
            if ((i,j) == vD)
                print('D')
            elseif ((i,j) == vA)
                print('A')
            else
                print(grille[i][j])
            end
        end
        println("")
    end
end

function afficher_matrice(grille)
    for i in 1:size(grille, 1)
        println(grille[i, :])
    end
end

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

function cout(point, grille)
    (i,j) = point
    if grille[i][j] == "S"
        return 5
    elseif grille[i][j] == "W"
        return 8
    else 
        return 1
    end
end

function trouve_chemin(grille, dep, arr, liste)
    pushfirst!(liste, arr)
    if (dep == arr)
        return liste
    else
        return trouve_chemin(grille, dep, grille[arr[1],arr[2]], liste)
    end
end

function liste_visites(l)
    ch = ""
    for i in 2:length(l)
        ch = string(ch , l[i-1], "->")
    end
    ch = string(ch , l[length(l)])
    return ch
end