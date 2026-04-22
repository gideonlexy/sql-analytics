-- Platform: StrataScratch
-- Problem : Host Popularity Rental Prices
-- Dialect: Postgres SQL


-- NOTES

-- Output : host_popularity_rating, min_price, avg_price, max_price
-- Who?(entity) : host_popuparity_rating
-- metrics: compute min, max and avg prices for property_popularity
-- hidden: the listings are duplicated

-- Level 0: Output
-- output grain: one row per host_popularity_rating
-- columns : host_popularity_rating, min_price, avg_price, max_price
-- operation : colapse rows grou by host_popularity_rating and compute the min, max and avg price
-- filter : Order by min_price

-- level 1: Need host_popularity_rating labeled per listing
-- grain : one row per id (unique_listing)
-- columns: id, number_of_reviews, host_popularity_rating(label), price
-- operation: CASE WHEN no_of_reviews_bucket 
-- filter: none

-- level 2: Need deduplicate listings
-- grain: one row per id (unique listing)
-- columns : id, number_of_reviews, price
-- operation: SELECT DISTINCT id, price, number_of_reviews
-- filter : none

-- raw grain: property listing details


WITH valid_listings AS (
SELECT DISTINCT
    id, price, number_of_reviews
FROM airbnb_host_searches),
hosting_rate_label AS (
SELECT
    id, price,number_of_reviews,
    CASE 
        WHEN number_of_reviews = 0 THEN 'New'
        WHEN number_of_reviews BETWEEN 1 AND 5 THEN 'Rising'
        WHEN number_of_reviews BETWEEN 6 AND 15 THEN 'Trending Up'
        WHEN number_of_reviews BETWEEN 16 AND 40 THEN 'Popular'
        ELSE 'Hot'
    END AS host_popularity_rating
    
FROM valid_listings)
SELECT
    host_popularity_rating,
    AVG(price) AS avg_price,
    MAX(price) AS max_price,
    MIN(price) AS min_price
FROM hosting_rate_label
GROUP BY 1
ORDER BY min_price
