-- Platform: StrataScratch
-- Problem: Lowest Revenue Generating Restaurants (Doordash)
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, GROUP BY, ranking, filtering, top N analysis

-- Summary:
-- Return the restaurant_id and revenue for the lowest 2% of restaurants by revenue in May 2020.

WITH sales_rank AS (
SELECT 
    restaurant_id,
    SUM(order_total) AS revenue,
    NTILE(50) OVER(ORDER BY  SUM(order_total) ASC ) AS ntile_rank

FROM doordash_delivery
WHERE DATE_TRUNC('month', customer_placed_order_datetime) = '2020-05-01'
GROUP BY 1)

SELECT 
    restaurant_id,
    revenue
FROM sales_rank
WHERE ntile_rank = 1
ORDER BY 1

-- Output shape: one row per restaurant_id with total May 2020 revenue.
-- Row unit: restuarant_id
-- Pattern:
-- Filter orders to May 2020.
-- aggragate to restuarant level
-- compute the revenue using SUM(order_total)
-- Rank restaurants into 50 equal buckets ordered by revenue ascending.
-- Since 100/50 = 2, bucket 1 represents the bottom 2% of restaurants by revenue.
-- Return only restaurants in bucket 1.