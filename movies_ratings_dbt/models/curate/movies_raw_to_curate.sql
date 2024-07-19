 SELECT 
    SAFE_CAST(adult AS BOOL) AS adult,
    SAFE.PARSE_JSON(belongs_to_collection) AS belongs_to_collection,
    SAFE_CAST(budget AS NUMERIC) AS budget,
    JSON_QUERY_ARRAY(genres) AS genres,
    homepage,
    SAFE_CAST(id AS NUMERIC) AS id,
    imdb_id,
    original_language,
    original_title,
    overview,
    SAFE_CAST(popularity AS NUMERIC) AS popularity,
    poster_path,
    JSON_QUERY_ARRAY(production_companies) AS production_companies,
    JSON_QUERY_ARRAY(production_countries) AS production_countries,
    SAFE_CAST(release_date AS DATE) AS release_date,
    SAFE_CAST(revenue AS NUMERIC) AS revenue,
    SAFE_CAST(runtime AS NUMERIC) AS runtime,
    JSON_QUERY_ARRAY(spoken_languages) AS spoken_languages,
    status,
    tagline,
    title,
    SAFE_CAST(video AS BOOL) AS video,
    SAFE_CAST(vote_average AS NUMERIC) AS vote_average,
    SAFE_CAST(vote_count AS NUMERIC) AS vote_count,
    SAFE_CAST(load_date AS DATE) AS load_date
FROM 
     {{ source('movies_data_pradeep', 'movies_raw') }}  

