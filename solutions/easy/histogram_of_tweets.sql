-- Platform: DataLemur
-- Problem: Histogram of Tweets
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, GROUP BY, CTE, date filtering

-- Summary:
-- Group users by the number of tweets they posted in 2022
-- and count how many users fall into each tweet-count bucket.

WITH tweet_totals AS (
    SELECT
        user_id,
        COUNT(tweet_id) AS tweet_bucket
    FROM tweets
    WHERE EXTRACT(YEAR FROM tweet_date) = 2022
    GROUP BY user_id
)
SELECT
    tweet_bucket,
    COUNT(user_id) AS user_num
FROM tweet_totals
GROUP BY tweet_bucket
ORDER BY tweet_bucket;


-- Notes:
-- 1. Aggregation is done in two steps to avoid double-counting users.
-- 2. Filtering by year happens before grouping for correctness.
