
-- Platform: StrataScratch
-- Problem: Sales per Territory (Shopify)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, aggregation, GROUP BY, date filtering

-- Summary:
-- Calculate the percentage growth in sales from Q3 to Q4 of 2021 for each territory.

-- solution A
WITH sum_sales AS (
SELECT 
    EXTRACT(QUARTER FROM order_date) AS quarter,
    territory_id,
    SUM(order_value) AS sales
FROM fct_customer_sales s
INNER JOIN map_customer_territory t USING(cust_id)
WHERE EXTRACT(YEAR FROM order_date) = 2021
    AND EXTRACT(QUARTER FROM order_date) IN (3,4)
GROUP BY territory_id, EXTRACT(QUARTER FROM order_date)
ORDER BY quarter),
combined_quarter AS (
SELECT 
    territory_id,
    CASE WHEN quarter = 3  THEN sales END AS q3_sales,
    CASE WHEN quarter = 4  THEN sales END AS q4_sales
FROM sum_sales)
SELECT 
    a.territory_id,
    MAX(((b.q4_sales - a.q3_sales) / a.q3_sales * 100.0)) AS growth
FROM combined_quarter a
INNER JOIN combined_quarter b USING(territory_id)
WHERE a.q3_sales > 0 AND b.q4_sales > 0
GROUP BY 1
ORDER BY 1

-- solution B

WITH total_sales AS (
    SELECT
        s.order_date,
        t.territory_id,
        SUM(s.order_value) AS sales
FROM fct_customer_sales AS s
INNER JOIN map_customer_territory AS t ON s.cust_id = t.cust_id
WHERE s.order_date BETWEEN '2021-07-01' AND '2021-12-31'
GROUP BY t.territory_id, s.order_date
ORDER BY s.order_date
),

sum_sales AS (
SELECT
    territory_id,
    SUM(CASE WHEN order_date BETWEEN DATE '2021-07-01' AND '2021-09-30' THEN sales ELSE 0 END) AS q3,
    SUM(CASE WHEN order_date BETWEEN DATE '2021-10-01' AND '2021-12-31' THEN sales ELSE 0 END) AS q4
FROM total_sales
GROUP BY territory_id
)

SELECT
territory_id,
((q4 - q3) / q3) * 100.0 AS sales_growth
FROM sum_sales
WHERE q3 > 0 AND q4 > 0

-- Output shape: one row per territory with sales growth percentage
-- Row unit in final result: territory_id
-- fct_customer_sales contains sales facts at customer/order level
-- map_customer_territory maps each customer to a territory
-- Join is required because territory_id is not in the sales table
-- Conditional aggregation is used to calculate Q3 and Q4 sales in one grouped result
-- Growth formula: ((Q4 - Q3) / Q3) * 100
-- Filter territories where both Q3 and Q4 sales are greater than 0