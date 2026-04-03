
-- Platform: StrataScratch
-- Problem: Most Senior and Junior Employee (Uber)
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, filtering, date arithmetic

-- Summary:
-- Identify the most senior and most junior active employees based on their hire dates. 
-- Calculate the number of days between their hire dates.


WITH days_hired AS (
SELECT
    MIN(hire_date) AS earlier_hire,
    MAX(hire_date) AS latest_hire
FROM uber_employees
WHERE termination_date IS NULL)

SELECT
    COUNT(*) FILTER (WHERE hire_date = (SELECT earlier_hire FROM days_hired )) AS longest_tenure,
    COUNT(*) FILTER (WHERE hire_date = (SELECT latest_hire FROM days_hired )) AS shortest_tenure,
    MAX(hire_date) -   MIN(hire_date) AS days

FROM uber_employees
WHERE termination_date IS NULL

-- Output shape:One row with:
-- - count of longest-tenured active employees
-- - count of least-tenured active employees
-- - days between earliest and latest hire dates

-- Row unit: single summary row

-- Step 1:
-- Filter to active employees (termination_date IS NULL).

-- Step 2:
-- Compute global bounds using CTE:
-- - earlier_hire = MIN(hire_date)
-- - latest_hire  = MAX(hire_date)

-- Step 3:
-- Use FILTER with COUNT(*) to count:
-- - employees whose hire_date = earliest (longest tenure)
-- - employees whose hire_date = latest (shortest tenure)

-- Step 4:
-- Compute day difference directly using:
-- MAX(hire_date) - MIN(hire_date)
