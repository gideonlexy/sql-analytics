-- Platform: DataLemur
-- Problem: Laptops vs Mobile Viewership(NYC Times)
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, GROUP BY, CTE, date filtering

-- Summary:
-- SUM device views by category (laptops vs mobile) 


SELECT 
  SUM(CASE WHEN device_type = 'laptop' THEN 1  END ) AS laptop_views,
  SUM(CASE WHEN device_type IN('tablet', 'phone') THEN 1  END) AS mobile_views
FROM viewership;

-- NOTES
-- Output shape is a single summary row with two metrics: laptops views and mobile views
-- Each row in viewership table reprensents a view event, so we count rows not users
-- Conditional aggregatation is used: CASE 1 return for matching device types and 0 otherwise
-- then SUM adds them to compute totals for each category.
