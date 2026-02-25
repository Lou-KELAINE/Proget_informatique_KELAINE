include("BFS.jl")

function afficheMapTerminal(fname)
    fic = open(string("../dat/",fname), "r")
    img = readlines(fic)
    close(fic)
    grille = img[5:length(img), :]
    println(string("Instance:\n ", fname[1:(length(fname)-4)], "\n\nMap of size:\n height: ", length(grille), "\n width: ", length(grille[1]), "\n"))
    afficher_map(grille)
end

function algoBFS(fname, vD, vA)
    fic = open(string("../dat/",fname), "r")
    img = readlines(fic)
    close(fic)
    grille = img[5:length(img), :]
    BFS(grille, vD, vA)
end