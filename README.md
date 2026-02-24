# Francois_Presentation_Projet_ABIDE-fMRI
Présentation des taches pour le projet ABIDE-fMRI

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

### Tâche 1 — Comparaison des stratégies de validation croisée

**Description de la tâche** :  
Cette tâche vise à comparer plusieurs stratégies de validation croisée (*StratifiedKFold*, *GroupKFold* par site et *Leave-One-Site-Out*) afin de voir comment le choix de la validation influence la performance des modèles de classification ASD vs TD.  
Le modèle et ses paramètres restent inchangés, ce qui permet d’observer uniquement l’effet du choix de la validation croisée sur les performances.

**Lien avec le projet initial** :  
Le projet ABIDE-fMRI de départ teste déjà différentes approches de validation croisée. Cette tâche permet d’aller plus loin en comparant ces stratégies de manière plus structurée, afin de mieux comprendre leur impact sur les résultats.

**Pourquoi c’est pertinent** :  
Les données ABIDE proviennent de plusieurs sites d’acquisition. Si l’on ne tient pas compte de cette structure, les performances peuvent sembler meilleures qu’elles ne le sont réellement. En comparant des stratégies qui prennent en compte les sites, cette tâche permet d’évaluer plus correctement la robustesse et la capacité de généralisation des modèles.
