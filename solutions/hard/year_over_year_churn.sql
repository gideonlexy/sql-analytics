
-- Platform: StrataScratch
-- Problem: Year-over-Year Churn (Lyft)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, aggregation, conditional filtering

-- Summary:
-- Calculate the year-over-year change in the number of drivers who churned (ended their service) for each year.

WITH churn AS (SELECT 
    EXTRACT(YEAR FROM end_date) AS year,
    COUNT(*) AS churn_drivers

FROM lyft_drivers
WHERE end_date IS NOT NULL
GROUP BY 1),
prev_churn AS (
SELECT *,
    LAG(churn_drivers, 1, 0) OVER(ORDER BY year) AS prev_drivers
FROM churn
)

SELECT 
    *,
    CASE 
        WHEN churn_drivers > prev_drivers THEN 'increase'
        WHEN churn_drivers < prev_drivers THEN 'decrease'
        ELSE 'no change'
    END AS changes
FROM prev_churn

-- Output shape: One row per year with:
 -- churned drivers in that year
 -- churned drivers in previous year
 -- change direction (increase / decrease / no change)

-- Row unit: year

-- Step 1:
-- Filter churn events using end_date IS NOT NULL (active drivers excluded).

-- Step 2:
-- Extract year from end_date and aggregate to yearly churn counts.

-- Step 3:
-- Use LAG() over ordered years to get previous year's churn count.
-- Default value 0 handles the first year.

-- Step 4:
-- Compare current vs previous year and assign changes
