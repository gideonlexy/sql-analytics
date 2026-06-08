-- Platform: StrataScratch
-- Problem : Marketing Campaign(StrataScratch)

-- Output : scalar(user_count)
-- Entity/ Who?: user
-- Metric : number of users who made additional purchases due to campaign success
--      : 
-- Hidden : Successful campaign is one day after the first purchase
-- filter    : INTERVAL '1 DAY'
-- Hidden : Products purchased != first_day purchases (product_id != first purchased product)
-- Operations : ROW_NUMBER() PARTITION BY user_id, ORDER BY created_at

-- Level 0: Output(user_count)
-- grain : one row per user_id
-- columns : user_id, rnk_purchase, product_id
-- operations : COUNT(user_id) AS user_count
--      : ROW_NUMBER() PARTITION BY USER_ID ORDER BY created_at
-- filter : created_at + INTERVAL '1 DAY'
--        : rnk_purchase > 1
--      : product_id != first_value(product_id)


WITH campaign AS (
SELECT 
    user_id, created_at, product_id,
    MIN(created_at) OVER(PARTITION BY user_id) AS first_purchase_date
FROM marketing_campaign),
products AS (
SELECT DISTINCT
    user_id,
    product_id,
    created_at
FROM campaign
WHERE created_at =  first_purchase_date),
count_users AS (SELECT 
    c.user_id
    
FROM campaign c
LEFT JOIN products p
ON c.user_id = p.user_id
AND c.product_id = p.product_id
WHERE c.created_at > c.first_purchase_date
AND p.product_id IS NULL
GROUP BY 1)

SELECT 
    COUNT(*) AS total_users
FROM count_users


