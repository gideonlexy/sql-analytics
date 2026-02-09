-- Platform: DataLemur
-- Problem: Pharmacy Analytics (CVS Pharmacy)
-- SQL Dialect: PostgreSQL
-- Concepts: arithmetic operations, ORDER BY, LIMIT

-- Summary:
-- Perfom a simple calculations to find the profit of the top 3 most sold drugs by CVS Pharmacy


SELECT 
    drug,
    total_sales - cogs AS total_profit
FROM pharmacy_sales
ORDER BY total_profit DESC
LIMIT 3

--NOTES
-- The query should return the top 3 profitable drugs
-- We are given two columns names to help us calculate the profit
-- To find the profit we subtract the 'cogs' from the 'total sales'
-- We finally order the results in descending order to ge the top most(highest) to lowest 
-- And since we only need the top 3 we Limit it with value of 3