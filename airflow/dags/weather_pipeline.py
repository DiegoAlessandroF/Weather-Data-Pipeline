import os
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.utils.email import send_email

def alerta_falha(context):
    dag_id = context['dag'].dag_id
    task_id = context['task'].task_id
    execution_date = context['execution_date']
    log_url = context['task_instance'].log_url

    subject = f'❌ Falha no pipeline {dag_id} – {task_id}'
    body = f"""
    <h3>Task falhou</h3>
    <b>DAG:</b> {dag_id}<br>
    <b>Task:</b> {task_id}<br>
    <b>Data:</b> {execution_date}<br>
    <b>Log:</b> <a href="{log_url}">Ver log</a>
    """
    send_email(to=os.getenv('ALERT_EMAIL'), subject=subject, html_content=body)

default_args = {
    'owner': 'diego',
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
    'on_failure_callback': alerta_falha,
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
        bash_command='cd /home/ubuntu/weather-pipeline/dbt && /home/ubuntu/weather-pipeline/.venv/bin/dbt test',
    )

    coleta >> dbt_run >> dbt_test
