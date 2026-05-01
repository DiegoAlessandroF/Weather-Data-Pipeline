FROM apache/airflow:2.9.0-python3.10

USER root
RUN apt-get update && apt-get install -y git

USER airflow
ENV PIP_CONSTRAINT=""
RUN pip install psycopg2-binary==2.9.11 python-dotenv==1.2.2 requests==2.32.5 && \
    pip install dbt-postgres==1.8.0 --no-deps && \
    pip install dbt-core==1.8.2 agate