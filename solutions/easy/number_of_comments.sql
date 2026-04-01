-- Platform: StrataScratch
-- Problem: Number of Comments (Meta)
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, GROUP BY, date filtering

-- Summary:
-- Calculate the total number of comments made by each user in the 30 days leading up to February 10, 2020.


SELECT 
    user_id,
    SUM(number_of_comments) AS comments
    
FROM fb_comments_count
WHERE created_at BETWEEN  '2020-02-10'::DATE -  INTERVAL '30 DAYs' AND  '2020-02-10'::DATE
GROUP BY 1
HAVING   SUM(number_of_comments) > 0

-- Output shape: One row per user_id with total number of comments in the last 30 days.
-- Row unit: user_id
-- Filter rows to a 30-day window ending on '2020-02-10'.
-- Aggregate comments per user using SUM(number_of_comments).
-- Group by user_id to get total comments per user.
-- Apply HAVING to keep only users with total comments > 0.

-- Key concept:
-- Use WHERE for time filtering (row-level), then GROUP BY + HAVING
-- to filter aggregated results (user-level activity).


