-- Platform: StrataScratch
-- Problem: Average Orders Rush Hours (DoorDash)
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, GROUP BY, date filtering

-- Summary:
-- For orders placed in the San Jose region between 3 PM and 6 PM, 
-- calculate the average net order value (order_total + tip_amount - discount_amount - refunded_amount) for each

WITH san_jose_orders AS(
SELECT 
    customer_placed_order_datetime,
    EXTRACT(HOUR FROM customer_placed_order_datetime) AS order_hour,
    (order_total + tip_amount - discount_amount - refunded_amount) AS net_order

FROM delivery_details
WHERE EXTRACT(HOUR FROM customer_placed_order_datetime) >= 15 
    AND  EXTRACT(HOUR FROM customer_placed_order_datetime) < 18
    AND delivery_region = 'San Jose')
    
SELECT 
    order_hour,
    AVG(net_order) AS avg_order_value
FROM san_jose_orders
GROUP BY 1

-- NOTES

-- Output shape: One row per hour (15–17) with average net order value.
-- Row unit: order_hour
-- Filter orders to San Jose region and time window (3 PM to 6 PM -> hours 15–17).
-- Extract hour from order timestamp.
-- Compute net order value:
-- order_total + tip_amount - discount_amount - refunded_amount.
-- Aggregate by hour and compute AVG(net_order).
