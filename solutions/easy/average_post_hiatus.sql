-- Platform: DataLemur
-- Problem: Average Post Hiatus(Facebook)
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, GROUP BY, data filtering

-- Summary:
-- Count the number of days between first and last post for users who posted more than 2 times in 2021.


SELECT 
  user_id,
  MAX(post_date::DATE) - MIN(post_date::DATE) AS days_between
FROM posts
WHERE EXTRACT(YEAR FROM post_date) = 2021
GROUP BY user_id
HAVING COUNT(post_id) > 2


-- NOTES
-- Output shape: 1 row per user with a day_gap between the first and the last post in 2021
-- Row Unit: Each row represent a single post event(we aggragate to user_level)
-- Pattern: Group By and aggragation is used: filter the posts to 2021, group by user,
-- keep users with >=2 posts then compute max/min dates and subtract