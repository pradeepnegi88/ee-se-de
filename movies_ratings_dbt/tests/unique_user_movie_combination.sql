SELECT
    userId,
    movieId,
    COUNT(*) as row_count
FROM {{ ref('ratings_raw_to_curate') }}
GROUP BY userId, movieId
HAVING COUNT(*) > 1
