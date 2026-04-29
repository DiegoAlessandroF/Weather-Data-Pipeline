CREATE TABLE IF NOT EXISTS  raw.weather_metrics (
    
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
)
