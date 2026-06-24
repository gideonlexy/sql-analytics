-- Platform: StrataScratch
-- Problem: Apple Products Count
-- Summary: Calculate the number of users per language who are using apple products, and output the language, total number of users, and the number of apple product users per language ordered by the number of apple product users in descending order.

-- NOTES:
-- Output : one row per language, total_no_apple_users, apple_users_per_language
-- Entity : language
-- Metric : COUNT(DISTINCT users) using apple devices IN('macbook pro', 'iphone 5s','ipad air')
--          compare to users per language; GROUPBY language; COUNT(users)
-- Hidden : event > = 1
-- filter : IN('macbook pro', 'iphone 5s','ipad air')

-- Level 0: Output(language, total_users, users_per_language)
-- grain : one row per language
-- columns : language, total_users, users_per_language
-- operation : PROJECT; sort by users_per_language DESC

-- Level 1: Need to compute users_per_language
-- grain : one row per language
-- columns : language, user_id
-- operation : COLLAPSE rows; GROUp BY language and COUNT(user_id) AS users_per_language

-- Level 2a: Need to compute total_users
-- grain : one row per user
-- colums : user_id, device
-- operation : COLLAPSE rows; GROUP BY user_id; COUNT(DISTINCT user_id) AS total_users
-- filter : IN('macbook pro', 'iphone 5s','ipad air')

-- Level 2b: Need to Enrich tables events with the users
-- grain : one row per user per events
-- columns : user_id, event_name, device, language
-- operation : INNER JOIN events with users ON user.user_id = events.user_id

-- Raw tables:
-- events : one row per events (user_id, event_name, device)
-- users : one row per user (user_id, language)

-- Build data
-- Level 2b:
WITH user_events AS (
SELECT
    u.user_id AS user_id,
    e.event_name AS event,
    e.device AS device,
    u.language AS language
    

FROM playbook_events e
INNER JOIN playbook_users u
ON e.user_id = u.user_id)

-- Level 1: Need to compute users per language
SELECT
    language,
    COUNT(DISTINCT user_id) AS total_users ,
    COUNT(DISTINCT CASE WHEN device IN('macbook pro', 'iphone 5s', 'ipad air') THEN user_id ELSE NULL END) AS user_per_language
FROM user_events
GROUP BY language
ORDER BY user_per_language DESC

