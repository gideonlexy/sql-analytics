-- Platform: StrataScratch
-- Problem: Rank Variance by Country (Facebook)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, aggregation, GROUP BY, filtering

-- Summary:
-- Compare the total number of comments made by users in each country during December 2019 and January 2020.

WITH number_of_comments AS (
SELECT 
    u.country AS country,
    DATE_TRUNC('month', c.created_at) AS year_month,
    SUM(c.number_of_comments) AS total_comments
FROM fb_active_users u
INNER JOIN fb_comments_count c USING(user_id)
WHERE created_at BETWEEN '2019-12-01' AND '2020-01-31'
GROUP BY DATE_TRUNC('month', created_at), country),

rank_country AS (
SELECT *,
    
    DENSE_RANK() OVER(PARTITION BY year_month ORDER BY total_comments DESC) AS rnk
FROM number_of_comments),

month_rank AS (
SELECT country,
    MAX(CASE WHEN year_month = DATE '2019-12-01' THEN rnk END ) AS dec_rank,
    MAX(CASE WHEN year_month = DATE '2020-01-01' THEN rnk END ) AS jan_rank
FROM rank_country
GROUP BY country)

SELECT 
    country
FROM month_rank
WHERE dec_rank > jan_rank
    AND dec_rank IS NOT NULL
    AND jan_rank IS NOT NULL
ORDER BY country

-- NOTES
-- Output shape: list of country where rank improved from Dec to Jan.
-- Row unit (final): one row per country.
-- Pattern:
-- Join comments to users to attach country.
-- Aggregate SUM(number_of_comments) by month_start, country.
-- Use DENSE_RANK per month to rank countries by total comments (ties share rank, no gaps).
-- Pivot Dec/Jan ranks per country and filter  dec_rank > jan_rank .
   



