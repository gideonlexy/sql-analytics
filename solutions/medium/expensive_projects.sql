-- Platform : StrataScratch
-- Problem : Expensive Projects (Microsoft)
-- Summary : Find the most expensive project by employee, and output the project title and project budget rounded to the closest integer.

-- Output :  one row per project title and project budget rounded to the closest integer
-- WHO ?: employees
-- Metric : most  expensive project; 
-- filter : none

-- Level 0: Output(project_title, budget)
-- grain : one row per project
-- columns : title, budget
-- Operation : PROJECT; ORDER BY highest budget per employee

-- Level 1: Enrich the projeccts with the emp_id
-- grain : one row per project(enriched with emp_id)
-- columns : title, budget, emp_id
-- Operation : JOIN projecct with emp_projects ON project.id = emp_project.project_id

-- Raw tables:
-- ms_projects : one row per project details(id title, budget)
-- ms_emp_projects : one row per (emp_id, project_id)

-- Build the data 
-- Level 1:  Enrich the projects with the emp_id
WITH emp_projects AS (
SELECT
    p.id, p.title, p.budget, ep.emp_id

FROM ms_projects p
INNER JOIN ms_emp_projects ep
ON p.id = ep.project_id)
SELECT 
    title, 
    ROUND(budget * 1.0 / COUNT(emp_id),0) AS ratio
FROM emp_projects
GROUP BY title, budget
ORDER BY ratio DESC