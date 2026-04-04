
-- Platform: StartaScratch
-- Problem: Signups by Billing Cycle (Asana)
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, conditional aggregation, date functions, JOINs

-- Summary:
-- Calculate the number of signups for each billing cycle (monthly, quarterly, annual) for each day of the week.

WITH signups AS (
SELECT
    EXTRACT(DOW FROM s.signup_start_date) AS day_signup,
    p.billing_cycle,
    COUNT(s.signup_id) AS signups_count

FROM signups s
INNER JOIN plans p 
ON s.plan_id = p.id
GROUP BY 1, 2)
SELECT
    day_signup,
    SUM(CASE WHEN billing_cycle = 'monthly' THEN signups_count ELSE 0 END) AS monthly,
    SUM(CASE WHEN billing_cycle = 'quarterly' THEN signups_count ELSE 0 END) AS quarterly,
    SUM(CASE WHEN billing_cycle = 'annual' THEN signups_count ELSE 0 END) AS annual
    
FROM signups
GROUP BY 1
ORDER BY 1

-- Output shape: One row per day of week with signup counts split by billing_cycle.

-- Row unit: day_signup (0–6)
-- Pattern
-- Join signups with plans to get billing_cycle for each signup.
-- Extract day of week from signup_start_date.
-- Aggregate to (day_signup, billing_cycle):
-- count number of signups per combination.
-- Pivot billing_cycle into columns using conditional aggregation:
-- SUM(CASE).
-- Group by day_signup to get one row per day.
-- Order results by day of week.
