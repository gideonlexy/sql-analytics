-- Platform: StrataScratch
-- Problem: Extremely Late Deliveries (DoorDash)
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, GROUP BY, date filtering

-- Summary:
-- For each month, calculate the percentage of deliveries that were extremely late 
-- (actual delivery time > predicted delivery time + 20 minutes) out of all completed deliveries.

WITH orders AS (
SELECT 
    DATE_TRUNC('MONTH', order_placed_time ) AS order_month,
    COUNT(delivery_id) AS orders_delivered,
    COUNT(CASE WHEN actual_delivery_time > predicted_delivery_time + INTERVAL '20 MINUTES' 
        THEN delivery_id END ) AS late_orders
FROM delivery_orders
WHERE actual_delivery_time IS NOT NULL
GROUP BY 1)
SELECT
    TO_CHAR(order_month, 'YYYY-MM') AS order_month,
    (late_orders * 1.0 / orders_delivered) * 100 AS percentage
FROM orders

-- Output shape: One row per month with percentage of late deliveries.
-- Row unit: month
-- Pattern:
-- Filter to completed deliveries only (actual_delivery_time IS NOT NULL).
-- Truncate order_placed_time to month to define monthly grouping.
-- Aggregate per month:
-- - total orders = COUNT(delivery_id)
-- - late orders = COUNT(CASE WHEN delivery delay > 20 minutes THEN delivery_id END)
-- Compute late delivery percentage:
-- (late_orders / total_orders) * 100
-- Format month as 'YYYY-MM' for output.

