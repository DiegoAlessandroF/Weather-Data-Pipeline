# Weather Pipeline

Pipeline de dados meteorológicos que coleta dados de 5 cidades brasileiras via OpenWeather API,
armazena no PostgreSQL, transforma com dbt e orquestra com Airflow.

Projeto de portfólio para qualificação em vagas de engenharia de dados.

## Stack
- **Coleta:** Python + OpenWeather API
- **Armazenamento:** PostgreSQL (raw → staging → marts)
- **Transformação:** dbt (25 testes de qualidade)
- **Orquestração:** Airflow (alerta de email em caso de falha)
- **Infraestrutura:** AWS EC2 t3.medium (sa-east-1)

## Arquitetura
```
OpenWeather API
      ↓
collect.py → raw.weather_metrics (PostgreSQL)
      ↓
dbt → stg_weather_metrics → fct_weather_metrics
      ↓
Airflow DAG (coleta → dbt run → dbt test)
```

## Setup
### Pré-requisitos
- Python 3.10
- PostgreSQL 14
- Conta OpenWeather API (gratuita)

### Instalação

1. Clone o repositório
```bash
git clone https://github.com/seu-usuario/weather-pipeline.git
cd weather-pipeline
```

2. Crie o ambiente virtual e instale as dependências
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

3. Configure as variáveis de ambiente
```bash
cp .env.example .env
# editar .env com sua API key e credenciais do banco
```

4. Configure o PostgreSQL
```bash
sudo -u postgres psql -f sql/001_create_schemas.sql
sudo -u postgres psql -f sql/003_create_raw_tables.sql
```

5. Configure o dbt
```bash
# criar ~/.dbt/profiles.yml com as credenciais do banco
cd dbt && dbt deps && dbt run && dbt test
```

### Airflow

```bash
export AIRFLOW_HOME=~/airflow
airflow db migrate
airflow users create --username admin --password admin \
  --firstname Admin --lastname User --role Admin --email admin@example.com
sudo systemctl start airflow-webserver airflow-scheduler
```

Acessar em: `http://localhost:8080`

## Rodando manualmente

```bash
# Coleta e ingestão
cd ~/weather-pipeline && python -m ingestion.collect

# Transformações
cd dbt && dbt run && dbt test
```

## Cidades monitoradas

| Cidade | Região |
|---|---|
| Rio de Janeiro | Sudeste |
| São Paulo | Sudeste |
| Belo Horizonte | Sudeste |
| Salvador | Nordeste |
| Curitiba | Sul |

## Testes

25 testes de qualidade com dbt — `not_null`, `unique`, `accepted_range`
e `accepted_values` nas camadas staging e marts.

## Alertas

Pipeline configurada para enviar email em caso de falha em qualquer task do Airflow.