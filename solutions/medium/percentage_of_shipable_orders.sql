-- Platform : StrataScratch
-- Problem : Percentage of Shipable Orders
-- Summary : Calculate the percentage of orders that are shipable, and output a scalar value showing the percentage of shipable orders.

-- Output : scalar a percentage showing shippable orders
-- WHo/Entity : orders
-- Metric : COUNT(is_shipable) / COUNT(*) * 100
-- Hidden : NULL adresses != shipable

-- Level 0: Output(scalar percentage)
-- grain : single row, single value 
-- colums : order_id, is_shipable
-- operation : COUNT(is_shipable) / COUNT(order_id) * 100

-- Level 1: Need to Label shipable orders
-- grain : one row per order_id
-- columns : order_id, adress
-- operartion : CASE WHEN adress IS NOT NULL THEN is_shipable

-- Level 2: Enrich orders with customer adress
-- grain : one row per order_id per per customer_id
-- colums : order_id, customer_id, adress
-- operation : LEFT JOIN orders ON orders.cust_id = customer.id

-- Raw tables:
-- orders : one row per order details (id, cust_id, order_date)
-- customers : one row per customer details (cust_id,name, adress)

-- Build the data up from the immediate Level
-- LEVEL 2
WITH cust_orders AS (SELECT 
    o.id AS order_id, o.cust_id AS cust_id, o.order_date, c.address AS adress
FROM orders o
LEFT JOIN customers c
ON o.cust_id = c.id
ORDER BY order_date, cust_id),
-- LEVEL 1
label_orders AS (SELECT
    order_id, cust_id, order_date, adress,
    CASE WHEN adress IS NOT NULL THEN 1 ELSE NULL END AS is_shipable
FROM cust_orders)
-- LEVEL 0:OUTPUT
SELECT
    100.0 * COUNT(is_shipable) / COUNT(order_id)  AS percentage
FROM label_orders