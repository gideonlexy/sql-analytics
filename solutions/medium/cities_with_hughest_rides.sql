-- Platform: StrataScratch
-- Problem: Cities with Highest Rides (Lyft)
-- SQL Dialect: PostgreSQL
-- Concepts: JOINs, aggregation, CTEs

-- Summary:
-- Identify the city or cities with the highest number of rides in August 2021, excluding rides that used a promo code.


WITH rides AS (
SELECT 
    city,
    COUNT(o.order_id) AS order_counts

FROM lyft_orders o
JOIN lyft_payments p
ON o.order_id = p.order_id
    AND DATE_TRUNC('month', p.order_date) = '2021-08-01'
    AND p.promo_code = FALSE
GROUP BY 1)

SELECT 
    city
FROM rides
WHERE order_counts = (SELECT MAX(order_counts) FROM rides)

-- Output shape:One or more rows showing city/cities with highest number rides.

-- Row unit: city

-- Join orders with payments to link each ride to its payment details.
-- Filter in join:
-- - restrict to August 2021 (DATE_TRUNC month filter)
-- - exclude promo rides (promo_code = FALSE)
-- Aggregate to city level:
-- COUNT(order_id) = total qualifying rides per city.
-- Identify maximum ride count across all cities.
-- Return city/cities whose count equals the maximum.

