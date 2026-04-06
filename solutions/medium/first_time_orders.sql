-- Platform: StrataScratch
-- Problem: First Time Orders (DoorDash)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, aggregation, GROUP BY

-- Summary:
-- For each merchant, calculate the total number of orders and the number of customers whose first-ever



WITH orders AS(
SELECT
    o.id, o.customer_id, o.merchant_id, m.name, o.order_timestamp,
    FIRST_VALUE(m.name) OVER (PARTITION BY  o.customer_id ORDER BY o.order_timestamp)
        AS first_merchant

FROM order_details o
INNER JOIN merchant_details m
ON o.merchant_id = m.id)
SELECT
    name,
    COUNT(*) AS merchant_orders,
    COUNT(DISTINCT CASE WHEN name = first_merchant THEN customer_id END) AS first_orders
    
FROM orders
GROUP BY name

-- NOTES:
-- Output shape: One row per merchant with:
-- - total number of orders
-- - number of customers whose first-ever order was from that merchant

-- Row unit: merchant

-- Step 1:
-- Join orders to merchant details to get merchant name for each order.

-- Step 2:
-- For each customer, identify the merchant of their first order using:
-- FIRST_VALUE(name) OVER (PARTITION BY customer_id ORDER BY order_timestamp)

-- Step 3:
-- Aggregate by merchant name:
-- - COUNT(*) = total orders for that merchant
-- - COUNT(DISTINCT CASE WHEN name = first_merchant THEN customer_id END)
--   = customers whose first order was with that merchant

