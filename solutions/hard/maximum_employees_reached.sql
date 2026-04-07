-- Platform: StrataScratch
-- Problem: Maximum Employees Reached (Uber)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, cumulative sums, date handling

-- Summary:
-- For each employee, determine the greatest number of employees that were working at Uber 
-- during their tenure and the first date that headcount was reached.

WITH employee_events AS (
    SELECT
        hire_date AS event_date,
        1 AS change
    FROM uber_employees
    WHERE hire_date IS NOT NULL

    UNION ALL

    SELECT
        termination_date AS event_date,
        -1 AS change
    FROM uber_employees
    WHERE termination_date IS NOT NULL
),
daily_changes AS (
    SELECT
        event_date,
        SUM(change) AS net_change
    FROM employee_events
    GROUP BY event_date
),
company_headcount AS (
    SELECT
        event_date,
        SUM(net_change) OVER (
            ORDER BY event_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS employee_count
    FROM daily_changes
),
employee_dates AS (
    SELECT
        u.id,
        c.event_date,
        c.employee_count
    FROM uber_employees u
    JOIN company_headcount c
      ON c.event_date >= u.hire_date
     AND c.event_date < COALESCE(u.termination_date, CURRENT_DATE)
),
ranked_dates AS (
    SELECT
        id,
        event_date,
        employee_count,
        ROW_NUMBER() OVER (
            PARTITION BY id
            ORDER BY employee_count DESC, event_date ASC
        ) AS rn
    FROM employee_dates
)
SELECT
    id,
    employee_count AS greatest_number_of_employees,
    event_date AS first_date_reached
FROM ranked_dates
WHERE rn = 1
ORDER BY id;

--NOTES:

-- Output shape: One row per employee with:
-- - greatest company headcount observed during that employee’s tenure
-- - first date that headcount was reached

-- Row unit: employee id

-- Step 1:
-- Convert hires and terminations into event rows:
-- - hire_date -> +1
-- - termination_date -> -1

-- Step 2:
-- Combine all events using UNION ALL and aggregate by event_date
-- to get net headcount change per day.

-- Step 3:
-- Compute running headcount over time using cumulative SUM(net_change)
-- ordered by event_date.

-- Step 4:
-- For each employee, join to all company dates that fall within their tenure:
-- event_date >= hire_date
-- event_date < termination_date (or current_date if still active)

-- Step 5:
-- For each employee, rank tenure dates by:
-- - highest employee_count first
-- - earliest event_date first

-- Step 6:
-- Keep rn = 1 to return the maximum headcount during that employee’s tenure
-- and the first date it occurred.
