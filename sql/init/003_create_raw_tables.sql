\c weather_db

CREATE TABLE IF NOT EXISTS raw.weather_metrics (
    id              SERIAL PRIMARY KEY,
    city            TEXT NOT NULL,
    country         TEXT NOT NULL,
    collected_at    TIMESTAMP NOT NULL,
    temp            FLOAT,
    temp_min        FLOAT,
    temp_max        FLOAT,
    humidity        INT,
    pressure        INT,
    weather         TEXT,
    wind_speed      FLOAT,
    cloudiness      INT,
    loaded_at       TIMESTAMP DEFAULT NOW()
);

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA raw TO pipeline_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA raw TO pipeline_user;