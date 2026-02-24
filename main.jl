include("BFS.jl")

function BFS(nomfic, vD, vA)
    fic = open(nomfic, "r")
    img = readlines(fic)
    close(fic)
    grille = img[5:length(img), :]
    algo_BFS(grille, vD, vA)
end