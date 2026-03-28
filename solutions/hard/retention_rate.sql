
-- Platform: StrataScratch
-- Problem: Retention Rate (SALESFORCE)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, aggregation, GROUP BY, filtering

-- Summary:
-- Calculate the retention rate for each account from December 2020 to January 2021. 
--Return the ratio of January retention to December retention for each account.

WITH monthly_users AS(
SELECT DISTINCT
    account_id, user_id,
    DATE_TRUNC('month', record_date) AS month
FROM sf_events),
retention AS (SELECT
    account_id, user_id, month,
    MAX(month) OVER(PARTITION BY account_id, user_id) AS last_login,
    CASE
        WHEN MAX(month) OVER(PARTITION BY account_id, user_id) > month THEN
        1 ELSE 0 
    END AS retained
FROM monthly_users),
month_analysis AS (SELECT 
    account_id, month,
    COUNT(*) AS users_active,
    SUM(retained) AS retained_users
FROM retention
WHERE month IN ('2020-12-01', '2021-01-01')
GROUP BY 1,2),
pivot AS (SELECT 
    account_id,
    MAX(CASE WHEN month = '2020-12-01' THEN retained_users * 1.0 / users_active END) AS dec_retained,
    MAX(CASE WHEN month = '2021-01-01' THEN retained_users * 1.0 / users_active END) AS jan_retained
FROM month_analysis
GROUP BY 1)
SELECT 
    account_id,
    CASE WHEN dec_retained IS NULL OR dec_retained = 0 THEN 0
    ELSE COALESCE(jan_retained, 0) / dec_retained END  AS ratio
FROM pivot
-- Output shape: One row per account_id with retention_ratio (Jan 2021 retention / Dec 2020 retention)
-- Row unit: account_id
-- Step 1:
-- Deduplicate to (account_id, user_id, month) using DATE_TRUNC to represent monthly activity.
-- Step 2:
-- For each (account_id, user_id), compute latest active month using window function.
-- Step 3:
-- Mark user-month as retained if latest_month > current_month
-- (i.e., user has activity in any future month).

-- Step 4:
-- Aggregate to (account_id, month):
-- - active_users = COUNT(*)
-- - retained_users = SUM(retained_flag)

-- Step 5:
-- Compute retention rate per month:
-- retained_users / active_users

-- Step 6:
-- Pivot Dec 2020 and Jan 2021 retention into columns and compute ratio:
-- Jan_retention / Dec_retention (return 0 if Dec = 0)
    