# On récupère les fonctions annexes
include("annexe.jl")

function AStar2(G, vD, vA, tDep)
    height = length(G)
    width = length(G[1])
    if (vD == vA) # Dans le cas où le départ et l'arrivée sont les mêmes
        return [(vD, tDep)]
    end
    precedent = fill((0,0), height, width) # Matrice dans laquelle chaque point est associé son prédécesseur
    permanent = falses(height, width) # Matrice associant à chaque point un booléen indiquant s'il est permanent
    g = fill(Inf, height, width) # Matrice associant à chaque point le coût minimal pour aller de vD à ce point
    g[vD[1], vD[2]] = 0
    precedent[vD[1], vD[2]] = (0,0)
    L = PriorityQueue{Tuple{Int,Int}, Float64}() # File avec priorité, à chaque point est associée sa valeur f
    enqueue!(L, vD, heuristique(vD, vA))
    while L != []
        u, v = peek(L)
        if (u == vA) # Si l'on atteint l'arrivée
            return trouve_chemin_doublons(G, precedent, vD, vA, tDep,[]) #On récupère le chemin menant à l'arrivée
        end
        permanent[u[1],u[2]] = true # On rend le point permanent, pour ne plus le visiter
        cpt += 1
        S = voisins_valides(u, G)
        for s in S
            if !permanent[s[1],s[2]]
                nouv_g = min(g[s[1],s[2]], g[u[1],u[2]] + cout(s, G))
                if nouv_g != g[s[1],s[2]] # Si l'on met à jour g(s) et f(s)
                    precedent[s[1],s[2]] = u
                    g[s[1],s[2]] = nouv_g
                    L[s] = nouv_g + heuristique(s, vA)
                end
            end
        end
        delete!(L, u)
    end
end