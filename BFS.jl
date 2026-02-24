include("annexe.jl")

function algo_BFS(G, vD, vA)
    if (vD == vA)
        println(0)
        return true
    end
    height = length(G)
    width = length(G[1])
    cpt = 1
    F = [vD]
    vus = fill('.', (height, width))
    vus[vD[1],vD[2]] = '1'
    chemin = [vD]
    afficher_matrice(vus)
    println("")
    while F != []
        u = popfirst!(F)
        S = voisins_valides(u, G)
        for s in S
            if s == vA
                vus[s[1],s[2]] = '1'
                push!(chemin, s)
                afficher_matrice(vus)
                liste_visites(chemin)
                println(string("Le chemin allant de ", vD, " à ", vA, " comporte ", (cpt + 1), " points"))
                return
            elseif vus[s[1],s[2]] == '.'
                cpt += 1
                vus[s[1],s[2]] = '1'
                afficher_matrice(vus)
                println("")
                push!(F, s)
                push!(chemin, s)
            end
        end
    end
    println(string("Il est impossible d'aller au point ", vA, " en partant du point ", vD))
    return
end