
-- Platform: DataLemur
-- Problem: Advertiser Status (Facebook))
-- SQL Dialect: PostgreSQL
-- Concepts: Joins, Conditional Logic, CASE Statements

-- Summary:
-- Update advertiser status based on their payment activity and previous status. 


SELECT
  a.user_id,
  CASE
    WHEN d.user_id IS NULL THEN 'CHURN'
    WHEN a.status = 'CHURN' THEN 'RESURRECT'
    ELSE 'EXISTING'
  END AS new_status
FROM advertiser a
LEFT JOIN daily_pay d
  ON a.user_id = d.user_id
ORDER BY a.user_id;

-- NOTES
-- The result returns one row per advertiser with derived_column 'new_status'
-- Each row in advertisers represnts a single advertiser with their current status and each 
-- row in the daily_pay represent a payment activity.
-- LEFT JOIN + Conditional CASE logic is used: LEFT JOIN to connect advertisers with their payment status 
-- Conditional CASE statement is used to update the new  advertisers derived column  
