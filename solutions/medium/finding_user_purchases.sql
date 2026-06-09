-- Platform : StataScratch
-- Problem : Finding User Purchases(Amazon)

-- Output : user_id
-- Entity/Who? : users
-- Metric : Returning active users - second time purchase within 1 - 7 days
-- Hidden : Same day re-purchase is ignored

-- Level 0: Output(user_id)
-- grain : one row per user_id
-- columns : user_id
-- Operation : Isolate users within 1 - 7 days second purchase period

-- Level 1: Need to label user orders
-- grain : one row per user_id
-- columns : user_id, created_at, id
-- operation : MIN(created_at) OVER(PARTIITOIN BY user_id )

-- raw table:
-- grain : one row represents transaction event

-- Build up ther data
WITH transactions AS (SELECT 
    id,user_id, created_at,
    MIN(created_at) OVER(PARTITION BY user_id) AS first_purchase_date
FROM amazon_transactions)
SELECT DISTINCT 
    user_id
FROM transactions
WHERE created_at > first_purchase_date 
AND created_at <= first_purchase_date + INTERVAL '7 DAYS'
