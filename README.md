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

Eva Villeneuve (**[GitHub](https://github.com/psy3019-6973-2026/Villeneuve_Projet_mi-session/tree/main)**) et moi-même avons choisi ce projet car il combine neurosciences cognitives et apprentissage automatique, autour d’un sujet qui nous intéresse particulièrement : le trouble du spectre de l’autisme.

Le dataset ABIDE est multi-site et largement utilisé, ce qui en fait un bon point de départ pour étudier des questions concrètes comme la validation croisée, la généralisation des modèles et l’impact des effets de site.

Enfin, le projet initial était déjà bien structuré, mais il laissait suffisamment de place pour approfondir certains aspects méthodologiques et proposer des analyses complémentaires.

## 3. Présentation des tâches :

### Tâche 1 : Comparaison des stratégies de validation croisée

**Objectif de la tâche** :  
L’objectif de cette tâche est d’évaluer dans quelle mesure le choix de la stratégie de validation croisée influence les performances des modèles de classification ASD vs TD dans le contexte d’un dataset multi-site comme ABIDE.

**Description de la tâche** :  
Pour cela, plusieurs stratégies de validation croisée sont comparées : *StratifiedKFold*, *GroupKFold* en utilisant le site d’acquisition comme variable de groupe, et *Leave-One-Site-Out*. Afin de garantir une comparaison équitable, le modèle, ses paramètres et les métriques d’évaluation sont conservés identiques ; seule la stratégie de validation croisée est modifiée. Cette approche permet d’isoler l’effet du schéma de validation sur les performances observées.

**Lien avec le projet initial** :  
Le projet ABIDE-fMRI de départ explore déjà différentes approches de validation croisée. Cette tâche s’inscrit dans sa continuité en proposant une comparaison plus structurée et systématique de ces stratégies, dans le but de mieux comprendre leur impact sur les résultats.

**Pourquoi c’est pertinent** :  
ABIDE regroupe des données provenant de plusieurs sites d’acquisition, ce qui introduit des différences liées aux scanners, aux protocoles et aux populations étudiées. Lorsque des données issues d’un même site sont présentes à la fois dans les ensembles d’entraînement et de test, le modèle peut exploiter des caractéristiques spécifiques au site, ce qui peut conduire à une surestimation des performances.  
Les stratégies de validation croisée tenant compte des sites, comme *GroupKFold* ou *Leave-One-Site-Out*, permettent de contrôler cet effet en séparant explicitement les sites entre l’entraînement et le test, et offrent ainsi une évaluation plus réaliste de la capacité de généralisation des modèles.

### Tâche 2 : Analyse d’un sous-échantillon (site NYU)

**Objectif de la tâche** :  
L’objectif de cette tâche est d’évaluer l’impact des effets de site sur les performances du modèle en comparant une analyse multi-site à une analyse réalisée sur un seul site d’acquisition.

**Description de la tâche** :  
Dans la continuité de la premiere tache, celle-ci consiste à refaire l’analyse en utilisant uniquement les données provenant d’un seul site d’acquisition, le site NYU. Le même pipeline de classification est appliqué afin d’entraîner et d’évaluer le modèle sur ce sous-ensemble de données. Les performances obtenues sont ensuite comparées à celles de l’analyse réalisée sur l’ensemble des sites.
Dans ABIDE II, NYU est séparé en deux échantillons (Sample 1 et Sample 2). Comme Sample 2 utilise une séquence IRMf différente, nous réalisons l’analyse single-site sur un seul échantillon (NYU Sample 1 https://fcon_1000.projects.nitrc.org/indi/abide/abide_II.html).

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
