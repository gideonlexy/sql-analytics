
-- Platform: StrataScratch
-- Problem: First Day Retention (Game Company)
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, GROUP BY, window functions, date arithmetic

-- Summary:
-- Calculate the first-day retention rate for players. A player is considered retained if they log in exactly one day after their first login.
WITH players AS (
SELECT 
    player_id,
    login_date,
    MIN(login_date) OVER(PARTITION BY player_id ) AS first_login
FROM players_logins
),
retained AS (SELECT 
    player_id,
    CASE WHEN  login_date = first_login + INTERVAL '1 DAY' THEN player_id END AS retained
FROM players)
SELECT
    COUNT(DISTINCT retained) * 1.0 / COUNT(DISTINCT player_id)
FROM retained

-- Output shape: One scalar value: first-day retention rate.

-- Row unit: players (not events)

-- Step 1:
-- For each player, compute their first-ever login date using
-- MIN(login_date) OVER (PARTITION BY player_id).

-- Step 2:
-- For each login row, check if it occurs exactly 1 day after the player’s first login.

-- Step 3:
-- Mark such players as retained using a CASE expression.

-- Step 4:
-- Compute retention rate as:
-- (distinct retained players) / (distinct total players).

