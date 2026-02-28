
-- Platform: StrataScratch
-- Problem: Monthly Percentage Difference(Amazon)
-- SQL Dialect: PostgreSQL
-- Concepts: LAG(), window functions, date truncation, aggregation

-- Summary:
-- Calculate the month-over-month percentage change in revenue for each month.

WITH year_month_rev AS (
SELECT
    
    SUM(value) AS month_revenue,
    DATE_TRUNC('month', created_at) AS date
FROM sf_transactions
GROUP BY date 
),

rev_series AS (SELECT
    date,
    month_revenue,
    LAG(month_revenue) OVER(ORDER BY date) AS prev_rev
FROM year_month_rev)

SELECT 
    TO_CHAR(date, 'YYYY-MM') AS year_m,
    ROUND(100.0 * ((month_revenue - prev_rev) / prev_rev), 2) AS percent_change
FROM rev_series
ORDER BY year_m

-- NOTES
-- Outputshape: 1 row per month with 'yyyy-mm' and month-to-month revenue percentage change
-- Row unit : month % revenue change
-- Pattern: Aggregate daily transactions to monthly level using DATE_TRUNC('month', cretaed_at) + SUM (value)
-- Use LAG() to fetch the previous month revenue
-- Compute M-to-M reveune % change ROUND to .2 decimals
