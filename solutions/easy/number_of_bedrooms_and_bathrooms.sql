-- Platform: StrataScratch
-- Problem: Number of Bedrooms and Bathrooms
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, GROUP BY


-- Summary:
-- Calculate the average number of bedrooms and bathrooms for each combination of 
-- city and property type in the airbnb_search_details table.

SELECT 
    city,property_type,
    AVG(bedrooms) AS avg_beds,
    AVG(bathrooms) AS avg_bath
FROM airbnb_search_details
GROUP BY city, property_type

-- NOTES
-- Outputshape: 1 row per(city,  property type) showing average bedrooms and bathrooms 
-- Row unit: 1 row represent (city, property) combination
-- Pattern: Use GROUP BY to aggregate listings at (city, property_type) level
-- AVG is used to compute means for bedrooms and bathrooms within each group