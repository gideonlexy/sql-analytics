-- Platform: StrataScratch
-- Problem: New vs Existing Users (Microsoft)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, aggregation

-- Summary:
-- For each month, calculate the share of new users and existing users among all active users.
-- A new user is defined as a user whose first active month is the current month.


WITH monthly_users AS (
SELECT DISTINCT 
    user_id,
    DATE_TRUNC('month', time_id) AS month
FROM fact_events
ORDER BY user_id, month),

classified AS (
SELECT 
    user_id,
    month,
    MIN(month) OVER(PARTITION BY user_id ) AS first_month
FROM monthly_users
ORDER BY user_id, month),
flagged AS (
SELECT
    user_id,
    month,
    CASE WHEN month = first_month THEN 1 ELSE 0 END AS new_user,
    CASE WHEN month > first_month THEN 1 ELSE 0 END AS existing_user
FROM classified
ORDER BY user_id, month),
monthly_counts AS (
SELECT
    month,
    SUM(new_user) AS new_users,
    SUM(existing_user) AS existing_users
FROM flagged
GROUP BY 1)
SELECT 
    EXTRACT(MONTH FROM MONTH) AS month,
    new_users * 1.0 / (new_users + existing_users) AS new_user_share,
    existing_users * 1.0 / (new_users + existing_users) AS existing_user_share
FROM monthly_counts
ORDER BY month


-- Output shape:
-- One row per month with share of new users and share of existing users.
-- Final grain: month
-- Logic grain: (user_id, month)

-- Pattern:
-- Step 1:
-- Deduplicate activity to one row per user per month.

-- Step 2:
-- Compute each user’s first active month using MIN(month) OVER (PARTITION BY user_id).

-- Step 3:
-- Classify each user-month:
-- - new_user if month = first_month
-- - existing_user if month > first_month

-- Step 4:
-- Aggregate to month level and count new vs existing users.

-- Step 5:
-- Divide each count by total active users in the month to get shares.

