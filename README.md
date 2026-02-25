# Francois_Presentation_Projet_ABIDE-fMRI
Présentation des tâches pour le projet ABIDE-fMRI

## 1. Présentation du projet initial :

**Projet initial** :  
**[*Using fMRI Data to Predict Autism Diagnoses with Machine Learning*](https://github.com/brainhack-school2020/abide-fmri)**

### Présentation du projet:  

Le projet initialement réalisé par Emily Chen, Andréanne Proulx et Mikkel Schöttner vise à explorer le potentiel de l’IRMf pour classer des participants présentant un trouble du spectre de l’autisme et des contrôles typiques. Pour cela, ils utilisent des méthodes de machine learning supervisé appliquées à des données d’IRMf au repos et à des mesures de connectivité cérébrale.

## Présentation des données:  
Les données utilisées proviennent du dataset **[ABIDE – Autism Brain Imaging Data Exchange](https://fcon_1000.projects.nitrc.org/indi/abide/)**, une base de données ouverte regroupant des données d’IRMf au repos prétraitées. Le ABIDE contient 1112 jeux de données au total, composés de :
- 539 participants avec un diagnostic de TSA
- 573 participants contrôles typiques (TD)

Le jeu de donnée provient de plus de 20 sites de recherche internationaux.

### Présentation de la méthode:

Le projet repose sur l’extraction de matrices de connectivité fonctionnelle à partir de données d’IRMf au repos. Ces matrices servent ensuite de variables d’entrée pour différents modèles de machine learning.

Les performances des modèles ont été évaluer notamment à l’aide de différentes méthodes de validation croisée. Le but est de comprendre en quoi le choix du modèle et de la stratégie de validation peut influencer la capacité à distinguer les participants ASD des contrôles typiques.

### Présentation des résultats:

Leave-one-out cross-validation a donné les meilleurs scores d’exactitude parmi les méthodes testées.

En validation group k-fold, les résultats moyens par modèle étaient :
  - Linear SVM ≈ 63.5 %
  - K-nearest neighbors ≈ 55.2 %
  - Arbres de décision ≈ 54.3 %
  - Random forest ≈ 52.6 %

Le SVM linéaire était le plus précis, mais même lui restait loin d’une classification très robuste.

### Interpretation des résultats:

Les résultats montrent que la capacité à prédire ASD vs TD d’après les données fMRI au repos reste limitée, probablement parce que les données proviennent de plusieurs sites avec des profils différents (scanners, âges, méthodes) et que la variabilité inter-sites rend la classification plus difficile.

Les performances observées sont supérieures au hasard (≈50 %) mais loin de « fortes » prédictions (pas de très hautes précisions).

Les différences de méthodes de validation ont une influence sur les scores, la validation croisée stricte (leave-one-out) offrant une meilleure estimation des performances qu’une simple k-fold.

## 2. Pourquoi ce projet ?

Eva Villeneuve (**[GitHub](https://github.com/psy3019-6973-2026/Villeneuve_Projet_mi-session/tree/main)**) et moi-même avons choisi ce projet car il combine neurosciences cognitives et apprentissage automatique, autour d’un sujet qui nous intéresse : le trouble du spectre de l’autisme.

Le dataset ABIDE est multi-site et est prétraité ce qui en fait un bon point de départ pour étudier des questions comme la validation croisée, la généralisation des modèles et l’impact des effets de site.

Enfin, le projet initial était déjà bien structuré, mais il laissait suffisamment de place pour approfondir certains aspects méthodologiques et proposer des analyses complémentaires.

## 3. Présentation des tâches :

### Tâche 1 : Comparaison des stratégies de validation croisée selon les sites d'aquisition

**Objectif de la tâche** :  

L’objectif de cette tâche est de comprendre comment le choix de la stratégie de validation croisée influence les performances d’un modèle de classification ASD vs TD, lorsque les données proviennent de plusieurs sites d’acquisition.

On cherche en effet à répondre à la problematique : Est-ce que les performances observées reflètent réellement une capacité à classer les participants présentant un trouble du spectre de l’autisme (TSA) de contrôles typiques (TD), ou bien sont-elles en partie dues aux différences entre les sites d’acquisition ?

En effet, chaque site utilise :
- un scanner différent (constructeur, champ magnétique, bobines),
- des paramètres d’acquisition propres (TR, résolution, durée),
- parfois une population différente (âge, sévérité clinique, critères de recrutement).
Résultats : deux sujets identiques biologiquement mais venant de deux sites différents peuvent avoir des signaux IRMf différents.

**Description de la tâche** :  

La validation croisée permet d’évaluer si les performances du modèle reposent sur des caractéristiques biologiques liées au diagnostic ou sur des caractéristiques spécifiques aux sites d’acquisition.

Protocole :
1) Préparer les données (mêmes données pour toutes les CV)
- Charger les features (ex. matrice de connectivité / vecteurs de features) : X
- Charger les labels diagnostiques : y (ASD=1, TD=0 par ex.)
- Récupérer l’identifiant du site pour chaque sujet : site (variable de groupe)

Sorties attendues :
- X : matrice sujets × features
- y : vecteur (n_sujets)
- site : vecteur (n_sujets) indiquant le site d’acquisition

2) Fixer le cadre expérimental (pour une comparaison équitable)

Pour que la comparaison soit valide, on fige :
- le même pipeline de preprocessing (ex. standardisation),
- le même modèle (ex. Logistic Regression / SVM),
- les mêmes hyperparamètres,
- les mêmes métriques,
- le même nombre de folds quand c’est applicable,
- un random_state fixe (si la méthode utilise un shuffle).

Seule chose qui change : la stratégie de validation croisée.

3) Définir les stratégies de validation croisée à comparer

Je vais tester trois CV :
1. StratifiedKFold

Les sujets sont répartis aléatoirement en conservant l’équilibre ASD/TD dans chaque fold, sans tenir compte des sites.

Le modèle voit :
- des données du même scanner
- des artefacts similaires
- des signatures de site répétées

Le modèle va apprendre des caractéristiques propres au site et les retrouver au test.
Si des effets de site sont présents, la StratifiedKFold peut conduire à une surestimation des performances car les données d’entraînement et de test partagent des signatures de site similaires.
Le but ici étant de mesurer la reconnaissance des données similaires à celle déjà vues.

2. GroupKFold (group = site)

Ici un groupe est égal à un site ce qui oblige le modèle a ne pas utiliser la signature du scanner, il doit apprendre des motifs communs entre sites.

Je devrais observer :
- Une baisse de performence 
- La variance entre folds qui augmente

Le but est de tester la capacité du modèle à généraliser à un site non vu pendant l'entraînement.
Je vais donc mesurer ici : généralisation d'un site à un autre

3. Leave-One-Site-Out (LOSO)

Ici, j'enlève entièrement un site, j'entraîne sur tous les autres et je teste sur le site exclu.

Et je répètes ca pour chaque site.

Ainsi je montre pour chaque site la performance différente.

Ces trois stratégies permettent d’évaluer différents niveaux de généralisation du modèle :
- StratifiedKFold : le modèle est évalué sur des données statistiquement similaires à celles vues à l’entraînement, ce qui permet de mesurer sa capacité à reconnaître des données proches.
- GroupKFold : le modèle est contraint de généraliser à des sites non vus pendant l’entraînement, fournissant une estimation plus réaliste de la généralisation inter-site.
- Leave-One-Site-Out (LOSO) : le modèle est évalué successivement sur chaque site exclu, ce qui permet d’examiner l’hétérogénéité des performances entre sites et d’identifier d’éventuels sites pour lesquels la généralisation est plus difficile.


**Lien avec le projet initial** :  
Le projet ABIDE-fMRI de départ explore déjà différentes approches de validation croisée. Cette tâche s’inscrit dans sa continuité en proposant une comparaison plus structurée de ces stratégies, dans le but de mieux comprendre leur impact sur les résultats.

**Pourquoi c’est pertinent** :  
ABIDE regroupe des données provenant de plusieurs sites d’acquisition, ce qui introduit des différences liées aux scanners, aux protocoles et aux populations étudiées. Lorsque des données issues d’un même site sont présentes à la fois dans les ensembles d’entraînement et de test, le modèle peut exploiter des caractéristiques spécifiques au site, ce qui peut conduire à une surestimation des performances.  
Les stratégies de validation croisée tenant compte des sites, comme *GroupKFold* ou *Leave-One-Site-Out*, permettent de contrôler cet effet en séparant explicitement les sites entre l’entraînement et le test, et offrent ainsi une évaluation plus réaliste de la capacité de généralisation des modèles.

### Tâche 2 : Analyse d’un sous-échantillon 

**Objectif de la tâche** :  
L’objectif de cette tâche est d’évaluer l’impact des effets de site sur les performances du modèle en comparant une analyse multi-site à une analyse réalisée sur un seul site d’acquisition.
Le site utilisé pour l’analyse mono-site sera choisi après l’analyse LOSO de la tâche 1. Il sera choisie selon :
- sa performance LOSO : légèrement inférieure à la moyenne des autres sites, ce qui en fait un cas intéressant pour examiner l’impact potentiel des effets de site sur la généralisation du modèle
- sa taille d’échantillon : suffisamment grande pour permettre une évaluation stable, avec au moins 50 sujets au total et au moins 20 sujets par classe (ASD et TD), afin d’éviter qu’un site trop petit rende les résultats trop bruités

**Description de la tâche** :  
Dans la continuité de la tâche 1, cette analyse consiste à appliquer le même pipeline de classification sur un sous-ensemble mono-site, sélectionné à partir des résultats LOSO. Le modèle est entraîné et évalué uniquement sur les données provenant de ce site, en utilisant une validation croisée adaptée au contexte mono-site.
Les performances obtenues (moyennes et variabilité entre folds) sont ensuite comparées à celles de l’analyse multi-site, afin d’examiner l’impact de l’hétérogénéité inter-sites sur la performance et la stabilité du modèle.

**Lien avec le projet initial** :  
Le projet ABIDE-fMRI utilise des données collectées dans plusieurs sites différents. Cette tâche permet de s’appuyer sur cette structure multi-site pour examiner plus concrètement l’effet des différences entre sites sur les résultats.

**Pourquoi c’est pertinent** :  
En se concentrant sur un seul site, on réduit les différences liées aux scanners et aux protocoles d’acquisition. Si les performances sont meilleures dans ce contexte, cela suggère que les effets de site peuvent compliquer l’entraînement de modèles capables de bien généraliser à l’ensemble des données ABIDE.

### Tâche 3 : Visualisations et interprétation des résultats 

**Objectif de la tâche** :  
L’objectif de cette tâche est de faciliter l’interprétation des résultats obtenus lors des analyses précédentes, en allant au-delà des scores de performance bruts et en évaluant la stabilité et la robustesse des modèles.

**Description de la tâche** :  
Cette tâche consiste à produire des visualisations à partir des résultats obtenus lors des analyses précédentes. Cela inclut notamment des heatmaps de connectivité moyenne pour les groupes ASD et TD, des courbes d’apprentissage, ainsi que des graphiques montrant la distribution des scores selon les folds de validation croisée.

**Lien avec le projet initial** :  
Le projet ABIDE-fMRI propose déjà plusieurs analyses quantitatives. Cette tâche permet de compléter ces résultats en les rendant plus lisibles et interprétables grâce à des visualisations, tout en s’appuyant sur les sorties des modèles existants.

**Pourquoi c’est pertinent** :  
Les visualisations permettent de mieux comprendre comment les modèles se comportent, au-delà d’un simple score de performance. Elles aident à évaluer la stabilité des résultats selon les folds de validation croisée, à repérer d’éventuelles différences globales entre les groupes ASD et TD, et à interpréter plus facilement la robustesse des modèles.
