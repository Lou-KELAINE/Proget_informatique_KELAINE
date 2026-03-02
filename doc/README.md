# Lou KELAINE
# Projet d'informatique scientifique

## Installation:

Téléchargez les dossiers présents dans le git et placez les dans un seul dossier.
Il est impératif que les dossiers src/ et data/ soient mis au même endroit.

## Execution:

Rendez-vous dans le dossier src/ puis lancez le REPL Julia avec la commande "julia" puis faites "include("main.jl")" afin de compiler le fichier.
Il y a 5 commandes disponibles:
algoBFS(fname, D, A)
algoDijkstra(fname, D, A)
algoAstar(fname, D, A)
algoGlouton(fname, D, A)
afficheMapTerminal(fname)

avec fname le nom du fichier (par besoin de rajouter le "../" avant le nom du fichier, le code s'en charge déjà), D le point de départ et A l'arrivée.

Pour éxécuter l'une des commandes, il suffit de la saisir sur le REPL Julia.

## Informations supplémentaires:

- Les seuls symboles sur la carte ayant un effet particulier sont le '@' (infranchissable), le 'W', le 'T' et le 'S' (ayant un coût respectif de 8, 5 et 5), tout autre symbole sera considéré comme ayant un coût de 1.

- Si le point de départ est un '@' mais que ce même point est aussi l'arrivée, la décision a été prise de considérer celà comme un succès et non un échec.

- N'étant pas sûr d'être autorisé à utiliser le package DataStructures contenant les PriorityQueue, les algorithmes Glouton, A* et surtout Dijkstra s'en retrouvent bien moins optimisés que souhaité dans cette version de mi-parcours. Si l'autorisation est donnée quant à l'utilisation du package, je modifierai mon implémentation avec ce dernier pour le rendu final.
