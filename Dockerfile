FROM python:3.9-slim

ENV TZ=Europe/Paris

# Install time zone package
RUN apt-get update && apt-get install -y tzdata && rm -rf /var/lib/apt/lists/*

# Install Python libraries
RUN pip install --no-cache-dir \
    numpy==1.23.5 \
    pandas==1.5.3 \
    sqlalchemy \
    psycopg2-binary \
    jupyter \
    fastparquet \
    pyarrow \
    ipykernel

WORKDIR /app

EXPOSE 8888

CMD ["sh", "-c", "jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root --no-browser --NotebookApp.token=${JUPYTER_TOKEN}"]
