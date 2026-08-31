-- Platform : ScrtaScratch
-- Problem : First 3 Most Watched Videos
-- summary : Find the first 3 most watched videos by users

WITH watched AS (
SELECT 
    user_id, video_id,
    ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY watched_at ASC) AS rnk_watched

FROM videos_watched
),
total_watch AS (
SELECT
    video_id,
    COUNT(*) AS watch_count
FROM watched
WHERE rnk_watched <= 3
GROUP BY video_id
),

rank_watch AS (SELECT
    video_id, watch_count,
    DENSE_RANK() OVER(ORDER BY watch_count DESC) AS rnk
FROM total_watch)
SELECT 
    video_id, watch_count
FROM rank_watch
WHERE rnk <= 3
