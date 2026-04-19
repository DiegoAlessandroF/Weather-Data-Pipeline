with source as (
    select * from {{ source('raw', 'weather_metrics') }}
),

renamed as (
    select
        id,
        city,
        country,
        collected_at,
        temp                as temperature,
        temp_min            as temperature_min,
        temp_max            as temperature_max,
        humidity,
        pressure,
        weather             as weather_description,
        wind_speed,
        cloudiness,
        loaded_at
    from source
)

select * from renamed