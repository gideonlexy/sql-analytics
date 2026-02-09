-- Platform: DataLemur
-- Problem: Cities With Completed Trades
-- SQL Dialect: PostgreSQL
-- Concepts: INNER JOIN, aggregation, GROUP BY, data filtering

-- Summary:
-- Join the trades and users tables to find the top 3 cities with the most completed trades.
-- Group the results by city and count the number of completed orders 

SELECT 
    city, 
    COUNT(order_id) AS total_orders
FROM trades t 
JOIN users u 
  ON t.user_id = u.user_id
WHERE status = 'Completed'
GROUP BY  city 
ORDER BY total_orders DESC
LIMIT 3

-- NOTES
-- The query should return top 3 cities with the most completed trades
-- We are given two tables 'trades' and 'users'
-- We need to do an INNER JOIN between the two tables and return the top 3 cities 
-- We filter the trades with oder status and return only rows with completed status
-- We then GROUP the results by cities and COUNT the completed orders 
-- We finally return the results from the Highest count to the Lowest with a limt of 3 only 