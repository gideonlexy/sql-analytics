-- Platform: StrataScratch
-- Problem: Growth of Airbnb (Airbnb)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, aggregation
-- Summary:
-- Calculate the year-over-year growth rate of Airbnb hosts.

WITH total_hosts AS (
SELECT
    EXTRACT(YEAR FROM host_since) AS year,
    COUNT(id) AS current_hosts,
    LAG(COUNT(id),1) OVER(ORDER BY EXTRACT(YEAR FROM host_since )ASC ) AS prev_host
    
FROM airbnb_search_details
GROUP BY 1)
SELECT 
    year, current_hosts, prev_host,
    ROUND(((current_hosts - prev_host) * 100.0 / prev_host))  AS growth
FROM total_hosts

-- NOTES
-- Output Shape: rows with year, number of hosts in the current year, number of hosts in the previous year, and the growth rate
-- Row unit: year
-- Pattern:
-- aggregate rows to year level using EXTRACT(YEAR FROM host_since)
-- count hosts within each year using COUNT(id)
-- use window function LAG(current_hosts) Over year order to retrieve the previous year's host count
-- compute the growth rate: ((current - prev) / prev) * 100
    
