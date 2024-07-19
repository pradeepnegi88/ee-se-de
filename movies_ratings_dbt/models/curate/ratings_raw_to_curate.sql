{{ config(
    materialized='incremental',
    unique_key=['userId', 'movieId'],
    on_schema_change='fail'
) }}


with remove_duplicated_data as (
    select
        userId,
        movieId,
        rating,
        timestamp,
        load_date,
        ROW_NUMBER() OVER (PARTITION BY userId, movieId ORDER BY timestamp DESC) as row_num
    from
        {{ source('movies_data_pradeep', 'ratings_raw') }} 
)

SELECT 
    CAST(userId AS NUMERIC) AS userId,
    CAST(movieId AS NUMERIC) AS movieId,
    CAST(rating AS NUMERIC) AS rating,
    CAST(timestamp AS NUMERIC) AS timestamp,
    TIMESTAMP_SECONDS(CAST(timestamp AS INT64)) AS converted_timestamp,
    CAST(load_date AS DATE) AS load_date
FROM 
    remove_duplicated_data
where
    row_num = 1

{% if is_incremental() %}
AND CAST(timestamp AS NUMERIC) > (SELECT MAX(CAST(timestamp AS NUMERIC)) FROM {{ this }})
{% endif %}
