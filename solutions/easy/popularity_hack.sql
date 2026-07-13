-- Platform : StrataScratch
-- Problem : Popularity Hack
-- Summary : Calculate the average popularity of employees per location, and output the location and average popularity of employees per location ordered by average popularity in descending order.

WITH emp_hacks AS (SELECT 
    e.id AS emp_id, e.location AS location, h.popularity AS popularity
FROM facebook_employees e
INNER JOIN facebook_hack_survey h
ON e.id = h.employee_id)

SELECT
    location,
    AVG(popularity) AS avg_pop
FROM emp_hacks
GROUP BY location
ORDER BY avg_pop DESC