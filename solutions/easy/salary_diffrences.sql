-- Platform: StrataScratch
-- Problem : Salaries Differences(LinkedIn)

-- Output: Scalar(absolute diff)
-- Entity/Who? : salaries
-- Metric : calculate the diff between highest salaries in marketing and engineering department
-- Max(engineering) - MaX(marketing)
-- Hidden : We need to join the tables to match each employee record with a department
-- filter : Deparment = marketing and Engineering

-- Level 0: Output(diff)
-- grain : diff value
-- columns : max_engineerng, max_marketing, diff
-- Operations : substract (max_engineerng - max_marketing) and keep the absolute values

-- Level 1: Need to compute max_engineering and max_marketing
-- grain : one row represents department_id
-- columns : department_id, department, salary
-- Operations : join table department to table employee to get the deparment name per each employee
-- Group by deparment and compute Max_salary per each department
-- filter : IN(Engineering, Marketing)

WITH employees AS(
SELECT 
    e.department_id AS department_id,
    d.department AS department,
    MAX(e.salary) AS max_salary

FROM db_employee e
INNER JOIN db_dept d
ON e.department_id = d.id
WHERE d.department IN('engineering','marketing')
GROUP BY 1 ,2),
department_max AS (SELECT 
    MAX(CASE WHEN department = 'marketing' THEN max_salary END) AS max_marketing,
    MAX(CASE WHEN department = 'engineering' THEN max_salary END) AS max_engineering
FROM employees)
SELECT
    ABS(max_marketing - max_engineering) AS max_diff
FROM department_max
