
-- Platform: StrataScratch
-- Problem: Transactions by Billing Method and Signup (Noom)
-- SQL Dialect: PostgreSQL
-- Concepts: JOINs, window functions, aggregation   

-- Summary:
-- For users who signed up before May 2020, calculate the average transaction amount for each billing cycle.
-- Return one row per signup_id with the billing_cycle and the average transaction amount for that billing cycle.

WITH earlier_transactions AS (
SELECT 
    s.signup_id AS signup_id, s.plan_id AS plan_id, 
    t.transaction_start_date AS transaction_start_date , 
    t.amt AS amount

FROM signups s
INNER JOIN transactions t 
ON s.signup_id = t.signup_id
AND t.transaction_start_date < '2020-05-01')

SELECT
    e.signup_id,
    p.billing_cycle,
    AVG(e.amount) OVER(PARTITION BY  p.billing_cycle ) AS avg_amount
FROM earlier_transactions e
INNER JOIN plans p
ON e.plan_id = p.id
ORDER BY 2 DESC, 1 ASC

-- Output shape:
-- One row per signup_id with:
-- - billing_cycle
-- - average transaction amount (before May 2020)

-- Row unit: signup_id
-- Join signups with transactions and filter to transactions before May 2020.
-- Keep only relevant fields: signup_id, plan_id, transaction amount.
-- Join with plans to map each signup to its billing_cycle.
-- Compute average transaction amount per billing_cycle using:
-- AVG(amount) OVER (PARTITION BY billing_cycle)
-- Return signup-level rows with attached billing_cycle average.
-- Sort by billing_cycle (DESC) and signup_id (ASC) as required.

