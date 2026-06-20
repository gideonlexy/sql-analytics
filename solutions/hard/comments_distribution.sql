-- Platform: StrataScratch
-- Problem: Comments Distribution
-- Summary: Calculate the distribution of comments per user for users who joined between 2018 and 2020, and made comments between '01/01/2020' and '01/

-- NOTES:
-- Output : one row per number_of_comments per user_counts sorted by number_of_comments ascending
-- Entity/Who? : user(comments)
-- Metric: calculate the total_number of users per their number_of_comments made
-- Hidden : remove posts where created before user's joined date
-- filter : joined_at between 2018 and 2020; created_at between '01/01/2020' and '01/31/2020'

-- Level 0: Output(number_of_comments, user_count)
-- grain : one row represents number_of_comments
-- columns : number_of_columns, user_count
-- operation : PROJECT; sort by number_of_comments ASC

-- Level 1: Need to label user_count per their comments count
-- grain : one row per user_id
-- columns : user_id, number_of_comments, user_count
-- operation : COLLAPSE rows  by number_of_comments; GROUP BY number_of_comments; COUNT(user_id)
-- as user_count

-- Level 2: Need to compute the number_of_comments per user
-- grain : one row per user_id
-- columns : user_id, body, number_of_comments
-- operations : ENRICH user's with their comments: INNER JOIN user's ON users.id = comments.user_id
--          :GROUP BY user_id; COUNT(body) AS number_of_comments
-- filter :joined_at between 2018 and 2020; created_at between '01/01/2020' and '01/31/2020'

-- Raw tables:
-- users : one row per  user_id
-- comments : one row user_id

-- Leve 2A: Enrich users with comments
WITH user_comments AS (SELECT 
    u.id AS id, c.body AS body, c.created_at, u.joined_at

FROM fb_users u
INNER JOIN fb_comments c
ON u.id = c.user_id
AND c.created_at BETWEEN '2020-01-01' AND '2020-01-31'
AND c.created_at >=u.joined_at
WHERE u.joined_at BETWEEN '2018-01-01' AND '2020-12-31'),
-- Level 2B: Compute the number_of_comments per user
number_of_commets AS (SELECT
    id,
    COUNT(body) AS number_of_comments
FROM user_comments
GROUP BY 1)

-- Level 1: Need to label users per number_of_comments
SELECT
    number_of_comments,
    COUNT(id) AS user_count

FROM number_of_commets
GROUP BY 1
ORDER BY number_of_comments ASC