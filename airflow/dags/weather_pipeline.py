from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    'owner': 'diego',
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    dag_id='weather_pipeline',
    default_args=default_args,
    description='Pipeline meteorológico – coleta, carrega e transforma',
    schedule_interval='0 6 * * *',   #todo dia às 6h UTC
    start_date=datetime(2026, 1, 1),
    catchup=False,
    tags=['weather', 'pipeline'],
) as dag:

    coleta = BashOperator(
        task_id='coleta_dados',
        bash_command='cd /home/ubuntu/weather-pipeline && /home/ubuntu/weather-pipeline/.venv/bin/python -m ingestion.collect',
    )

    dbt_run = BashOperator(
        task_id='dbt_run',
        bash_command='cd /home/ubuntu/weather-pipeline/dbt && /home/ubuntu/weather-pipeline/.venv/bin/dbt run',
    )

    dbt_test = BashOperator(
        task_id='dbt_test',
        bash_command='cd /home/ubuntu/weather-pipeline/dbt && /home/ubuntu/weather-pipeline/.venv/bin/dbt run',
    )

    coleta >> dbt_run >> dbt_test
