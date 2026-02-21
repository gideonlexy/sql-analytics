-- Platform: DataLemur
-- Problem: Pharmacy Analytics Part 3 (CVS Pharmacy)
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, GROUP BY, CTE, CONCAT

-- Summary:
-- Calculate the total sales for each drug manufacturer, round it to the nearest million, 
-- and format the output to include the sales in millions with a dollar sign.

WITH sum_sales AS (
SELECT 
  manufacturer,
 ROUND(SUM(total_sales) / 1000000) AS sale
FROM pharmacy_sales
GROUP BY manufacturer
)

SELECT
  manufacturer,
  CONCAT('$', sale, ' million') AS sales_mil 
FROM sum_sales
ORDER BY sale DESC, manufacturer

-- NOTES
-- Output shape: total sales rounded to millions per drug manufacturer 
-- Group by manufacturer to calculate total sales and round off to nearest a million
-- CONCAT is used to format the results in the desired output
-- Order by sales DESC to return the top mafucturers and mafactures name incase of ties 