
-- Platform: StrataScratch
-- Problem: Revenue Over Time (Amazon)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, aggregation, GROUP BY, filtering

-- Summary:
-- Calculate the 3-month rolling average of monthly revenue for Amazon purchases.

WITH revenue_month AS (
SELECT
   
    DATE_TRUNC('month', created_at) AS month,
    SUM(purchase_amt) AS monthly_revenue
 
FROM amazon_purchases
WHERE purchase_amt > 0
GROUP BY  DATE_TRUNC('month', created_at)
ORDER BY month)

SELECT
    TO_CHAR(month, 'yyyy-mm') AS year_month,
    AVG(monthly_revenue) OVER(ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS agv
FROM revenue_month

-- NOTES
-- Output shape: 1 row per month with YYYY-MM and 3-month rolling average revenue.
-- Row unit (final): one row per month.
-- Pattern:
-- Filter out returns using purchase_amt > 0.
-- Aggregate monthly revenue with SUM(purchase_amt) by DATE_TRUNC('month', purchase_date).
-- Use a windowed AVG() ordered by month with ROWS BETWEEN 2 PRECEDING AND CURRENT ROW to compute the 3-month rolling average.
-- Format month with TO_CHAR(created_at, 'YYYY-MM') and sort chronologically.