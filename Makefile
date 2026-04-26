PYTHON   = python
DATA     = data
OUTPUT   = output
NOTEBOOK = notebook

.PHONY: help init install prepare tache1 tache2 tache3 run clean
.SILENT:

help:
	@echo "Commandes disponibles :"
	@echo "  make install   -> installe les dépendances"
	@echo "  make init      -> crée les dossiers nécessaires"
	@echo "  make prepare   -> télécharge et prépare les données ABIDE"
	@echo "  make tache1    -> lance la tâche 1 (validation croisée)"
	@echo "  make tache2    -> lance la tâche 2 (sous-échantillon par âge)"
	@echo "  make tache3    -> lance la tâche 3 (effets de site fMRI)"
	@echo "  make run       -> lance toutes les tâches"
	@echo "  make clean     -> supprime les figures du dossier output (garde les features .npz)"
install:
	pip install -r requirements-modern.txt

init: install
	mkdir -p $(DATA)
	mkdir -p $(OUTPUT)

prepare: init
	$(PYTHON) code/prepare_data.py $(DATA) $(OUTPUT)

tache1:
	jupyter nbconvert --to notebook --execute --inplace \
		$(NOTEBOOK)/Tache1_validation_croisee_v2.ipynb

tache2:
	jupyter nbconvert --to notebook --execute --inplace \
		$(NOTEBOOK)/Tache2_sous_echantillon.ipynb

tache3:
	jupyter nbconvert --to notebook --execute --inplace \
		$(NOTEBOOK)/Tache3_effets_de_site_fMRI.ipynb

run: prepare tache1 tache2 tache3

clean:
	find $(OUTPUT) -type f ! -name "*.npz" -delete
