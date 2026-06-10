-- Platform : StataScratch
-- Problem : Bike Last Used(DoorDash)

-- Output : bike_number, end_time
-- Entity/Who?: bike
-- Metric : Last time each bike was in use
-- filter : none

-- Level 0: Output(bike_number, end_time)
-- grain : one row per bike
-- columns : end_time, bike_number
-- Operation : GROUP BY bike_number and find MAX(end_date); Order by recent_dates

-- Raw table : 
-- grain : one row per bike usage details

-- Build the data
SELECT 
    bike_number, 
    MAX(end_time) AS recent_date
FROM dc_bikeshare_q1_2012
GROUP BY 1
ORDER BY recent_date
