-- Platform : StataScratch
-- Problem : Total Cost of Orders(Amazon)

-- Ouput : cust_id, first_name, total_order_cost
-- Who/Entity ?: customer
-- Metric : Find the total cost of customer's orders; SUM(total_order_cost) per customer
-- filter : none
-- operation : orders sorted by first_name ASC

-- Level 0: Output(cust_id, first_name, total_order_cost)
-- grain : one per cust_id
-- columns : cust_id, first_name, total_order_cost
-- operation :PROJECT; sort by first_name ASC

-- Level 1: Need to compute the total_order_cost
-- grain : one row per cust_id
-- columns : cust_id, fist_name, total_order_cost
-- operations : Join customer details to order to map each customer with their orders
-- Group by cust_id and compute SUM(total_order_cost) per customer

-- Raw table:
-- customers : grain : one row per customer details
-- Orders : grain : multiple rows per customer transactions

-- Build the data
SELECT
    c.id, c.first_name, 
    SUM(o.total_order_cost) AS total_cost

FROM customers c
JOIN orders o
ON c.id = o.cust_id
GROUP BY 1, 2
ORDER BY c.first_name ASC
