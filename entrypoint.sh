#!/bin/bash

set -e

echo "Démarrage du script d'ingestion..."

# Vérification que DATA_URL est bien défini
if [ -z "$DATA_URL" ]; then
  echo "Erreur : la variable d'environnement DATA_URL est manquante."
  exit 1
fi

# Exécution du script d'ingestion Python
python ingest_data.py

echo "Ingestion terminée."

# Lancer Jupyter à la fin pour accès interactif
echo "Démarrage de Jupyter Notebook..."
jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root --no-browser --NotebookApp.token=${JUPYTER_TOKEN}
