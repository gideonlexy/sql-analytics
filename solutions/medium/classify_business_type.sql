-- Platform: StartaScratch
-- Problem: Classify Business Type (City of San Francisco)
-- SQL Dialect: PostgreSQL
-- Concepts: conditonal filtering, string pattern matching

-- Summary:
-- Retrieve the card name and issued amount during it's first month launch

SELECT DISTINCT
    business_name,
    CASE
        WHEN business_name ILIKE any(array['%restaurant%', '%restaurante%', '%restauranté%']) THEN 'restaurant' 
        WHEN business_name ILIKE any(array['%cafe%', '%café%', '%coffee%']) THEN 'cafe' 
        WHEN business_name ILIKE '%school%' THEN 'school' 
        ELSE 'other'
    END AS classification

FROM sf_restaurant_health_violations;

-- NOTES
-- Output shape: One row per business showing its classified business type.
-- Row unit:business_name
-- Use DISTINCT to avoid duplicate business names.
-- Classify each business using pattern matching on business_name.
-- Use ILIKE for case-insensitive matching.

