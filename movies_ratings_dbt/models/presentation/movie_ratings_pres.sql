with ratings as (
    select
        movieId,
        rating
    from
        {{ ref('ratings_raw_to_curate') }}
),
movies as (
    select
        id as movie_id,
        title
    from
        {{ ref('movies_raw_to_curate') }}
),
movie_ratings as (
    select
        r.movieId as movie_id,
        m.title,
        count(r.rating) as number_of_ratings,
        approx_quantiles(r.rating, 2)[OFFSET(1)] as median_rating
    from
        ratings r
    join
        movies m
    on
       r.movieId  = m.movie_id
    group by
        r.movieId, m.title
),
ranked_movies as (
    select
        movie_id,
        title,
        number_of_ratings,
        median_rating,
        rank() over (order by median_rating desc) as rank
    from
        movie_ratings
)
select
    movie_id,
    title,
    number_of_ratings,
    median_rating,
    rank
from
    ranked_movies
