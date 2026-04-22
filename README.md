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
```bash
make prepare
```
Cela télécharge les données ABIDE et calcule les features de connectivité.

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






### Tâche 2 : Analyse d’un sous-échantillon 

**Objectif de la tâche** :  
**L’objectif de cette tâche est d’évaluer l’impact des effets de site sur les performances du modèle en comparant une analyse multi-site à une analyse réalisée sur un seul site d’acquisition.**

**Le site utilisé pour l’analyse mono-site sera choisi après l’analyse LOSO de la tâche 1. Il sera choisie selon :**
- **sa performance LOSO** : légèrement inférieure à la moyenne des autres sites, ce qui en fait un cas intéressant pour examiner l’impact potentiel des effets de site sur la généralisation du modèle
- **sa taille d’échantillon** : suffisamment grande pour permettre une évaluation stable, avec au moins 50 sujets au total et au moins 20 sujets par classe (ASD et TD), afin d’éviter qu’un site trop petit rende les résultats trop bruités

**Description de la tâche** :  
Dans la continuité de la tâche 1, cette analyse consiste à appliquer le même pipeline de classification sur un sous-ensemble mono-site, sélectionné à partir des résultats LOSO. Le modèle est entraîné et évalué uniquement sur les données provenant de ce site, en utilisant une validation croisée adaptée au contexte mono-site.
Les performances obtenues (moyennes et variabilité entre folds) sont ensuite comparées à celles de l’analyse multi-site, afin d’examiner l’impact de l’hétérogénéité inter-sites sur la performance et la stabilité du modèle.

**Lien avec le projet initial** :  
Le projet ABIDE-IRMf utilise des données collectées dans plusieurs sites différents. Cette tâche permet de s’appuyer sur cette structure multi-site pour examiner plus concrètement l’effet des différences entre sites sur les résultats.

**Pourquoi c’est pertinent** :  
En se concentrant sur un seul site, on réduit les différences liées aux scanners et aux protocoles d’acquisition. Si les performances sont meilleures dans ce contexte, cela suggère que les effets de site peuvent compliquer l’entraînement de modèles capables de bien généraliser à l’ensemble des données ABIDE.

### Tâche 3 : Visualisations et interprétation des résultats 

> **Note pour la tâche 3** : Les fichiers fMRI bruts (`.nii.gz`) sont 
> téléchargés automatiquement par `make prepare`. Le téléchargement 
> complet peut prendre plusieurs heures (~87 Go). Si les fichiers sont 
> déjà disponibles, placer les dans `data/ABIDE_pcp/cpac/nofilt_noglobal/`.
>
> 

**Objectif de la tâche** :  
L’objectif de cette tâche est de faciliter l’interprétation des résultats obtenus dans les tâches 1 et 2, en allant au-delà des scores globaux de performance.
Il s’agit d’évaluer visuellement :
- la stabilité des modèles selon la stratégie de validation croisée,
- l’hétérogénéité des performances entre sites,
- et l’impact de l’effet de site sur la capacité de généralisation

**Description de la tâche** :  
Cette tâche consiste à produire des visualisations directement issues des analyses précédentes.
Les figures principales seront :

1. Distribution des scores selon la stratégie de validation croisée (Violon plots)
- Axe x : stratégie de validation croisée (StratifiedKFold, GroupKFold, LOSO)
- Axe y : score de performance (ex. AUC ou accuracy)
- Chaque point représente un fold ou un site (dans le cas du LOSO)

Cette visualisation permet d’évaluer :
- la stabilité des performances,
- la variance entre folds,
- et une éventuelle surestimation des performances lorsque les effets de site ne sont pas contrôlés.

2. Performance par site (LOSO) Barplot avec ligne horizontale représentant la moyenne)
- Axe x : sites d’acquisition
- Axe y : score obtenu lorsque le site est laissé de côté (LOSO)
- Ligne horizontale : moyenne globale des performances inter-site

Cette figure permet de :
- visualiser l’hétérogénéité inter-sites,
- identifier les sites “difficiles” ou proches du hasard,


**Lien avec le projet initial** :  
Le projet ABIDE-IRMf propose principalement des évaluations quantitatives globales des modèles.
Cette tâche enrichit l’analyse en ajoutant une dimension visuelle permettant d’examiner plus finement la stabilité des performances et l’impact des effets de site, qui ne sont pas explicitement explorés dans le projet initial.

**Pourquoi c’est pertinent** :  
Les effets de site constituent un enjeu majeur dans les bases de données multi-sites comme ABIDE.

Les visualisations permettent :
- de détecter une surestimation potentielle des performances,
- d’illustrer la variabilité inter-site

