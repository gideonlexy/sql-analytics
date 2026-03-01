-- Platform: StrataScratch
-- Problem:Best Selling Item (Ebay)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, aggregation, GROUP BY, filtering

-- Summary:
-- Identify the best selling item (highest revenue) for each month in the online_retail table.

WITH total_sales AS (
SELECT  
    description,
    EXTRACT(MONTH FROM invoicedate) AS month,
    SUM(unitprice * quantity) AS total_paid
FROM online_retail
WHERE invoiceno NOT LIKE 'C%'
GROUP BY  EXTRACT(MONTH FROM invoicedate) , description),

rnk_product AS (
SELECT
    month,
    description,
    total_paid,
    ROW_NUMBER() OVER(PARTITION BY month ORDER BY total_paid DESC) AS top_product
FROM total_sales)

SELECT
    month, description, total_paid
FROM rnk_product
WHERE top_product = 1

-- NOTES
-- Outputshape: 1 row per month showing the highest grosiing product and it's total sales 
-- Row unit: month (top product within each month)
-- Pattern: aggregate the revenue per(month, description) using SUM(unitprice * quantity)
-- excluding cancelled invoices
-- ROW_NUMBER() is used to assign rank within the item partition  by month sorted by total sales
-- Filter to the top most item top_product =1 