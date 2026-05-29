-- NOTES
-- QUESTION FOR CLARRIFICATION: Do records have to be ordered in any manner using any column?

-- Output : one row per records on the first 50% of the records
-- Entity/Who?: dataset records
-- Metric : return the first 50% count(*) / 2 of the records
-- filter : none

-- Level 0: Output()
-- grain : one row per worker id
-- columns : worker_id, first_name, last_name, salary, joining_date, departement
-- operation :  FILTER to the first 50% count(*) / 2

-- Level 1 : Need a label to rank records
-- grain : one row per worker id
-- columns : worker_id, first_name, last_name, salary, joining_date, departement
-- operation :  ROW_NUMBER() OVER() to assign label

WITH records AS (SELECT *,
    ROW_NUMBER() OVER(order by 1) AS rnk

FROM worker)
SELECT 
    worker_id, first_name, last_name, salary, joining_date, department

FROM records
WHERE rnk <= (SELECT COUNT(*)/2 FROM worker)