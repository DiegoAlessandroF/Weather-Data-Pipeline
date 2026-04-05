with staging as (
    select * from {{ ref('stg_weather_metrics') }}
),

final as (
    select
        id,
        city,
        country,
        collected_at::date                                      as collected_date,
        collected_at::time                                      as collected_time,
        temperature,
        temperature_min,
        temperature_max,
        temperature_max - temperature_min                       as temperature_range,
        humidity,
        pressure,
        weather_description,
        wind_speed,
        cloudiness,
        case
            when temperature < 15 then 'frio'
            when temperature between 15 and 25 then 'agradável'
            when temperature between 25 and 32 then 'quente'
            else 'muito quente'
        end                                                     as temperature_category,
        case
            when humidity < 30 then 'seco'
            when humidity between 30 and 60 then 'confortável'
            else 'úmido'
        end                                                     as humidity_category,
        loaded_at
    from staging
)

select * from final 