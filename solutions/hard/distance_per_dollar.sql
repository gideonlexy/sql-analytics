-- Platform : StrataScratch
-- Problem : Distance Per Dollar (Uber)
-- Summary : Find the average absolute difference in distance-per-dollar on a rolling monthly basis, and output the results by year-month (YYYY-MM) format.

-- Output : one row per year_month(YYYY-MM) with the absolute ROUND(avg_diff, 2) in distance-per-dollar
-- Entity/Who?: ride
-- Metric : Absolute avg_diff on distance-per-dollar on rolling montly basis
--      distance_per_dollar = distance_to_travel / monetary_cost
-- Hidden 1 : Both success and failed requests are part of the metrics calculations
-- Hidden 2 : All dates are unique; No distinct selection
-- filter : none

-- Level 0: Output(YYYY-MM, avg_diff)
-- grain : one row per y-m
-- columns : y-m, avg_distance
-- operations : PROJECT; Final Select the required output; ROUND(ABS(avg_diff), 2)

-- Level 1: Need to compute absolute avg_diff
-- grain : one row per yyyy-mm
-- columns : yyyy-mm, daily_diff, avg_diff
-- operations : COLLAPSE - GROUP BY yyyy-mm, then compute AVG(daily_diff) AS avg_diff

-- Level 2: Need to compute daily_diff
-- grain : one row per date
-- columns : request_date, day_distance_per_dollar, month_distance_per_dollar, daily_diff
-- Operation : daily_diff = month_distance_per_dollar - day_distance_per_dollar

-- Level 3: Need to compute month_distance_per_dollar
-- grain : one row per year_month
-- columns : year_month, distance_to_travel, monetary_cost, month_distance_per_dollar
-- Operation : GROUP BY year_month, then compute SUM(distance_to_travel / monetary_cost) AS month_distance_per_dollar

-- Level 4: Need to compute day_distance_per_dollar
-- grain : one row per date
-- columns : request_date, distance_to_travel, monetary_cost, day_distance_per_dollar
-- Operations : day_distance_per_dollar = (distance_to_travel / monetary_cost)

-- Raw table:
-- grain : one row per ride details(id, request_date, distance_to_travel)

-- Build up the data
-- Level 4 : Need to compute day_distance_per_dollar
WITH day_distance_per_dollar AS (
SELECT 
    request_date, distance_to_travel, monetary_cost,
    (distance_to_travel / monetary_cost) AS day_distance_per_dollar,
    SUM(distance_to_travel)  OVER(PARTITION BY TO_CHAR(request_date, 'YYYY-MM')) /
    SUM(monetary_cost) OVER(PARTITION BY TO_CHAR(request_date, 'YYYY-MM')) AS month_distance_per_dollar
FROM uber_request_logs),
--Level 2: Need to compute the daily_diff
day_diff AS(SELECT
    request_date, day_distance_per_dollar, month_distance_per_dollar,
    (day_distance_per_dollar - Month_distance_per_dollar) AS day_diff
FROM day_distance_per_dollar)
-- Level 1 : Need to compute absolute avg_diff
SELECT 
    TO_CHAR(request_date, 'YYYY-MM') AS year_month,
    ROUND(AVG(ABS(day_diff))::numeric, 2) AS avg_diff
FROM day_diff
GROUP BY 1
ORDER BY 1
