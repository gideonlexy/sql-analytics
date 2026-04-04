-- Platform: StrataScratch
-- Problem: Hour with Highest Order Volume (Postmates)
-- SQL Dialect: PostgreSQL
-- Concepts: date/time functions, aggregation, window functions

-- Summary:
-- Identify the hour of the day (0–23) that has the highest average number of orders across all days.


WITH hour_orders AS(
SELECT 
    DATE_TRUNC('day', order_timestamp_utc) AS order_hour,
    EXTRACT(HOUR FROM order_timestamp_utc) AS day_hour,
    COUNT(id) AS total_orders_hr

FROM postmates_orders
GROUP BY 1, 2),
rank_orders AS(
SELECT
    day_hour,
    AVG(total_orders_hr) AS avg_orders,
    DENSE_RANK() OVER(ORDER BY AVG(total_orders_hr) DESC ) AS rnk_avg
FROM hour_orders
GROUP BY 1)
SELECT
    day_hour,
    avg_orders
FROM rank_orders
WHERE rnk_avg = 1

--NOTES
-- Output shape:One or more rows showing hour(s) of the day with highest average orders.

-- Row unit:day_hour (0–23)
-- Aggregate orders at (day, hour) level to get hourly counts per day.
-- Compute average orders per hour across all days.
-- Rank hours by average orders in descending order using DENSE_RANK().
-- Select hour(s) with rank = 1 (highest average orders).

