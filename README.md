# Weather Pipeline

Pipeline de dados meteorológicos construída com Python, PostgreSQL, dbt e Airflow.

## Stack
- **Coleta:** Python + OpenWeather API
- **Armazenamento:** PostgreSQL (raw → staging → marts)
- **Transformação:** dbt
- **Orquestração:** Apache Airflow
- **Infraestrutura:** AWS EC2 (sa-east-1)

## Arquitetura
OpenWeather API → collect.py → raw.weather_metrics → dbt → marts.fct_weather_metrics

## Setup
1. Clone o repositório
2. Crie o `.env` baseado no `.env.example`
3. Instale as dependências: `pip install -r requirements.txt`
4. Configure o PostgreSQL e rode os scripts em `sql/`
5. Configure o dbt: `~/.dbt/profiles.yml`
6. Rode: `python -m ingestion.collect`
