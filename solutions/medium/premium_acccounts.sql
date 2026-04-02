-- Platform: StrataScratch
-- Problem: Premium Accounts (Asana)
-- SQL Dialect: PostgreSQL
-- Concepts: self-joins, aggregation, date arithmetic

-- Summary:
-- For each entry_date, calculate:
-- 1. the total number of premium accounts that started on that date
-- 2. the number of those accounts that are still premium after

WITH prem_accounts AS (
SELECT 
    account_id, entry_date
FROM premium_accounts_by_day
WHERE final_price > 0)

SELECT 
    p.entry_date,
    COUNT(DISTINCT p.account_id) AS total_prem,
    COUNT(DISTINCT b.account_id) AS acc_7d
FROM prem_accounts p
LEFT JOIN prem_accounts b
ON p.account_id = b.account_id
AND b.entry_date = p.entry_date + INTERVAL '7 days'
GROUP BY p.entry_date
LIMIT 7

-- Output shape:
-- One row per entry_date with:
-- - total premium accounts on that date
-- - number of those accounts still premium after 7 days

-- Row unit: entry_date
-- Filter to premium accounts only (final_price > 0).
-- Self-join the table:
-- Join condition:
-- - same account_id
-- - b.entry_date = p.entry_date + 7 days

-- Aggregate per entry_date:
-- - total_prem - distinct accounts on that date
-- - acc_7d - distinct accounts that reappear after 7 days
-- LEFT JOIN ensures all initial accounts are counted,
-- even if they do not return after 7 days.
