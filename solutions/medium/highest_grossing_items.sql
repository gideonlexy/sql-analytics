-- Platform: DataLemur
-- Problem: Hihest Grossing Items (Amazon)
-- SQL Dialect: PostgreSQL
-- Concepts: Window functions, Group by, aggregation, Common Table Expressions (CTEs)

-- Summary:
-- Identify the two highest-grossing products within each category for the year 2022 based on total spend.


WITH rn AS (SELECT 
   category,product,
   sum(spend) AS total_spend,
   DENSE_RANK() OVER(PARTITION BY category ORDER BY sum(spend) DESC) AS ranks
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product)

SELECT 
  category, product, total_spend
FROM  rn 
WHERE ranks <= 2
ORDER BY category, ranks;

-- NOTES
-- Output shape: rows showing the two highest-grossing products within each category in 2022
-- Row unit: each row represent asingle transaction on a product purchase
-- Pattern: aggregate amount and group by product, category to get total_spend
-- DENSE_RANK() is used to rank the products on the total amount spent
  
