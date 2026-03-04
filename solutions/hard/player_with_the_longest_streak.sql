-- Platform: StrataScratch
-- Problem: Player with the Longest Streak (Google)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, aggregation, GROUP BY, filtering

-- Summary:
-- Return the player(s) with the longest winning streak, where a winning streak is defined as consecutive wins between two losses.
WITH player_stats AS (SELECT *,
    ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY match_date) AS rnk_matches,
    SUM(CASE WHEN match_result ='L' THEN 1 ELSE 0 END) OVER(
        PARTITION BY player_id) AS total_loss,
    SUM(CASE WHEN match_result = 'L' THEN 1 ELSE 0 END) OVER(
        PARTITION BY player_id ORDER BY match_date) AS loss_cnt
FROM players_results),

wins_streak AS (
SELECT 
    player_id,loss_cnt,
    COUNT(*) AS win_count
FROM player_stats
WHERE match_result = 'W'
    AND loss_cnt >= 1
    AND loss_cnt <= total_loss -1
GROUP BY player_id, loss_cnt),

long_streak AS (SELECT 
    player_id,
    win_count,
    DENSE_RANK() OVER(ORDER BY win_count DESC) AS rnk
FROM wins_streak)

SELECT 
    player_id, win_count
FROM long_streak
WHERE rnk = 1
ORDER BY player_id

-- NOTES
-- Outputshape: a player(s) with the  longest streak of wins 
-- row unit: player(with longest streak)
-- Pattern: 
-- Order matches per player by date.
-- Compute a running loss counter using SUM(CASE WHEN match_result='L') OVER.
-- Losses act as boundaries that split matches into segments.
-- Filter only wins that occur between two losses (ignore wins before the first loss and after the last loss).
-- Group by player_id, loss_cnt to count consecutive wins in each segment.
-- Use DENSE_RANK() over win_count DESC to identify the longest streak.
-- Return players where rank = 1.

