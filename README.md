# Francois_Presentation_Projet_ABIDE-fMRI
Présentation des tâches pour le projet ABIDE-fMRI

## 1. Présentation du projet initial :

**Projet initial** :  
**[*Using fMRI Data to Predict Autism Diagnoses with Machine Learning*](https://github.com/brainhack-school2020/abide-fmri)**

**Présentation du projet** :  
Le projet initialement réalisé par Emily Chen, Andréanne Proulx et Mikkel Schöttner a pour objectif de comparer plusieurs modèles d’apprentissage automatique ainsi que différentes stratégies de validation croisée afin d’évaluer leur capacité à distinguer des individus présentant un trouble du spectre autistique (Autism Spectrum Disorder, ASD) de contrôles typiques (Typically Developed, TD), à partir de données de connectivité cérébrale issues de l’analyse de l’IRM fonctionnelle au repos.

**Présentation des données** :  
Les données utilisées proviennent du dataset **[ABIDE – Autism Brain Imaging Data Exchange](https://fcon_1000.projects.nitrc.org/indi/abide/)**, une base de données ouverte regroupant des données d’IRM fonctionnelle au repos prétraitées, incluant plusieurs centaines de sujets ASD et TD provenant de plus de 20 sites de recherche internationaux.

## 2. Pourquoi ce projet ?

Eva Villeneuve (**[GitHub](https://github.com/psy3019-6973-2026/Villeneuve_Projet_mi-session/tree/main)**) et moi-même avons choisi ce projet car

## 3. Présentation des tâches :

### Tâche 1 : Comparaison des stratégies de validation croisée

**Description de la tâche** :  
Cette tâche vise à comparer plusieurs stratégies de validation croisée (*StratifiedKFold*, *GroupKFold* par site et *Leave-One-Site-Out*) afin de voir comment le choix de la validation influence la performance des modèles de classification ASD vs TD.  
Le modèle et ses paramètres restent inchangés, ce qui permet d’observer uniquement l’effet du choix de la validation croisée sur les performances.

**Lien avec le projet initial** :  
Le projet ABIDE-fMRI de départ teste déjà différentes approches de validation croisée. Cette tâche permet d’aller plus loin en comparant ces stratégies de manière plus structurée, afin de mieux comprendre leur impact sur les résultats.

**Pourquoi c’est pertinent** :  
Les données ABIDE proviennent de plusieurs sites d’acquisition. Si l’on ne tient pas compte de cette structure, les performances peuvent sembler meilleures qu’elles ne le sont réellement. En comparant des stratégies qui prennent en compte les sites, cette tâche permet d’évaluer plus correctement la robustesse et la capacité de généralisation des modèles.

### Tâche 2 : Analyse d’un sous-échantillon (site NYU)

**Description de la tâche** :  
Dans la continuité de la premiere tache, celle-ci consiste à refaire l’analyse en utilisant uniquement les données provenant d’un seul site d’acquisition, le site NYU. Le même pipeline de classification est appliqué afin d’entraîner et d’évaluer le modèle sur ce sous-ensemble de données. Les performances obtenues sont ensuite comparées à celles de l’analyse réalisée sur l’ensemble des sites.
Dans ABIDE II, NYU est séparé en deux échantillons (Sample 1 et Sample 2). Comme Sample 2 utilise une séquence IRMf différente, nous réalisons l’analyse single-site sur un seul échantillon (NYU Sample 1 https://fcon_1000.projects.nitrc.org/indi/abide/abide_II.html).

**Lien avec le projet initial** :  
Le projet ABIDE-fMRI utilise des données collectées dans plusieurs sites différents. Cette tâche permet de s’appuyer sur cette structure multi-site pour examiner plus concrètement l’effet des différences entre sites sur les résultats.

**Pourquoi c’est pertinent** :  
En se concentrant sur un seul site, on réduit les différences liées aux scanners et aux protocoles d’acquisition. Si les performances sont meilleures dans ce contexte, cela suggère que les effets de site peuvent compliquer l’entraînement de modèles capables de bien généraliser à l’ensemble des données ABIDE.

### Tâche 3 : Visualisations et interprétation des résultats 

**Description de la tâche** :  
Cette tâche consiste à produire des visualisations à partir des résultats obtenus lors des analyses précédentes. Cela inclut notamment des heatmaps de connectivité moyenne pour les groupes ASD et TD, des courbes d’apprentissage, ainsi que des graphiques montrant la distribution des scores selon les folds de validation croisée.

**Lien avec le projet initial** :  
Le projet ABIDE-fMRI propose déjà plusieurs analyses quantitatives. Cette tâche permet de compléter ces résultats en les rendant plus lisibles et interprétables grâce à des visualisations, tout en s’appuyant sur les sorties des modèles existants.

**Pourquoi c’est pertinent** :  
Les visualisations permettent de mieux comprendre comment les modèles se comportent, au-delà d’un simple score de performance. Elles aident à évaluer la stabilité des résultats selon les folds de validation croisée, à repérer d’éventuelles différences globales entre les groupes ASD et TD, et à interpréter plus facilement la robustesse des modèles.
