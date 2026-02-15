
-- Platform: DataLemur
-- Problem: SuperCloud Customer (Microsoft)
-- SQL Dialect: PostgreSQL
-- Concepts: Joins, Group by, aggregation, HAVING clause

-- Summary:
-- Update advertiser status based on their payment activity and previous status. 



SELECT
  customer_id
FROM customer_contracts c 
JOIN products p 
  ON c.product_id = p.product_id
GROUP BY customer_id
HAVING COUNT(DISTINCT p.product_category ) = 
  (SELECT COUNT(DISTINCT product_category ) FROM products)
  

-- Notes
-- Output shape:1 row per customer_id who have purchased from all the product categories
-- INNER JOIN is used: to join customers_contracts with products through products_id 
-- GROUP BY customer_id and COUNT DISTINCT customer product category =  total distinct category 