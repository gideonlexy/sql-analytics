
-- Platform: StarataScratch
-- Problem: User Growth Rate (Salesforce)
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, GROUP BY, conditional filtering

-- Summary:
-- Calculate the user growth rate for each account from December 2020 to January 2021.

WITH users AS(
SELECT 
    account_id, 
    COUNT(DISTINCT user_id) AS users,
    DATE_TRUNC('month', record_date) AS month
FROM sf_events
WHERE record_date >= '2020-12-01' AND record_date < '2021-02-01'
GROUP BY 1, 3),

month_user AS (
SELECT
    account_id,
    MAX(CASE WHEN month = '2020-12-01' THEN users END) AS dec,
    MAX(CASE WHEN month = '2021-01-01' THEN users END) AS jan
FROM users
GROUP BY account_id)
SELECT 
    account_id,
    jan::numeric / dec AS growth
FROM month_user
-- NOTES
-- Output shape : rows account_id and growth rate
-- Row unit: account_id
-- Pattern:
-- Filter rows to include only active users between dec 2020 and january 2021
-- aggregate the users to (account, month) level  and count distict users in each month
-- pivot users into  two columns dec and january using conditional aggregation
-- compute the growth rate: jan users / dec users 

