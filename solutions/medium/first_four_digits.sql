-- Platform : StrataScratch
-- Problem : return businesses whose phone numbers does not  start with 1415 (San Francisco Restaurant Health Violations)
-- SQL Dialect : PostgreSQL
-- Concepts : string manipulation, filtering, aggregation


-- Notes
-- output : scalar(number of businesses that does not start with 1415)
-- Entity : phone number
-- Metric : Find first 4 digits for all phone numbers and return the count of business that doesn't start with 1415
-- Operation : cast the phone number to string and check the left(s, 4) <> '1415'
-- filter : exclude null phone numbers
SELECT 
   COUNT(*) AS number_count

FROM sf_restaurant_health_violations
WHERE  business_phone_number IS NOT NULL 
    AND LEFT(business_phone_number::TEXT, 4) <> '1415'