FROM python:3.9-slim

ENV TZ=Europe/Paris

# Installer les paquets système nécessaires
RUN apt-get update && apt-get install -y wget tzdata && rm -rf /var/lib/apt/lists/*

# Installer les bibliothèques Python
RUN pip install --no-cache-dir \
    numpy==1.23.5 \
    pandas==2.1.4 \
    sqlalchemy==2.0.30 \
    psycopg2-binary==2.9.9 \
    jupyter \
    fastparquet \
    pyarrow \
    ipykernel

# Définir le répertoire de travail
WORKDIR /ny_taxi/work

# Copier les scripts
COPY notebook/ingest_data.py ingest_data.py
COPY entrypoint.sh /ny_taxi/work/entrypoint.sh

# Donner les droits d’exécution
RUN chmod +x entrypoint.sh

# Exposer le port Jupyter
EXPOSE 8888

# Lancer le script
ENTRYPOINT ["/ny_taxi/work/entrypoint.sh"]
