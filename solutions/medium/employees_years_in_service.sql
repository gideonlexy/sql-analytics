-- Platform: StrataScratch
-- Problem: Employees Years in Service (Uber)
-- SQL Dialect: PostgreSQL
-- Concepts: date arithmetic, conditional logic, filtering  

-- Summary:
-- Find employees who have been in service for more than 2 years, calculate their years of service and 
-- determine if they are currently active or not

SELECT 
  first_name, last_name,
  CASE WHEN termination_date IS NOT NULL THEN 'No' ELSE 'Yes' END AS status,
  (COALESCE(termination_date, '2021-05-01'::DATE) - hire_date)* 1.0  / 365 AS years_service

FROM uber_employees 
WHERE  (COALESCE(termination_date,'2021-05-01'::DATE) - hire_date)  > 730 

-- Output shape:One row per employee with:
-- - name
-- - active status (Yes/No)
-- - years of service

-- Row unit: employee

-- Pattern:
-- Filter employees to include those who have been in service more than 2 years
-- Use COALESCE to handle those who have been terminated and active employees:
-- Compute tenure in days:
-- (effective_end_date - hire_date)
-- Derive status:
-- - termination_date IS NOT NULL  'No' (not active)
-- - termination_date IS NULL  'Yes' (active)
-- Convert tenure from days to years:
-- divide by 365 and cast to numeric for decimal precision
