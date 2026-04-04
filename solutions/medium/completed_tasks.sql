-- Platform: StaraScratch
-- Problem: Completed Tasks (Asana)
-- SQL Dialect: PostgreSQL
-- Concepts: LEFT JOIN, aggregation, date filtering

-- Summary:
-- For users in the company 'ClassPass', calculate the total number of 'CompleteTask' actions they performed in January 2022.
--  Return one row per user_id with the total number of completed tasks.


SELECT
    u.user_id,
    COALESCE(SUM(a.num_actions), 0) AS no_of_actions

FROM asana_users u
LEFT JOIN asana_actions a
ON u.user_id = a.user_id
    AND DATE_TRUNC('month', a.date) = '2022-01-01'
    AND a.action_name = 'CompleteTask'
    
WHERE u.company = 'ClassPass'
GROUP BY 1

-- NOTES
-- Output shape: One row per user_id with total number of completed tasks in Jan 2022.

-- Row unit: user_id
-- Filter users to target company (ClassPass).
-- LEFT JOIN actions to keep all users, including those with no activity.
-- Apply join filters:
-- - restrict to January 2022 using DATE_TRUNC
-- - restrict to 'CompleteTask' actions
-- Aggregate actions per user using SUM(num_actions).
-- Use COALESCE to convert NULL (no actions) to 0.
