
-- Platform: StarataScratch
-- Problem: Revew Bins on Review Number (Airbnb)
-- SQL Dialect: PostgreSQL
-- Concepts: conditonal filtering, string pattern matching

-- Summary:
-- Classify properties into review bins based on the number of reviews they have received.
SELECT 
    price,
    CASE
        WHEN number_of_reviews = 0 THEN 'NO'
        WHEN number_of_reviews BETWEEN 1 AND 5 THEN 'FEW'
        WHEN number_of_reviews BETWEEN 6 AND 15 THEN 'SOME'
        WHEN number_of_reviews BETWEEN 16 AND 40 THEN 'MANY'
        ELSE 'A LOT'
    END AS category

FROM airbnb_search_details;

-- NOTES
-- Output shape: rows of properties showing price and review count category label
-- Row unit: property
-- Pattern: Conditional logical case statement