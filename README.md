# Weather Pipeline

Pipeline de dados meteorológicos que coleta dados de 5 cidades brasileiras via OpenWeather API,
armazena no PostgreSQL, transforma com dbt e orquestra com Airflow.
Projeto de portfólio para qualificação em vagas de engenharia de dados.

## Stack

| Tecnologia | Função |
|---|---|
| Python 3.10 | Scripts de coleta e ingestão |
| PostgreSQL 14 | Banco de dados (raw → staging → marts) |
| dbt-postgres 1.8.0 | Transformações SQL e testes de qualidade |
| Apache Airflow 2.9 | Orquestração da pipeline |
| Docker + Compose | Containerização de todos os serviços |
| AWS EC2 t3.medium | Infraestrutura cloud (sa-east-1) |
| Metabase | Visualização dos dados |

## Arquitetura

    OpenWeather API
    ↓
    collect.py → raw.weather_metrics (PostgreSQL)
    ↓
    dbt → staging.stg_weather_metrics → marts.fct_weather_metrics
    ↓
    Airflow DAG (coleta_dados → dbt_run → dbt_test)

## Estrutura do projeto

    weather-pipeline/
    ├── airflow/
    │   └── dags/
    │       └── weather_pipeline.py     # DAG de orquestração
    ├── dbt/
    │   ├── macros/
    │   │   └── generate_schema_name.sql
    │   ├── models/
    │   │   ├── marts/
    │   │   │   ├── fct_weather_metrics.sql
    │   │   │   └── schema.yml
    │   │   └── staging/
    │   │       ├── schema.yml
    │   │       ├── sources.yml
    │   │       └── stg_weather_metrics.sql
    │   ├── profiles/
    │   │   └── profiles.yml.example    # template — copiar para profiles.yml
    │   ├── seeds/
    │   │   └── dim_cities.csv
    │   ├── dbt_project.yml
    │   ├── package-lock.yml
    │   └── packages.yml
    ├── ingestion/
    │   ├── collect.py                  # coleta dados das 5 cidades via API
    │   └── load.py                     # insere os dados no PostgreSQL
    ├── sql/
    │   └── init/
    │       ├── 000_setup.sql           # criação de usuários e bancos
    │       ├── 001_create_schemas.sql  # criação dos schemas
    │       ├── 002_create_user.sql     # permissões do pipeline_user
    │       └── 003_create_raw_tables.sql
    ├── docs/
    │   └── images/                     # prints do projeto
    ├── Dockerfile                      # imagem customizada Airflow + dbt
    ├── docker-compose.yml              # postgres, airflow, metabase
    ├── requirements.txt
    └── .env.example

## Setup com Docker

### Pré-requisitos

- Docker:
  - **Windows/Mac:** Docker Desktop 4.0+ (já inclui o Compose)
  - **Linux:** Docker Engine 20.10+ + docker-compose-plugin (Compose v2.0+)
- Conta na [OpenWeather API](https://openweathermap.org/api) (plano gratuito)
- Conta Gmail com [senha de app](https://myaccount.google.com/apppasswords) configurada (para alertas de falha)

### Instalação

1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/weather-pipeline.git
cd weather-pipeline
```

2. Configure as variáveis de ambiente

```bash
cp .env.example .env
# editar .env com suas credenciais
```

3. Configure o profiles.yml do dbt

```bash
cp dbt/profiles/profiles.yml.example dbt/profiles/profiles.yml
# editar se necessário — as credenciais padrão já funcionam para o ambiente local
```

4. Inicialize o Airflow

```bash
docker compose up airflow-init
```

5. Suba todos os serviços

```bash
docker compose up -d
```

6. Instale as dependências do dbt

```bash
docker compose exec airflow-scheduler dbt deps \
  --project-dir /opt/airflow/dbt \
  --profiles-dir /opt/airflow/.dbt
```

7. Verifique os serviços

```bash
docker compose ps
```

### Interfaces

| Serviço | URL | Credenciais |
|---|---|---|
| Airflow | http://localhost:8080 | admin / weather_pass |
| Metabase | http://localhost:3000 | — |
| PostgreSQL | localhost:5432 | pipeline_user / pipeline_pass |

### Variáveis de ambiente

```env
OPENWEATHER_API_KEY=sua_api_key
DB_HOST=postgres
DB_PORT=5432
DB_NAME=weather_db
DB_USER=pipeline_user
DB_PASSWORD=pipeline_pass
ALERT_EMAIL=seu_email
SMTP_USER=seu_gmail
SMTP_PASSWORD=senha_de_app_16_chars
AIRFLOW_UID=1000
```

## Rodando manualmente

```bash
# Disparar a DAG completa via Airflow
# Acessar http://localhost:8080 → weather_pipeline → Trigger DAG

# Ou rodar o dbt direto no container
docker compose exec airflow-scheduler dbt run \
  --project-dir /opt/airflow/dbt \
  --profiles-dir /opt/airflow/.dbt
```

## Cidades monitoradas

| Cidade | Região |
|---|---|
| Rio de Janeiro | Sudeste |
| São Paulo | Sudeste |
| Belo Horizonte | Sudeste |
| Salvador | Nordeste |
| Curitiba | Sul |

## Testes de qualidade

25 testes com dbt nas camadas staging e marts:

- `not_null` — campos obrigatórios nunca vazios
- `unique` — sem registros duplicados
- `accepted_range` — temperatura entre -20°C e 60°C, umidade entre 0% e 100%
- `accepted_values` — categorias de temperatura válidas (frio, agradável, quente, muito quente)

## Alertas

Email automático enviado via Gmail (remetente configurado no SMTP_USER) para o destinatário
definido em ALERT_EMAIL em caso de falha em qualquer task do Airflow, com link direto para o log da task.

## Pipeline em funcionamento

### Airflow — tasks executadas com sucesso

![Airflow Tasks](<docs/images/Captura de tela airflow tasks.png>)

### Airflow — runs executadas com sucesso
![Airflow Runs](<docs/images/Captura de tela airflow runs.png>)


### Metabase — registros coletados

![Tabela de Registros](<docs/images/Captura de tela tabela.png>)

### Metabase — dashboard de temperatura

![Dashboard Temperatura Tema Escuro](<docs/images/Captura de tela dashboard temperatura preto.png>)