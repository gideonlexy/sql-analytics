-- Platform: StrataScratch
-- Problem: Top Percentile Fraud (Netflix)
-- SQL Dialect: PostgreSQL
-- Concepts: percentiles, window functions, aggregation, filtering, joins

-- Summary:
-- Identify the most suspicious claims by finding those with a fraud_score in the top 5% 
-- (those at or above the 95th percentile of fraud scores) within their state. 
WITH fraud AS (
SELECT
    state,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY fraud_score) AS p_rank

FROM fraud_score
GROUP BY 1)

SELECT 
    policy_num, state, claim_cost, fraud_score
FROM fraud f
JOIN fraud_score fs USING(state)
WHERE fs.fraud_score >= f.p_rank

-- NOTES
-- Output shape: One row per claim whose fraud_score is at or above the 95th percentile within its state.
-- Row unit: policy_num
-- Pattern
-- Group by state and compute the 95th percentile fraud_score threshold
-- using PERCENTILE_CONT(0.95).
-- Join each claim back to its state's threshold.
-- Keep only claims where fraud_score >= state-specific 95th percentile threshold.

-- Key concept:
-- This is a percentile-threshold problem, not a rank-position problem.
-- We need the score cutoff per state, then compare each row to that cutoff.




