function afficher_tableau(grille)
    for i in 1:length(grille)
        println(grille[i])
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

function liste_visites(l)
    ch = "Les points visités sont : "
    for i in 2:(length(l) -1)
        ch = string(ch , l[i], "->")
    end
    ch = string(ch , l[length(l)])
    println(ch)
end