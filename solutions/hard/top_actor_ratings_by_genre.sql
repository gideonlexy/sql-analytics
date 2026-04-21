-- Platform: StrataScratch
-- Problem: Top Actor Ratings By Genre(Google)
-- Summary
-- Find the top actors based on their average movie rating within the genre they appear in most frequently.

WITH genre_appearance AS(
SELECT 
    actor_name, genre,
    COUNT(*) AS genre_count,
    AVG(movie_rating) AS avg_m_rating
FROM top_actors_rating
GROUP BY 1, 2),
rank_genre AS (
SELECT 
    actor_name, genre,
    DENSE_RANK() OVER(PARTITION BY actor_name ORDER BY genre_count DESC, avg_m_rating DESC ) AS genre_rnk
FROM genre_appearance),
top_genre AS (SELECT 
    actor_name, genre
FROM rank_genre
WHERE genre_rnk = 1),
genre_avg_rating AS (SELECT
    tg.actor_name, tg.genre, AVG(tr.movie_rating) AS avg_rating
FROM top_genre tg
JOIN top_actors_rating tr
ON tg.actor_name = tr.actor_name
    AND tg.genre = tr.genre
GROUP BY 1, 2),
rnk_genre_avg AS (SELECT
    actor_name, genre, avg_rating,
    DENSE_RANK() OVER(ORDER BY avg_rating DESC ) AS rnk_avg
FROM genre_avg_rating)
SELECT
    actor_name, genre, avg_rating, rnk_avg
FROM rnk_genre_avg
WHERE rnk_avg <= 3

-- NOTES:
-- Output: Top 3 actor–genre pairs by average movie rating

-- Row unit: (actor_name, genre)

-- Pattern:
-- - Aggregate to actor–genre level → count appearances + avg rating
-- - Per actor: pick most frequent genre (tie → higher avg rating)
-- - Rank selected actor–genre pairs globally by avg rating
-- - Return top 3
