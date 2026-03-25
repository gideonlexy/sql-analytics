-- Platform: StrataScratch
-- Problem: Delivering and Placing Orders (Doordash)
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, GROUP BY, correlation
-- Summary:
-- Calculate the daily net revenue for a specific product (PROD-2891) in the US between April 15, 2025, and April 28, 2025.

SELECT ROUND(CORR(delivery_time::numeric, net_total)::numeric, 2) AS correlation
FROM 
(SELECT 
    restaurant_id,
    AVG(order_total + tip_amount - discount_amount - refunded_amount) AS net_total ,
    AVG(EXTRACT(EPOCH FROM (delivered_to_consumer_datetime - customer_placed_order_datetime)) / 60.0)  AS delivery_time
FROM delivery_details
GROUP BY restaurant_id) t

-- NOTES
-- Output shape: 1 row showing correlation between average total order value and average time in minutes
-- between placing an order and having it delivered per restaurant
-- Row unit: correlation(average_total, average_time_delivery)
-- Pattern:
-- Aggregate rows to restaurant grain level
-- compute AVG(order_total + tip_amount - discount_amount - refunded_amount) and
-- AVG(delivered_to_consumer_datetime - customer_placed_order_datetime) per each restaurant and using  EXTRACT(EPOCH)/60.0 to convert interval to minutes
-- compute corr(average_total,average_time_delivery) rounded off to 2 dp