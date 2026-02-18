-- Platform: DataLemur
-- Problem: Histogram of User and Purchases (Walmart)
-- SQL Dialect: PostgreSQL
-- Concepts: Window functions, Group by, aggregation, Common Table Expressions (CTEs)

-- Summary:
-- return the most recent transaction date and the purchase count for each user.

WITH tr AS (SELECT 
  user_id, transaction_date,
  COUNT(product_id) OVER (PARTITION BY user_id, transaction_date) AS purchase_count,
  ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS time_purchase

FROM user_transactions
ORDER BY transaction_date)

SELECT 
  transaction_date, user_id, purchase_count
FROM tr 
WHERE time_purchase = 1

-- NOTES
-- Output shape: row per user showing the most recent transaction and the purchase count 
-- Row unit: one transaction 

-- Count the products per transaction per user(purchase count) 
-- Use ROW_NUMBER to assign the most recent transaction per user ordering by transaction date DESC
-- Return the top recent transaction per user and the purchase count 
