-- Platform : ScrtaScratch
-- Problem : Find the total number of searches for each room type in each city

WITH search AS (SELECT 
    city,
    room_type,
    COUNT(id) AS searches

FROM airbnb_search_details
WHERE room_type IN ('Private room', 'Shared room','Entire home/apt')
GROUP BY 1,2)

SELECT
    city,
    MAX(CASE WHEN room_type = 'Private room' THEN searches ELSE 0 END) AS private,
    MAX(CASE WHEN room_type = 'Shared room' THEN searches ELSE 0 END) AS shared,
    MAX(CASE WHEN room_type = 'Entire home/apt' THEN searches ELSE 0 END) AS apart

FROM search
GROUP BY city