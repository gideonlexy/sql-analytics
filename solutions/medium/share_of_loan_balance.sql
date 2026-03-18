-- Platform: StartaScratch
-- Problem: Share of Loan Balance (March 2019)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, aggregation

-- Summary:
-- Calculate the percentage share of each loan's balance within its rate type.

SELECT 
    loan_id, rate_type, balance,
    (100.0 * balance / SUM(balance) OVER(PARTITION BY rate_type)) AS share
FROM submissions
ORDER BY rate_type ASC, loan_id ASC

-- Output shape: one row per loan with rate_type, loan_id, balance,
-- and the loan's percentage share of total balance within the same rate_type.
-- Row Unit: one row per loan
-- Pattern:
-- Use window functions to  partiton rows by rate_type
-- Compute SUM(balance) across partition by rate_type
-- Divide the loan balance amount across the total sum of each partition
-- Multiply by 100 t0 get the percentage share of loan's contribution balance to total balance for that rate_type.