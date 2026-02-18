-- rank the artist within eache genre based on their revenue per member.
-- extract top-revenue genearating artist from each genre 
-- display the artist name, genre, concert revenue, number of members and revenue per band memeber
-- sort by the highest revenue per member within each genre
WITH genre_cte AS(
SELECT artist_name, genre, concert_revenue, number_of_members,
  (concert_revenue / number_of_members ) AS revenue_per_band,
  DENSE_RANK() OVER (
    PARTITION BY genre
    ORDER BY (concert_revenue / number_of_members ) DESC) AS rn
FROM concerts)

SELECT *
FROM genre_cte
WHERE rn = 1
ORDER BY revenue_per_band DESC

-- NOTES 
-- Output shape: 1 row per genre (or multiple rows if there are ties) showing the top artist by revenue per member.
-- Row unit: genre-level winner (an artist selected within each genre).

--  Compute the metric to rank by: revenue_per_member = concert_revenue / number_of_members
--  Use DENSE_RANK() window function to rank artists within each genre by revenue_per_member (highest first).
--  Filter to rn = 1 to keep only the top-ranked artist(s) per genre.
--  Sort results by revenue_per_member descending for display.