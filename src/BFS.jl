include("annexe.jl")

function BFS(G, vD, vA)
    t1 = time()
    if (vD == vA)
        println(0)
        return true
    end
    cpt = 0
    height = length(G)
    width = length(G[1])
    F = [vD]
    predecesseurs = fill((0,0), (height, width))
    predecesseurs[vD[1],vD[2]] = vD
    while F != []
        u = popfirst!(F)
        S = voisins_valides(u, G)
        for s in S
            if s == vA
                afficher_map_avec_DA(G, vD, vA)
                predecesseurs[s[1],s[2]] = u
                chemin = trouve_chemin(predecesseurs, vD, vA, [])
                println("\nBFS\n\nSolution :\n CPUtime (s) : ", (time() - t1)*(1e-6),"\n Distance D -> A : ", length(chemin) - 1, "\n Number of states evaluated : ", cpt + 1, "\n Path D -> A\n  ", liste_visites(chemin))
                return
            elseif predecesseurs[s[1],s[2]] == (0,0)
                cpt += 1
                predecesseurs[s[1],s[2]] = u
                push!(F, s)
                
            end
        end
    end
    println(string("Il est impossible d'aller au point ", vA, " en partant du point ", vD))
    return
end