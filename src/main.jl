# On récupère les algortihmes
include("BFS.jl")
include("Dijkstra.jl")

# Affiche la map donnée en paramètre
function afficheMapTerminal(fname) 
    fic = open(string("../dat/",fname), "r") # Lecture du ficher
    img = readlines(fic) # Lecture du contenu du fichier ligne par ligne
    close(fic)
    grille = img[5:length(img), :] # On ne garde que la grille elle même
    println(string("Instance:\n ", fname[1:(length(fname)-4)], "\n\nMap of size:\n height: ", length(grille), "\n width: ", length(grille[1]), "\n")) # Affichage donnée dans l'énoncé
    afficher_map(grille)
end

# Applique l'algorithme BFS
function algoBFS(fname, vD, vA)
    fic = open(string("../dat/",fname), "r")
    img = readlines(fic)
    close(fic)
    grille = img[5:length(img), :]
    BFS(grille, vD, vA)
end

# Applique l'algorithme Drijkstra
function algoDrijkstra(fname, vD, vA)
    fic = open(string("../dat/",fname), "r")
    img = readlines(fic)
    close(fic)
    grille = img[5:length(img), :]
    Dijkstra(grille, vD, vA)
end