-- Platform: ScrataScratch
-- Problem: Rows with Missing Values(Google)
-- SQL Dialect: PostgreSQL
-- Concepts: NULL handling, conditional aggregation

-- NOTES
-- OUTPUT : one row per user_flags that has a NULL in more than 1 column
-- Entity/Who: each row in user flag
-- Metric: Count of NULL columns per row
-- Hidden : "more than one" is strictly > 1
-- filter : None

-- LEVEL 0 — Output
--   grain:      one row per user_flags record with null_count > 1
--   columns:    flag_id, user_firstname, user_lastname, video_id
--   operation:  ISOLATE WHERE null_count > 1; PROJECT original columns (drop null_count)

-- LEVEL 1 — Label null count per row
--   grain:      one row per user_flags record
--   columns:    all columns + null_count (derived)
--   operation:  LABEL null_count = sum of CASE WHEN each column IS NULL THEN 1 ELSE 0 END

-- RAW
--   user_flags: one row per flag record (flag_id, user_firstname, user_lastname, video_id)

WITH missing_values AS(
SELECT *,
    (CASE WHEN user_lastname IS NULL THEN 1 ELSE 0 END +
    CASE WHEN video_id IS NULL THEN 1 ELSE 0 END +
    CASE WHEN flag_id IS NULL THEN 1 ELSE 0  END+ 
    CASE WHEN user_firstname IS NULL THEN 1 ELSE 0
    END )AS null_count

FROM user_flags )
SELECT 
    flag_id, user_firstname, user_lastname, video_id

FROM missing_values
WHERE null_count > 1

