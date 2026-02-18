-- Platform: DataLemur
-- Problem: Top 5 Artists (Spotify)
-- SQL Dialect: PostgreSQL
-- Concepts: Joins, Group by, aggregation, Window functions(DENSE_RANK), Common Table Expressions (CTEs)

-- Summary:
-- Return the top 5 artists based on the number of songs that appeared in the global top 10 ranking. 


WITH s AS (SELECT  
  a.artist_name,
  COUNT(s.song_id) AS appearance
  
FROM artists a 
JOIN songs s 
  ON a.artist_id = s.artist_id
JOIN global_song_rank gs 
  ON s.song_id = gs.song_id
  AND gs.rank <= 10
GROUP BY a.artist_name),
  
gr AS (
  SELECT *,
  DENSE_RANK() OVER(ORDER BY appearance DESC ) AS artist_rank
  FROM s
  
)
  
SELECT 
  artist_name,
  artist_rank
FROM gr 
WHERE artist_rank <= 5
ORDER BY artist_rank, artist_name


-- NOTES
-- Output shape: top 5 artist name with their appearance rank (dense rank, no gaps)
-- Row unit: One row per artist
-- Filter the global ranking to only top 10 ranks
-- Join to songs -> artist to match songs and to global ranking
-- Count appearance per aech artist
-- DENSE_RANK artist by appearance count DESC(ties share rank: ranks stay continous no gaps )
-- Keep <=5 artist and return the artist name + rank sorted by artist rank and name