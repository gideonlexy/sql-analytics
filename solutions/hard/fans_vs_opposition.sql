-- Platform: StrataScratch
-- Problem: Fans vs Opposition (Meta)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, joins

-- Summary:
-- Pair employees with the most popular (highest popularity) with the least popular (lowest popularity) employees.

WITH opposing AS(
SELECT 
    employee_id,
    ROW_NUMBER() OVER(ORDER BY popularity DESC, employee_id ASC) AS position
FROM facebook_hack_survey f1),

popular AS(
SELECT 
    employee_id,
    ROW_NUMBER() OVER(ORDER BY popularity ASC, employee_id ASC) AS position
FROM facebook_hack_survey f2)

SELECT 
    o.employee_id,
    p.employee_id
FROM opposing o
INNER JOIN popular p
    ON o.position = p.position
    
-- NOTES
-- Output shape: one row per lover-hater pair, with employee ids only.
-- Step 1: Separate positive popularity employees from negative popularity employees.
-- Step 2: Rank lovers from highest popularity to lowest.
-- Step 3: Rank haters from lowest popularity to highest (most negative first).
-- Step 4: Break ties using employee_id ascending as required.
-- Step 5: Join the two ranked lists on rank to produce the pairs.