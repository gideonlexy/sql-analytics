-- Platform: DataLemur
-- Problem: Odd and Even Measurements (Google)
-- SQL Dialect: PostgreSQL
-- Concepts: Window functions, Group by, aggregation, Common Table Expressions (CTEs)

-- Summary:
-- return the most recent transaction date and the purchase count for each user.

WITH ns AS (SELECT *,
  DATE_TRUNC('day', measurement_time) AS measurement_day,
  ROW_NUMBER() OVER (
    PARTITION BY DATE_TRUNC('day', measurement_time) 
    ORDER BY measurement_time  ) AS row_number
  
FROM measurements
ORDER BY measurement_time)

SELECT 
  measurement_day,
  SUM(
    CASE WHEN row_number % 2 = 1 THEN measurement_value ELSE 0
    END) AS odd_sum,
    SUM(
    CASE WHEN row_number % 2 = 0 THEN measurement_value ELSE 0
    END) AS even_sum
FROM ns
GROUP BY measurement_day
ORDER BY measurement_day

-- NOTES 
-- Output shape: 1 row per day with odd_sum and even_sum.
-- Row unit: day.
-- Pattern:
-- 1) USe DATE_TRUNC to normalize timestamps to day grain.
-- 2) Use ROW_NUMBER() to order measurements within each day.
-- 3) Use conditional aggregation (rn % 2) to split odd vs even positions.
-- 4) GROUP BY day to return final daily totals.
