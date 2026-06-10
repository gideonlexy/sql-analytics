-- Platform : StrataScratch
-- Problem : Distance Travelled (Lyft)
-- Summary : Find the top 10 users who travelled the greatest distance

-- Output : one row per user_id, name, total_distance 
-- Entity /Who? : users
-- Metric : Find the top 10 users who travelled the greatest distance
-- filter : users <= 10

-- Level 0: Output(id, name, total_distance)
-- grain : one per user
-- columns : user_id, name, distance
-- operation : ISOLATE where rnk <= 10; 

-- Level 1: Need to compute the total_distance
-- grain : one row per user
-- columns : id, name, distance
-- Operation : COLLAPSE - GROUP ROWS BY id and SUM(distance) AS total_distance per user
--          : Label:ROW_NUMBER users by total distance travelles

-- Level 2: Enrich rides with user name
-- grain : one row per user_id
-- columns : user_id, name, distance
-- Operation : JOIN rides to users ON rides.user_id = users.id

-- Raw tables:
-- rides : one row per (ride_id, user_id)
-- users : one row per user_id

-- Build the data
-- Level 2
WITH user_rides AS (SELECT 
    r.user_id, r.distance, u.name

FROM lyft_rides_log r
INNER JOIN lyft_users u
ON r.user_id = u.id),
-- Level 1
user_distance AS (SELECT
    user_id, name,
    SUM(distance) AS total_distance
FROM user_rides
GROUP BY 1, 2),
-- ROW_NUMBER() user by total distance travelled
rnk_users AS (SELECT
    user_id, name, total_distance,
    ROW_NUMBER() OVER(ORDER BY total_distance DESC) AS rnk
FROM user_distance)
-- Level 0:
SELECT
    user_id, name, total_distance

FROM rnk_users
WHERE rnk <= 10