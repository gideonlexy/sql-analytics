
-- Platform: StrataScratch
-- Problem: Top Business with Most Reviews
-- SQL Dialect: PostgreSQL
-- Concepts: RANK(), window functions, ordering, filtering

-- Summary:
-- Identify the top 5 businesses with the highest number of reviews.

WITH review_rank AS (
SELECT name, review_count,
    RANK() OVER(ORDER BY review_count DESC) AS rnk
FROM yelp_business)

SELECT 
    name, review_count
FROM review_rank
WHERE rnk <= 5

-- NOTES
-- Outputshape: Top 5 businesses with the most reviews
-- Row unit: one row per business
-- Patttern: RANK() is used to assign competiton ranks to business, ties share ranks
-- then filter to ranks <= 5