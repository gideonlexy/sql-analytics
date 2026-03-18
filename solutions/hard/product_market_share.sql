
-- Platform: StrataScratch
-- Problem: Product Market Share (Amazon)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, aggregation, filtering, joins

-- Summary:
-- Calculate the daily net revenue for a specific product (PROD-2891) in the US between April 15, 2025, and April 28, 2025.

WITH filtered_sales AS (
SELECT
    territory_id, prod_brand,
    COUNT(order_id) AS orders
    
FROM fct_customer_sales s
INNER JOIN map_customer_territory c USING(cust_id)
INNER JOIN dim_product p USING(prod_sku_id)
WHERE EXTRACT(QUARTER FROM order_date ) = 4 AND
    EXTRACT(YEAR FROM order_date ) = 2021
GROUP BY territory_id, prod_brand    
)
    

SELECT 
    territory_id, prod_brand,
    100.0 * orders / SUM(orders) OVER(PARTITION BY territory_id ) AS market_share
FROM filtered_sales


-- Output shape:
-- One row per (territory_id, product_brand) showing that brand’s market share
-- of total orders within the same territory during Q4-2021.

-- Grain:
-- territory_id + prod_brand

-- Filter fact rows to Q4-2021 using a safe date range filter.

-- Join the sales fact table to:
-- territory mapping (to get territory_id)
-- product dimension (to get product brand)

-- Aggregate at (territory_id, prod_brand) level with 
-- COUNT(order_id) gives number of orders per brand per territory.
-- Compute market share using a window function.
-- SUM(orders) OVER (PARTITION BY territory_id) to get total orders
-- Divide brand orders by territory total and multiply by 100
-- to express market share as a percentage.

