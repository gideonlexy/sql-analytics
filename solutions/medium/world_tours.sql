-- Platform: StrataScratch
-- Problem: World Tours (Google)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions FIRST_VALUE()

-- Summary:
-- Calculate the number of travelers who starts from their homecity and ended therir trip back home




WITH travel_itinary AS (
SELECT *, 
    FIRST_VALUE(start_city) OVER(PARTITION BY traveler ORDER BY date ASC) AS starting_city,
    FIRST_VALUE(end_city) OVER(PARTITION BY traveler ORDER BY date DESC) AS ending_city

FROM travel_history)
SELECT
    COUNT(DISTINCT traveler) AS travellers
FROM travel_itinary
WHERE starting_city = ending_city

-- NOTES:
-- Output shape: One scalar value: number of travelers whose trip starts and ends in the same city.

-- Row unit: traveler (aggregated to a single count)

-- Step 1:
-- For each traveler, determine:
-- - starting_city -> earliest trip (FIRST_VALUE ordered ASC)
-- - ending_city   -> latest trip (FIRST_VALUE ordered DESC)

-- Step 2:
-- Attach these values to every row for that traveler using window functions.

-- Step 3:
-- Filter travelers where starting_city = ending_city.

-- Step 4:
-- Count distinct travelers satisfying the condition.
