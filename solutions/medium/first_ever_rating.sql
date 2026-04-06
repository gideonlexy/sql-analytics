-- Platform: StrataScratch
-- Problem: First Ever Rating (DoorDash)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, FIRST_VALUE()

-- Summary:
-- Calculate the percentage of drivers whose first-ever delivery received a rating of 0.

WITH first_ever_orders AS (
SELECT 
    driver_id, delivery_id, delivery_rating,
    FIRST_VALUE(delivery_id) OVER(PARTITION BY driver_id ORDER BY actual_delivery_time ASC) AS first_order
    
    
FROM delivery_orders
WHERE actual_delivery_time IS NOT NULL),

first_orders AS (
SELECT 
    driver_id,
    delivery_id, delivery_rating
FROM first_ever_orders
WHERE delivery_id = first_order),

count_orders AS (
SELECT
    COUNT(CASE WHEN delivery_rating = 0 THEN delivery_id END) AS zero_rating,
    COUNT(delivery_id) AS orders_delivered
FROM first_orders)
SELECT 
    (zero_rating * 1.0 / orders_delivered) * 100 AS percentage
FROM count_orders

-- Output shape: One scalar value: percentage of first deliveries with rating = 0.

-- Row unit: single summary value

-- Filter to completed deliveries (actual_delivery_time IS NOT NULL).

-- For each driver, identify their first-ever delivery using:
-- FIRST_VALUE(delivery_id) OVER (PARTITION BY driver_id ORDER BY actual_delivery_time).

-- Keep only first deliveries per driver by matching delivery_id = first_order.

-- Aggregate:
-- - zero_rating -> count of first deliveries with rating = 0
-- - orders_delivered -> total number of first deliveries

-- Compute percentage:
-- (zero_rating / orders_delivered) * 100



