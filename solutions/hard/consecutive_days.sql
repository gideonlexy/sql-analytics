-- Platform: StrataScratch
-- Problem: Consecutive Days (Netflix)
-- SQL Dialect: PostgreSQL
-- Concepts: gaps-and-islands, window functions, aggregation

-- Summary:
-- Identify users who have at least one streak of 3 or more consecutive active days in the sf_events table.

WITH distinct_days AS(
SELECT DISTINCT
    user_id, record_date::date as day
FROM sf_events
),

rnk_days AS (
SELECT 
    user_id,
    day,
    day - ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY day)::int AS streak_grp
FROM distinct_days
)

SELECT 
    user_id
FROM rnk_days
GROUP BY user_id, streak_grp
HAVING COUNT(*) >= 3

-- NOTES
-- Output shape: user_id values for users who have at least one streak
-- of 3 or more consecutive active days.
-- Row unit (final result): user.

-- Step 1: Normalize grain to one row per (user_id, day)
-- DISTINCT + record_date::date removes duplicate same-day events.

-- Step 2: Detect consecutive sequences using the gaps-and-islands method.
-- For each user, assign ROW_NUMBER() ordered by day.
-- Subtracting row_number from day (day - rn) creates a constant key
-- for consecutive days. When a gap occurs, the key changes.

-- Step 3: Group by (user_id, streak_grp) to form streaks.
-- COUNT(*) gives streak length.
-- HAVING COUNT(*) >= 3 keeps users with at least one 3-day streak.