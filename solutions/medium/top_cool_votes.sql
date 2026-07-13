-- Platform : StrataScratch
-- Problem : Top Cool Votes
-- Summary : Calculate the business with the highest number of cool votes, and output the business name and review text with the highest number of cool votes ordered by business name in ascending order.

-- Output : one row per business name with review text with the highest number of cool votes
-- Who/Entity : business
-- Metric : business by DENSE_RANK() OVER (ORDER BY cool_votes) and return the top with the highest votes
-- filter : none

-- Level 0: Output(business_name, review_text, cool)
-- grain : one row per business_name
-- columns : business_name, review_text, cool
-- operation : SELECT where rnk = 1

-- Level 1: Need to RANK the business per number of cool votes 
-- grain : one row per business_name
-- columns : business_name, review_text, cool, rnk
-- operation : DENSE_RANK() OVER (ORDER BY cool) AS rnk

WITH rnk_business AS (SELECT
    business_name, review_text, cool,
    DENSE_RANK() OVER(ORDER BY cool DESC) AS rnk
FROM yelp_reviews)

SELECT
    business_name, review_text
FROM rnk_business
WHERE rnk = 1