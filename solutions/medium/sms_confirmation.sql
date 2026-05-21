-- Platform : StrataScratch
-- Problem : SMS Confirmation Rate (Meta/Facebook)
-- Summary :
-- Calculate the percentage of confirmed SMS (type = 'message') sent on August 4, 2020. 
-- SQL Dialect : PostgreSQL
-- Concepts : aggregation, conditional counting, joins


-- Output : percentage of confirmed SMS(type = 'message') that sent on august 2020
-- Entity : SMS(confirmed) == type = 'message'
-- Metrics : Calculate the % of the confirmed 2FA messages where type  = 'message' sent on August 2020
--   : count(conrfirmed) / count(*) sent on 4 august 2020
-- operation : filter the rows to only messages sent august 4 2020 and type = 'message'
--      : join the the table confirmed to count the number of confirmed SMS
--      : percentage = count(confirmed) / count(*)
-- filter : type = 'message' and ds = 08-04-2020


WITH valid_sms AS (SELECT 
    COUNT(*) AS total_sent,
    COUNT(CASE WHEN c.phone_number IS NOT NULL THEN 1 END) AS confirmed,
    
    (COUNT(CASE WHEN c.phone_number IS NOT NULL THEN 1 END) * 100.0  /  COUNT(*)) AS percentage

FROM fb_sms_sends s
LEFT JOIN fb_confirmers c
ON s.phone_number = c.phone_number
AND s.ds = c.date
WHERE s.type = 'message'
AND s.ds = '2020-08-04')

SELECT 
    percentage
FROM valid_sms


