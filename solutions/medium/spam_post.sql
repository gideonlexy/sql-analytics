-- Platform : StrataScratch
-- Problem : Spam Post Percentage
-- Summary : Calculate the percentage of posts that are spam per day, and output the post_date and percentage of spam posts per day ordered by post_date in ascending order.    

-- Output : Scalar- one row per day showing percentage of spam posts
-- Who/Entity : day
-- Metric : COUNT(spam) / COUNT(*) * 100
-- Filter : LIKE '%SPAM%'

-- Level 0: Output(day, percentage)
-- grain : one row per day
-- columns : day, percentage
-- operation : Project; 

-- Level 1: Need to compute the percentages
-- grain : one row per post_date
-- columns : post_id, post_date, is_spam
-- operation : COLLAPSE ROWS, GROUP BY post_date COUNT(is_spam) / COUNT(*)

-- Level 2: Need to label Spam posts
-- grain : one row per post_id
-- colums : post_id, post_date,post_keyword 
-- operation : LABEL; CASE WHEN post_keyword ILIKE '%SPAM%' THEN 1

-- Level 2b: Need to enrich post_views with posts details
-- grain : one row per post_id per viewer_id
-- colums : post_id, post_date, post_keywords
-- operation : JOIN posts on post.post_id = post_views.post_id

-- Raw tables:
-- posts: one row per post details(post_id, post_date,post_keywords)
-- post_viewa : one row per post_id per viewer_id

-- Build the data up from the most immediate step
-- LEVEL 2B: 
WITH post_views AS (SELECT
    p.post_id AS post_id, p.post_date AS post_date, p.post_keywords AS keyword

FROM facebook_posts p
INNER JOIN facebook_post_views v
ON p.post_id = v.post_id),

-- LEVEL 2A: 
label_spam AS (SELECT
    post_id, post_date,
    CASE WHEN keyword ILIKE '%spam%' THEN 1 ELSE NULL END AS is_spam
FROM post_views),
-- LEVEL  1:
percentages AS (SELECT
    post_date,
    COUNT(is_spam) AS spam_count,
    COUNT(*) AS daily_posts,
    100.0 * COUNT(is_spam) / COUNT(*)  AS percentage

FROM label_spam
GROUP BY post_date)
-- Leve 0 : Output 
SELECT 
    post_date, percentage
FROM percentages
