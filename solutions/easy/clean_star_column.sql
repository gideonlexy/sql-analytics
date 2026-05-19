-- NOTES:

-- OUTPUT: Cleaned star column returned with other columns
-- Entity : star column
-- Metrics : Cast the star column and remove non integer values
-- filter : '^[0-9]+$'


SELECT
    business_name, cool, funny, review_date, review_id, review_text, useful, user_id,
    stars::INT

FROM yelp_reviews
WHERE stars ~ '^[0-9]+$'
  AND stars IS NOT NULL