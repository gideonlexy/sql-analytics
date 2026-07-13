-- Platform : StrataScratch
-- Problem : Top 5 States with 5-Star Businesses
-- Summary : Calculate the top 5 states with the most 5-star businesses, and output the state and business count ordered by business count in descending order.

-- Output : top 5 states states showing the most 5-star businesses
-- Who/Entity : state
-- Metric : DENSE_RANK states with the count of 5-star business and return top 5
-- filter : stars = 5

-- LEVEL 0:Output(state, business_count)
-- grain : one row per state
-- columns : state, business_count
-- operation : PROJECT
-- filter : rnk <= 5

-- LEVEL 1: Need to rank the business by business_count
-- grain : one row per state
-- columns : state, business_count
-- operation : DENSE_RANK OVER(ORDER BY business_count DESC)

-- LEVEL 2: Need to compute the business_count
-- grain : one row per state
-- columns : business_id, state
-- operation : COLLAPSE ROWS; GROUP BY state; COUNT(business_id) AS business_count
-- filter : stars = 5

-- Build Up the data
WITH five_stars AS (SELECT
    business_id, state, stars
FROM yelp_business
WHERE stars = 5),
-- LEVEL 2
business_count AS (SELECT
    state,
    COUNT(business_id) AS business_count
FROM five_stars
GROUP BY state),
-- LEVEL 1:
rank_business AS (SELECT
    state, business_count,
    DENSE_RANK() OVER(ORDER BY business_count DESC) AS rnk
FROM business_count)
-- LEVEL 0: OUTPUT
SELECT
    state, business_count
FROM rank_business
WHERE rnk <= 5