-- Platform: StrataScratch
-- Problem: Rush Hour Calls (Redfin)
-- SQL Dialect: PostgreSQL
-- Concepts: aggregation, GROUP BY, date/time functions

-- Summary:
-- Return the number of total calls per request_id that had 3 or more calls between 3 PM and 6 PM.

WITH calls AS (
SELECT 
    request_id,
    COUNT(*) AS calls

FROM redfin_call_tracking
WHERE EXTRACT(HOUR FROM created_on) BETWEEN 15 AND 18
GROUP BY 1
HAVING COUNT(*) >= 3)
SELECT COUNT(*) FROM calls

-- NOTES

-- Output shape: One scalar value: number of request_ids with ≥ 3 calls in the specified time window.
-- Row unit:single summary value
-- Filter calls to time window (3 PM to 6 PM) using EXTRACT(HOUR).
-- Group by request_id to count number of calls per request.
-- Apply HAVING to keep only request_ids with at least 3 calls.
-- Count how many such request_ids exist.