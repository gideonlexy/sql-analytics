-- Platform: StrataScratch
-- Problem: Total Users Percentage (Meta)

-- Summary
-- Find the popularity percentage for each user on Meta/Facebook.

WITH users AS (
SELECT 
    user1 AS user_id 
FROM facebook_friends
UNION ALL
SELECT 
    user2 AS user_id 
FROM facebook_friends),
friends AS (SELECT
    user_id,
    COUNT(*) AS user_count,
    COUNT(*) OVER() AS total_users 
FROM users
GROUP BY 1)
SELECT
    user_id,
    user_count * 100.0 / total_users AS perecentage

FROM friends
-- Notes:
-- Output : user_id, popularity-percentage
-- Who ?: user
-- Metric: count each users friends and calculate the friendship percentage
-- Hidden: every user appears in both user1 and user2
--          counting only one column undercounts friends

-- Raw: one directional-friendship (user1, user2)
-- Step 1: UNION ALL - logic grain (user_id)

-- STEP 2: COLLAPSE + LABEL
--  logic grain = (user_id, friend_count, total_users)
--  GROUP BY gives friend count
--  COUNT(*) OVER() gives total users

-- STEP 3: COLLAPSE -> logic grain = (user_id, percentage)
--  compute final ratio
-- END: one row = user_id, perecentage