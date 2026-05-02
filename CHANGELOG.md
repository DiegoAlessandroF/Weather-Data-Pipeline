# Changelog

Todas as mudanças relevantes do projeto estão documentadas neste arquivo.

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
versionamento seguindo [Semantic Versioning](https://semver.org/lang/pt-BR/).

---

## [1.0.0] — 2026-04-30

### Adicionado
- `data/raw/` adicionado ao `.gitignore` — backups locais em JSON não versionados

### Alterado
- Projeto declarado estável e reprodutível após teste de reprodutibilidade end-to-end em ambiente limpo

---

## [0.9.4] — 2026-04-30

### Adicionado
- Prints do Airflow (runs e tasks com sucesso) e Metabase (dashboard de temperatura e tabela de registros) adicionados ao README em `docs/images/`

---

## [0.9.3] — 2026-04-30

### Corrigido
- `restart: always` adicionado ao `postgres`, `airflow-webserver` e `airflow-scheduler` — containers sobem automaticamente após reinício da EC2

---

## [0.9.2] — 2026-04-30

### Corrigido
- Ponto e vírgula ausente após `CREATE TABLE` no `003_create_raw_tables.sql` corrigido
- `GRANT` movido para depois do `CREATE TABLE` no mesmo script — permissões agora aplicadas corretamente
- `is_paused_upon_creation=False` adicionado à DAG — pipeline inicia ativo sem necessidade de ativação manual

---

## [0.9.1] — 2026-04-30

### Corrigido
- `\c weather_db` adicionado ao topo dos scripts `001_create_schemas.sql`, `002_create_user.sql` e `003_create_raw_tables.sql` — schemas e tabelas agora criados no banco correto
- `CREATE USER` duplicado removido do `002_create_user.sql`
- Nome do schema corrigido de `mart` para `marts` em todos os scripts

---

## [0.9.0] — 2026-04-30

### Corrigido
- `depends_on` com `condition: service_healthy` adicionado ao `airflow-init` — elimina falha de conexão ao PostgreSQL durante a inicialização

---

## [0.8.3] — 2026-04-29

### Alterado
- Credenciais do Airflow padronizadas
- Estrutura do projeto e instruções de instalação revisadas no README

---

## [0.8.2] — 2026-04-29

### Adicionado
- `dbt/profiles/profiles.yml.example` adicionado como referência para novos ambientes

### Corrigido
- Arquivos SQL redundantes removidos
- Variáveis de ambiente padronizadas no `.env.example`

---

## [0.8.1] — 2026-04-29

### Adicionado
- `AIRFLOW__CORE__DEFAULT_TIMEZONE: America/Sao_Paulo` configurado globalmente no `docker-compose.yml`
- DAG agendada para rodar às 0h, 6h, 12h e 18h no horário de Brasília

---

## [0.8.0] — 2026-04-28

### Adicionado
- Dockerfile customizado — estende `apache/airflow:2.9.0-python3.10` com dbt-postgres, psycopg2-binary, python-dotenv e requests
- `docker-compose.yml` orquestrando postgres, airflow-init, airflow-webserver, airflow-scheduler e metabase
- Scripts de init do PostgreSQL em `sql/init/` — criação de usuários, bancos, schemas e tabela raw
- `.env.example` com todas as variáveis necessárias

### Observações técnicas
- `dbt-postgres==1.8.0` instalado com `--no-deps` para evitar compilação do psycopg2 dentro do container
- Volumes mapeados para persistência de dados e logs

---

## [0.7.1] — 2026-04-10

### Corrigido
- `weather_pipeline.py` corrigido
- `.env.example` e `requirements.txt` atualizados

---

## [0.7.0] — 2026-04-09

### Adicionado
- Alerta de email automático via Gmail configurado no Airflow
- `on_failure_callback` na DAG — email enviado em caso de falha em qualquer task com link direto para o log

---

## [0.6.0] — 2026-03-24

### Adicionado
- Seed `dim_cities.csv` com dados estáticos das 5 cidades monitoradas
- Testes expandidos na camada staging

---

## [0.5.0] — 2026-03-24

### Adicionado
- DAG `weather_pipeline` com 3 tasks: `coleta_dados → dbt_run → dbt_test`
- Agendamento via cron, retries configurados e callback de falha

---

## [0.4.0] — 2026-03-20

### Adicionado
- Modelo `stg_weather_metrics` (view) na camada staging
- Modelo `fct_weather_metrics` (table) na camada marts com colunas calculadas: `temperature_range`, `temperature_category`, `humidity_category`
- 25 testes de qualidade com dbt (`not_null`, `unique`, `accepted_range`, `accepted_values`)
- Macro `generate_schema_name` corrigindo concatenação de schemas

---

## [0.3.0] — 2026-03-20

### Adicionado
- Estrutura do projeto dbt configurada — `dbt_project.yml`, `profiles.yml`, `sources.yml`
- Conexão do dbt com PostgreSQL estabelecida

---

## [0.2.0] — 2026-03-20

### Adicionado
- `load.py` — conecta no PostgreSQL e insere registros na tabela `raw.weather_metrics`
- `collect.py` integrado ao `load.py` — pipeline de coleta e ingestão funcionando end-to-end

---

## [0.1.0] — 2026-03-20

### Adicionado
- `collect.py` — coleta dados meteorológicos de 5 cidades brasileiras via OpenWeather API
- Campos coletados: temperatura, umidade, pressão, vento, nebulosidade e descrição do tempo
