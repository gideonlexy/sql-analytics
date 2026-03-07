-- Platform: StrataScratch
-- Problem: Daily Revenue (Amazon)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, aggregation, generate_series, filtering, joins

-- Summary:
-- Calculate the daily net revenue for a specific product (PROD-2891) in the US between April 15, 2025, and April 28, 2025.

WITH valid_transactions AS (
SELECT 
    transaction_id, product_id, country, transaction_date, amount,
    status, original_transaction_id, type
FROM product_sales
WHERE product_id = 'PROD-2891'
    AND status = 'completed'
    AND country = 'US'
    AND type = 'purchase'
    AND transaction_date BETWEEN '2025-04-15' AND '2025-04-28'),

purchase_refunds AS (
SELECT
    p.transaction_id, p.transaction_date, 
    p.amount AS purchase_amount,
    COALESCE(SUM(r.amount),0) AS refund_amount
FROM valid_transactions p
LEFT JOIN product_sales r 
    ON p.transaction_id = r.original_transaction_id
    AND r.type = 'refund'
    AND r.status = 'completed'
GROUP BY p.transaction_id, p.transaction_date, p.amount),

daily_rev AS (
SELECT 
    transaction_date,
    SUM(purchase_amount + refund_amount) AS daily_net
FROM purchase_refunds
GROUP BY transaction_date),

calendar AS (
    SELECT generate_series(
        DATE '2025-04-15',
        DATE '2025-04-28',
        INTERVAL '1 DAY'
    )::date AS transaction_date
)
SELECT
    c.transaction_date,
    COALESCE(d.daily_net, 0) AS revenue
FROM calendar c
LEFT JOIN daily_rev d
    ON c.transaction_date = d.transaction_date

-- NOTES 
-- Output shape: 1 row per date from 2025-04-15 to 2025-04-28 with daily net revenue.
-- Row unit (final): one row per purchase date.
-- Pattern:
-- Filter valid completed purchases in the date range.
-- Left join refunds back to their original purchases using original_transaction_id.
-- Aggregate refunds at the purchase level so each purchase has one net amount.
-- Sum purchase net amounts by purchase date.
--Use a calendar series and left join to show zero for dates with no activity