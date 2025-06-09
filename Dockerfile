FROM python:3.9-slim

# Installation des librairies
RUN pip install --no-cache-dir \
    numpy==1.23.5 \
    pandas==1.5.3 \
    sqlalchemy \
    psycopg2-binary \
    jupyter

WORKDIR /app

EXPOSE 8888

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--no-browser"]
