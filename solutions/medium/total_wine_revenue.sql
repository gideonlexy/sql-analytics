-- Platform: StartaScratch
-- Problem: Total Wine Revenues (Wine Magazine)
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, GROUP BY, HAVING filtering

-- Summary:
-- Calculate total revenue for each wine variety with a minimum rating of 90 points, and sort the results by winery and total revenue.

SELECT 
    winery,
    variety,
    SUM(price) AS total
FROM winemag_p1
GROUP BY 1,2
    HAVING MIN(points) >= 90
ORDER BY 1 ASC, total DESC

-- NOTES
-- OutputShape : total revenue for (wine, variety) pair that have >= 90 points
-- Row unit: 1 row (wine,variety) totals
-- Pattern:
-- Group rows by winery and variety pair 
-- Compute the total revenue using SUM(price) within each group
-- Keep only rows that have group levev (winery, variety) >= 90
-- Sort the results by winery ascending and total revenue descending

