-- Platform: DataLemur
-- Problem: Y-on-Year Growth Rate (Wayfair)
-- SQL Dialect: PostgreSQL
-- Concepts: Window functions, Common Table Expressions (CTEs), arithmetic operations

-- Summary:
-- compute the year-on-year growth rate of spend for each product. 

WITH c AS (SELECT 
  EXTRACT(YEAR FROM transaction_date) as year,
  product_id, spend AS curr_year_spend, 
  LAG(spend) OVER (PARTITION BY product_id 
    ORDER BY transaction_date ) AS prev_year_spend
FROM user_transactions)

SELECT *,
  ROUND(((curr_year_spend - prev_year_spend) / prev_year_spend) * 100.0,2) AS yoy_rate
FROM c 

-- NOTES
-- Output shape: 1 row per (product_id, year) with current_year_spend, previous_year_spend, and YoY %.
-- Row unit is product year
-- LAG() is used to retrieve previous year spend partitioned over product id and 
-- ordered by transaction date to ensure we obtain the accurate year records
-- calculate yoy_rate by subtracting prev_year_spend from curr_year_spend 
-- then divide by prev_year_spend and * by 100 to obtain the percantage 