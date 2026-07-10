-- Platform : StrataScratch
-- Problem : Income by Title and Gender
-- Summary : Calculate the average total compensation per employee title per gender, and output the employee title, gender, and average total compensation per employee title per gender ordered by employee title in ascending order.

-- Output : one row per employee title per gender showing the average total compensation
-- Who/Entity : employee title and gender
-- Metric : AVG(total_compensation) per employee title per gender
-- Hidden : Employee's without bonus doesn't count in the results; INNER JOIN
-- Hidden 2 : Employees can have more than 1 bonus; GROUP BY emp_id and SUM(bonus)
-- filter : none

-- Level 0: Output(employee_title, gender, avg_total_compensation)
-- grain : one row per emp_title per gender
-- colums : emp_title, gender, avg_total_compensation
-- operation : PROJECT

-- Level 1: Need to compute avg_total_compensation
-- grain : one row per emp_title per gender
-- colums : emp_title, gender, total_compensation
-- operation : COLLAPSE ROWS: GROUP BY emp_title, gender and compute AVG(total_compensation)

-- Level 2: Need to compute total_compensation
-- grain : one row per emp_id
-- columns : emp_id, emp_title, bonus, salary
-- operation : ENRICH employee's salary with bonus; INNER JOIN emp.id ON bonus.worker_ref_id

-- Raw tables:
-- employee : one row per emp (id, gender, salary)
-- bonus : one row per emp_id (worker_ref_id, bonus)

-- BUILD THE DATA UP
-- Level 2: Enrich employee with bonus
WITH emp_bonus AS (SELECT
    e.id AS emp_id, e.sex AS gender, e.employee_title AS emp_title, e.salary AS salary, b.bonus AS bonus
FROM sf_employee e
INNER JOIN sf_bonus b
ON e.id = b.worker_ref_id),

-- LEVEL 2B: compute total employee bonus
total_bonus AS (SELECT
    emp_id, gender, emp_title, salary,
    SUM(bonus) AS total_bonus
FROM emp_bonus
GROUP BY 1, 2, 3, 4),
-- LEVEL 2C: compute total compensation
total_compensation AS (SELECT
    emp_id, gender, emp_title,
    salary + total_bonus AS total_compensation
FROM total_bonus)
-- LEVEL 1: compute AVG total_compensation
SELECT
    emp_title, gender,
    AVG(total_compensation) AS avg_total_compensation
FROM total_compensation
GROUP BY 1, 2