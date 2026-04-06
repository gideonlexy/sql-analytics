-- Platform: StrataScratch
-- Problem: Highest Energy Consumption (Facebook)
-- SQL Dialect: PostgreSQL
-- Concepts: UNION ALL, aggregation, CTEs

-- Summary:
-- Determine the date with the highest total energy consumption across all Facebook data centers. The energy consumption

WITH data_centers AS (
SELECT * FROM fb_na_energy
UNION ALL
SELECT * FROM fb_eu_energy
UNION ALL
SELECT * FROM fb_asia_energy),

total_consumption AS (
SELECT 
    recorded_date, 
    SUM(consumption) AS consumption
FROM data_centers
GROUP BY 1)
SELECT 
    recorded_date,
    consumption
FROM total_consumption 
WHERE consumption = (SELECT MAX(consumption) FROM total_consumption)

--NOTES:

-- Output shape:One or more rows showing date(s) with highest total energy consumption.

-- Row unit: recorded_date

--Pattern:

-- Step 1:
-- Combine data from all regions (NA, EU, Asia) using UNION ALL.

-- Step 2:
-- Aggregate total energy consumption per date:
-- SUM(consumption) grouped by recorded_date.

-- Step 3:
-- Identify the maximum total consumption across all dates.

-- Step 4:
-- Return date(s) where total consumption equals the maximum.
