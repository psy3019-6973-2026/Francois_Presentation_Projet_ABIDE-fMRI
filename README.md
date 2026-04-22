# Francois_Presentation_Projet_ABIDE-fMRI
Présentation des tâches pour le projet ABIDE-fMRI

## 1. Présentation du projet initial :

**Projet initial** :  
**[*Using fMRI Data to Predict Autism Diagnoses with Machine Learning*](https://github.com/brainhack-school2020/abide-fmri)**

### Présentation du projet:  

Le projet initialement réalisé par Emily Chen, Andréanne Proulx et Mikkel Schöttner vise à explorer le potentiel de l’IRMf pour classer des participants présentant un trouble du spectre de l’autisme et des contrôles typiques. Pour cela, ils utilisent des méthodes de machine learning = appliquées à des données d’IRMf au repos et à des mesures de connectivité cérébrale.

### Présentation des données:  
Les données utilisées proviennent du dataset **[ABIDE – Autism Brain Imaging Data Exchange](https://fcon_1000.projects.nitrc.org/indi/abide/)**, une base de données ouverte regroupant des données d’IRMf au repos prétraitées. Le ABIDE contient 1112 jeux de données au total, composés de :
- 539 participants avec un diagnostic de TSA
- 573 participants contrôles typiques (TD)

Le jeu de donnée provient de plus de 20 sites de recherche internationaux.

### Présentation de la méthode:

Le projet repose sur l’extraction de matrices de connectivité fonctionnelle à partir de données d’IRMf au repos. Ces matrices servent ensuite de variables d’entrée pour différents modèles de machine learning.

Les performances des modèles ont été évaluer notamment à l’aide de différentes méthodes de validation croisée. Le but est de comprendre en quoi le choix du modèle et de la stratégie de validation peut influencer la capacité à distinguer les participants ASD des contrôles typiques.

### Présentation des résultats:

En validation group k-fold, les résultats moyens par modèle étaient :
  - Linear SVM ≈ 63.5 %
  - K-nearest neighbors ≈ 55.2 %
  - Arbres de décision ≈ 54.3 %
  - Random forest ≈ 52.6 %

Le SVM linéaire était le plus précis, mais même lui restait loin d’une classification très robuste.

### Interpretation des résultats:

**Les performances de classification observées sont supérieures au hasard (≈50 %) mais loin d'être robuste (pas de très hautes précisions).**

Les résultats montrent que la capacité à prédire ASD vs TD d’après les données IRMf au repos reste limitée, probablement parce que les données proviennent de plusieurs sites avec des profils différents (scanners, âges, méthodes) et que la variabilité inter-sites rend la classification plus difficile.

## 2. Pourquoi ce projet ?

Eva Villeneuve (**[GitHub](https://github.com/psy3019-6973-2026/Villeneuve_Projet_mi-session/tree/main)**) et moi-même avons choisi ce projet car il combine neurosciences cognitives et apprentissage automatique, autour d’un sujet qui nous intéresse : le trouble du spectre de l’autisme.

Le dataset ABIDE est multi-site et est prétraité ce qui en fait un bon point de départ pour étudier des questions comme la validation croisée, la généralisation des modèles et l’impact des effets de site.

Enfin, le projet initial était déjà bien structuré, mais il laissait suffisamment de place pour approfondir certains aspects méthodologiques et proposer des analyses complémentaires.

## 3. Reproduction :

### 1. Cloner le dépôt


```bash
git clone https://github.com/psy3019-6973-2026/Francois_Presentation_Projet_ABIDE-fMRI.git
cd Francois_Presentation_Projet_ABIDE-fMRI
```

### 2. Créer et activer l'environnement
```bash
conda env create -f environment.yml
conda activate env_abide
```

### 3. Préparer les données
**Avertissement** : Cette étape qui télécharge les données ABIDE peut etre longue. 
Selon votre connexion internet, le téléchargement peut prendre **plusieurs heures** (environ 8h). 
 Prévoyez de lancer cette commande en arrière-plan ou avant une nuit.
 
```bash
make prepare
```

## Reproduction complète
Pour reproduire toutes les analyses :
```bash
make run
```

Ou tâche par tâche :
```bash
make tache1   # Validation croisée intra-site vs LOSO
make tache2   # Analyse du sous-échantillon par âge
make tache3   # Visualisation des effets de site fMRI
```
**Avertissement** : La tache 3 peut etre longue a excuter. Une des cellule prend environ 30 minutes.

## Structure du projet

```
├── code/                          # Scripts originaux du projet de base
│   ├── prepare_data.py            # Téléchargement et extraction des features
│   └── *.ipynb                    # Notebooks originaux
├── notebook/                      # Contributions — tâches du projet
│   ├── Tache1_validation_croisee_v2.ipynb
│   ├── Tache2_sous_echantillon.ipynb
│   └── Tache3_effets_de_site_fMRI.ipynb
├── data/                          # Données ABIDE (générées par prepare_data.py)
├── output/                        # Features extraites (.npz)
├── Makefile                       # Commandes de reproduction
├── environment.yml                # Environnement conda
└── requirements-modern.txt        # Dépendances pip
```


## 3. Présentation des tâches :

J'ai choisi 3 tâches selon un fil conducteur selon leur limite : et si la classification n'est pas robuste a cause d'un effet de site ? : 
- Tâche 1 → y a t'il un effet de site  ?
- Tâche 2 → que se passe-t-il dans un sous-échantillon ?
- Tâche 3 → comment interpréter proprement ce qu’on observe ?

## Tâche 1 : Comparaison des stratégies de validation croisée selon les sites

### Problème identifié

Dans les bases de données multi-sites comme ABIDE, chaque site utilise
un scanner différent, des paramètres d'acquisition propres et parfois
une population différente. Si les données d'entraînement et de test
proviennent des mêmes sites, le modèle peut apprendre à reconnaître
la signature du scanner plutôt qu'une vraie signature biologique de
l'autisme — ce qui conduit à une surestimation des performances.

### Objectif

Comparer deux stratégies de validation croisée pour mesurer dans quelle
mesure les performances reflètent une vraie capacité de classification
vs. un artefact de site :

- **5-Fold stratifié par site (intra-site)** : chaque site est représenté
  proportionnellement dans le train et le test. Le modèle voit les mêmes
  sites à l'entraînement et au test.
- **Leave-One-Site-Out (LOSO)** : un site entier est exclu du train et
  utilisé uniquement pour le test. Répété pour chaque site. Simule le
  scénario réaliste d'application à un nouveau site inconnu.

### Étapes réalisées

- Chargement des features ABIDE (matrice de connectivité BASC064)
- Définition d'un pipeline fixe : `StandardScaler → LogisticRegression`
  (même modèle, mêmes hyperparamètres pour les deux stratégies)
- Implémentation d'un 5-fold stratifié par site avec gestion des sites
  à faible effectif
- Implémentation du LOSO avec `LeaveOneGroupOut`
- Comparaison des performances (accuracy, balanced accuracy, ROC-AUC)
- Visualisation : boxplot comparatif + barplot LOSO par site

### Résultats

| Stratégie             | Balanced Accuracy | ROC-AUC |
|-----------------------|-------------------|---------|
| Intra-site (5-fold)   | 0.651             | 0.703   |
| LOSO (moy. pondérée)  | 0.661             | 0.718   |

Contrairement à l'hypothèse initiale, les performances LOSO sont légèrement supérieures à l'intra-site, ce qui suggère que le modèle ne dépend pas fortement des effets de site au niveau global. La principale observation est la forte variabilité inter-site : LEUVEN_1 (0.750), LEUVEN_2 (0.740) et PITT (0.737) généralisent bien, tandis que OHSU (0.442), CALTECH (0.450) et MAX_MUN (0.499) sont au niveau du hasard

**Figure produite** : `comparaison_cv.png`
![Comparaison des stratégies de validation croisée](output/comparaison_cv.png)

Le panneau gauche compare la distribution des scores entre les deux 
stratégies. Les performances LOSO sont comparables à l'intra-site en 
moyenne, mais plus variables (outliers visibles). Le panneau droit 
révèle l'hétérogénéité inter-site : 17 sites sur 20 dépassent le 
niveau du hasard en LOSO, mais MAX_MUN, CALTECH et OHSU restent 
en dessous de 0.5, indiquant une généralisation nulle pour ces sites.

### Discussion
La légère supériorité du LOSO sur l'intra-site (0.661 vs 0.651) doit être interprétée avec prudence : la validation intra-site a été contrainte à 2 folds effectifs par site en raison du faible effectif de certains sites, ce qui peut avoir sous-estimé les performances intra-site.
La principale conclusion est la forte hétérogénéité inter-site : 3 sites sur 20 (OHSU, CALTECH, MAX_MUN) obtiennent une balanced accuracy ≤ 0.5 en LOSO, indiquant une généralisation nulle. Ces sites présentent probablement des caractéristiques d'acquisition ou de population non représentées dans les autres sites. À l'inverse, les sites bien généralisés (LEUVEN_1, PITT, SDSU) semblent partager suffisamment de caractéristiques avec le reste du dataset.
Pour tout déploiement clinique multi-sites, ces résultats suggèrent qu'une validation explicite sur chaque nouveau site est nécessaire avant utilisation.




## Tâche 2 : Analyse d’un sous-échantillon 

### Problème identifié
ABIDE regroupe des enfants, adolescents et adultes (de ~7 à ~58 ans). Cette hétérogénéité d'âge peut masquer ou amplifier les différences de connectivité fonctionnelle entre ASD et TD, indépendamment du diagnostic. La tâche 1 n'avait pas contrôlé cette variable.

### Objectif

1. Décrire le dataset complet : distribution d'âge, scores ADOS, composition ASD/TD par site
2. Sélectionner un sous-échantillon : choisir un seuil d'âge justifié et reproduire le pipeline de classification de la tâche 1 sur ce sous-groupe
3. Comparer les performances entre le dataset complet et le sous-échantillon

### Justification du seuil (18 ans)

![Distribution de l'âge](output/age_distribution.png)

Le seuil de 18 ans a été choisi car il est a la limite de l'enfant/adulte.
Ce filtre conserve 70% du dataset (613/871 participants) 
tout en réduisant l'hétérogénéité développementale.

### Description du sous-échantillon

- 613 participants (286 ASD, 327 TD) sur 18 site
- Groupes bien appariés en âge (médiane ~13 ans pour les deux groupes, écart-type ~2.8 ans)
- Score ADOS_TOTAL disponible pour 201/286 participants ASD (médiane : 11.0, étendue : 2–22)
- 2 sites exclus faute d'effectif suffisant : CALTECH (1 sujet restant) et LEUVEN_1 (1 sujet dans la classe minoritaire)

L'histogramme montre une distribution asymétrique avec un pic principal 
entre 10 et 15 ans et une longue queue vers les adultes (jusqu'à ~58 ans). 
La majorité des participants sont donc des enfants et adolescents 
(médiane : 14.65 ans ASD, 14.80 ans TD). 

![Comparaison complet vs sous-échantillon](output/description_sous_echantillon.png)

### Résultats



| Stratégie | Balanced Accuracy | ROC-AUC |
|---|---|---|
| Intra-site — complet | 0.651 | 0.703 |
| LOSO — complet | 0.661 | 0.718 |
| Intra-site — ≤18 ans | 0.644 | 0.701 |
| LOSO — ≤18 ans | 0.633 | 0.699 |


![Comparaison complet vs sous-échantillon](output/comparaison_complet_vs_sub.png)

Les quatre stratégies restent bien au-dessus du hasard (0.5), et les performances 
du sous-échantillon sont comparables au dataset complet.
Restreindre l'analyse aux participants de moins de 18 ans produit une légère baisse 
des performances (−0.007 en intra-site, −0.028 en LOSO) ce qui suggère que l'hétérogénéité d'âge n'est pas la principale source de variabilité dans ABIDE.

La variabilité inter-site reste présente dans le sous-échantillon :
- **LEUVEN_1** : balanced accuracy = 1.000, mais seulement 2 sujets en test — résultat non fiable
- **CALTECH** : 1 seul sujet en test, accuracy = 0.000, ROC-AUC = NaN — non interprétable
- **OHSU** s'améliore (0.558 vs 0.442 en LOSO complet), suggérant que ses participants adultes 
  étaient particulièrement difficiles à classer
- **MAX_MUN** (0.500) et **STANFORD** (0.519) restent proches du hasard


### Tâche 3 : Visualisations et interprétation des résultats 

 **Note pour la tâche 3** : Les fichiers fMRI bruts (`.nii.gz`) sont 
téléchargés automatiquement par `make prepare`. Le téléchargement 
complet peut prendre plusieurs heures (~87 Go). Si les fichiers sont 
déjà disponibles, placer les dans `data/ABIDE_pcp/cpac/nofilt_noglobal/`.

### Problème identifié

Les tâches 1 et 2 ont montré que les performances varient fortement
selon les sites, sans que l'âge en soit la cause principale. La tâche 3
remonte en amont pour examiner si ces effets de site sont **visibles
directement dans les données fMRI brutes**, avant toute extraction de
features.

### Objectif

Produire deux types de visualisations par site :

1. **Volume moyen par site** : moyenne voxel par voxel de toutes les
   images fMRI d'un site. Les différences d'intensité, de champ de vue
   ou de contraste entre sites sont directement visibles.
2. **Carte d'écart-type temporel (tSD) par site** : écart-type voxel
   par voxel sur la série temporelle de chaque sujet, moyenné par site.
   Les zones à forte variabilité temporelle révèlent des artefacts
   spécifiques au site.

### Étapes réalisées

- Parsing des fichiers `func_preproc.nii.gz` et mapping vers les noms
  de sites du phénotype
- Calcul du volume moyen (`nilearn.image.mean_img`) et de la carte tSD
  pour chaque site, sujet par sujet pour éviter la saturation mémoire
- Gestion des images de dimensions différentes par rééchantillonnage
- Visualisation de tous les sites (coupes axiales)
- Comparaison ciblée des sites performants (LEUVEN_1, PITT) vs
  problématiques (OHSU, MAX_MUN) en LOSO

**Avertissement** : Le calcul des cartes (section 3) peut prendre 30 minutes 

### Résultats

![Volume moyen par site](output/volume_moyen_par_site.png)

Les volumes moyens révèlent des différences inter-sites visibles à l'œil nu :
variations d'intensité globale (CMU et MAX_MUN plus sombres, PITT et SDSU plus
clairs), différences de champ de vue (CALTECH, LEUVEN_1), et texture variable
(OHSU plus bruité). Ces différences de protocole d'acquisition sont cohérentes
avec la variabilité de performance observée en LOSO

![Carte tSD par site](output/tSD_par_site.png)

Les cartes tSD révèlent des différences importantes entre sites : les
échelles absolues varient d'un facteur ~4 (CALTECH ~280 vs LEUVEN_1
~1200), reflétant des différences d'unités d'intensité entre scanners.
La plupart des sites montrent des zones chaudes au centre du cerveau
(ventricules, noyaux gris), mais KKI et NYU présentent des points chauds
particulièrement intenses, suggestifs d'artefacts résiduels.

![Comparaison sites performants vs problématiques](output/comparaison_sites_focus.png)

Ligne 1 (volume d'activité moyen par site en gris) :
- LEUVEN_1 : cerveau petit, FOV réduit
- PITT, NYU : apparence normale
- MAX_MUN : texture plus grossière (pixels plus gros = résolution spatiale plus faible)
- OHSU : cerveau tronqué à droite

Ligne 2 (cartes tSD en rouge/jaune montrant la déviation standard temporelle) 
- LEUVEN_1 : sombre, variabilité concentrée au centre
- PITT, NYU, MAX_MUN : points chauds intenses au centre
- OHSU : variabilité diffuse sur tout le cerveau = signe d'artefacts

Comparaison directe entre sites bien généralisés (LEUVEN_1, PITT) et problématiques
(MAX_MUN, OHSU) en LOSO. Les volumes moyens révèlent des différences structurelles :
MAX_MUN présente une résolution spatiale plus grossière, et OHSU un champ de vue
tronqué. Les cartes tSD montrent qu'OHSU a une variabilité temporelle diffuse sur
l'ensemble du cerveau, contrairement aux sites performants où elle est concentrée
au centre. Ces signatures visuelles sont cohérentes avec l'échec de généralisation
observé en tâche 1

![Volume interactif NYU](output/volume_interactif_NYU.png)

Vue orthogonale (sagittale, coronale, axiale) du volume moyen fMRI 
pour NYU.

Note 1 : La visualisation interactive est fortement inspirée du notebook de cours `psy3019_visualisation.ipynb` (Marie-Eve Picard).

Note 2 : Ce projet a été réalisé a l'aide l'IA générative (Claude) 

Merci :)
