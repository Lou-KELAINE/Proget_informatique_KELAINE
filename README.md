# Lou KELAINE
# Projet d'informatique scientifique

## Installation:

Téléchargez les dossiers présents dans le git et placez les dans un seul dossier.
Il est impératif que les dossiers src/ et data/ soient mis au même endroit.

## Exécution:

Rendez-vous dans le dossier src/ puis lancez le REPL Julia avec la commande "julia" puis faites "include("main.jl")" afin de compiler le fichier.
Il y a 6 commandes disponibles:

algoBFS(fname, D, A)

algoDijkstra(fname, D, A)

algoAstar(fname, D, A)

algoGlouton(fname, D, A)

afficheMapTerminal(fname)

algoAMR(fname, liste_AMRs)

avec fname le nom du fichier (par besoin de rajouter le "../" avant le nom du fichier mais le .map est nécessaire), D le point de départ, A l'arrivée et liste_AMRs une liste de tuples (départ, arrivée, temps_départ).

Pour éxécuter l'une des commandes, il suffit de la saisir sur le REPL Julia.

## Informations supplémentaires:

- Les seuls symboles sur la carte ayant un effet particulier sont le '@', le 'T' (infranchissables), le 'W' et le 'S' (ayant un coût respectif de 8 et 5), tout autre symbole sera considéré comme ayant un coût de 1.

- Si le point de départ est un '@' ou un 'T' mais que ce même point est aussi l'arrivée, la décision a été prise de considérer cela comme un succès et non un échec.

- Vous pouvez partir d'un '@' ou d'un 'T' sans problème (si vous êtes entourés de ces derniers, vous ne pourrez pas avancer de toute façon)

- Le temps d'exécution affiché ne comprend que la durée de recherche du chemin, l'affichage de la map n'est pas compté car il faisait juste perdre plusieurs secondes inutilement sur les grandes cartes.

- Pour algoAMR, la numérotation des AMRs ainsi que l'ordre des calculs des chemins correspondent à l'odre de la liste fournie.
  - Cela signifie que l'AMR1 correspondra au 1er AMR de la liste, AMR2 au second, etc...
  - Si vous souhaitez avoir un ordre par temps de départ, il faut donc que les AMRs soit donnés dans cet ordre dans liste_AMRs
 
- Encore pour algoAMR, l'option permettant à un AMR de rester sur place et attendre n'a pas été implémentée, il peut donc y avoir des blocages qui auraient pû être résolus si les AMRs savaient rester sur place.
