-- Platform: DataLemur
-- Problem: Wine Variety Revenues (Wine Magazine)
-- SQL Dialect: PostgreSQL
-- Concepts: UNION, Common Table Expressions (CTEs), aggregation, GROUP BY, filtering

-- Summary:
-- Calculate total revenue for each wine variety by region

WITH regions AS (
SELECT 
    region_1 AS region,
    variety,
    price
FROM winemag_p1
UNION 
SELECT
    region_2 AS region,
    variety,
    price
FROM winemag_p1)
SELECT 
    region,
    variety,
    SUM(price) AS amount
FROM regions
WHERE price IS NOT NULL
    AND region IS NOT NULL
GROUP BY 1,2
ORDER BY amount DESC

-- NOTES
-- Outputshape: total costs of wine per(region, variety)
-- row unit: (region, variety)
-- Pattern
-- Normalize the two region columns into one region column using a CTE.
-- Exclude rows where region or price is NULL.
-- Group by region and variety.
-- Sum price within each (region, variety) group.
-- Sort results by total summed price in descending order.
