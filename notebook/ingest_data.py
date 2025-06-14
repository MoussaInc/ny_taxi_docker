import os
import pandas as pd
from time import time
import pyarrow.parquet as pq
from sqlalchemy import create_engine


def main():
    # Lire les variables d’environnement
    user = os.getenv("POSTGRES_USER", "root")
    password = os.getenv("POSTGRES_PASSWORD", "root")
    host = os.getenv("POSTGRES_HOST", "localhost")
    port = os.getenv("POSTGRES_PORT", "5432")
    db = os.getenv("POSTGRES_DB", "ny_taxi")
    table_name = os.getenv("TABLE_NAME", "yellow_taxi_data")
    url = os.getenv("DATA_URL")

    data_file = "output.parquet"

    # Télécharger les données
    os.system(f"wget {url} -O {data_file}")

    parquet_file = pq.ParquetFile(data_file)

    # Créer la connexion
    engine = create_engine(f"postgresql://{user}:{password}@{host}:{port}/{db}")

    # Lire le premier batch pour créer le schéma
    first_batch = next(parquet_file.iter_batches(batch_size=100_000))
    df = first_batch.to_pandas()
    df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'])
    df['tpep_dropoff_datetime'] = pd.to_datetime(df['tpep_dropoff_datetime'])

    df.head(0).to_sql(name=table_name, con=engine, if_exists='replace')
    df.to_sql(name=table_name, con=engine, if_exists='append')

    for batch in parquet_file.iter_batches(batch_size=100_000):
        t_start = time()
        df = batch.to_pandas()
        df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'])
        df['tpep_dropoff_datetime'] = pd.to_datetime(df['tpep_dropoff_datetime'])
        df.to_sql(name=table_name, con=engine, if_exists='append')
        t_end = time()
        print(f"Inserted another chunk in {t_end - t_start:.3f} seconds")


if __name__ == "__main__":
    main()
