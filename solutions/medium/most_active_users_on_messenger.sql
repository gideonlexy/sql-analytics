
-- Platform : StrataScratch
-- Problem : Most Active Users In Messenger (Meta)

-- Summary : 
-- Find the top 10 most active users on Meta/Facebook Messenger by counting their total number of messages sent and received

-- output : user_name, total_messages
-- who(entity): users
-- metric : find the top 10 most active users by their total sum of sent and receieved messages
-- hidden : messages count are stored  bi-directional  we need to unpivot and credit each user with message
--  count per row
-- filter: none

-- Level 0: Output
-- grain : one row per user_name
-- columns : user_name, total_messages
-- operation : DENSE_RANK users based on their total_message count
-- filter : retain the top 10 

-- Level 1: Need to compute for total_messages
-- grain : one row per user_name
-- columns : user_name, msg_count, total_messages
-- operation : Group by user_name
--          SUM(msg_count) As total_messages
-- filter : none

-- Level 2: Need to unpivot user1 and user2 into single user column
-- grain: multiple rows per user (one per conversation role appearance)
-- columns : user_name, msg_count
-- operation : UNION ALL
-- filter: none

WITH user_chats AS (SELECT 
    user1 AS user_name,
    msg_count
FROM fb_messages
UNION ALL
SELECT 
    user2 AS user_name,
    msg_count
FROM fb_messages),
total_messages AS (SELECT 
    user_name, 
    SUM(msg_count) AS total_messages

FROM user_chats
GROUP BY 1),
rnk_users AS (SELECT
    user_name, total_messages,
    DENSE_RANK() OVER(ORDER BY total_messages DESC) AS rnk_users
FROM total_messages)
SELECT 
    user_name, total_messages
FROM rnk_users
WHERE rnk_users <= 10

