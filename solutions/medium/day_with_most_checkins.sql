-- Plattform: StrataScratch
-- Problem: Day with Most Check-ins
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, GROUP BY, subqueries

-- Summary:
-- Determine the day of the week with the highest number of check-ins from the  airbnb_contacts table. The day of the week is represented as an integer (1 for Monday, 7 for Sunday) using EXTRACT(ISODOW).


WITH check_in_guests AS (
SELECT 
    EXTRACT(ISODOW FROM ds_checkin) AS check_out_day,
    COUNT(id_guest) AS check_in_count
   

FROM airbnb_contacts
WHERE ds_checkin IS NOT NULL
GROUP BY 1)

SELECT
    *
FROM check_in_guests
WHERE check_in_count = (SELECT MAX(check_in_count) FROM check_in_guests )

-- NOTES
-- Output shape: One or more rows showing the day(s) of week with highest number of check-ins.

-- Row unit: check_out_day 
-- Pattern:
-- Filter to valid check-ins (ds_checkin IS NOT NULL).
-- Extract day of week using EXTRACT(ISODOW).
-- Aggregate to (day_of_week) level:
-- COUNT(id_guest) = total check-ins per day.
-- Identify the maximum check-in count across all days.
-- Return day(s) where check_in_count equals the maximum.
