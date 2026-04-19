FROM apache/airflow:2.9.0-python3.10
RUN pip install dbt-postgres psycopg2-binary python-dotenv requests