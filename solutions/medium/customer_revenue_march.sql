
-- Platform: StartaScratch
-- Problem: Total Customer Revenues (March 2019)
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, GROUP BY, date filtering

-- Summary:
-- Calculate total revenue for each customer with orders in March 2019, and sort the results by total revenue.

SELECT 
    cust_id,
    SUM(total_order_cost) AS revenue

FROM orders
WHERE order_date >= '2019-03-01' AND order_date < '2019-03-31'
GROUP BY cust_id
ORDER BY revenue desc

-- NOTES
-- OutputShape: total sales revenue per customer active in March 2019
-- Row unit: 1 row per customer
-- Pattern:
-- filter the transactions to include only orders in March 2019
-- Group by customer_id to aggregate at customer level
-- Compute the total revenue by SUM(total_order_cost)
-- Sort the results by total revenue descending