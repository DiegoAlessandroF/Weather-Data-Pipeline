CREATE USER pipeline_user WITH PASSWORD 'pipeline_pass';
CREATE USER airflow WITH PASSWORD 'airflow';
CREATE DATABASE weather_db OWNER pipeline_user;
CREATE DATABASE airflow OWNER airflow;
CREATE DATABASE metabase OWNER postgres;