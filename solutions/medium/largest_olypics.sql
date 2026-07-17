-- Platform : StrataScratch
-- Problem : Largest Olympics
-- Summary : Calculate the olympics with the largest number of unique athletes, and output the olympics and number of unique athletes ordered by number of unique athletes in descending order.

-- Output : one row per olympics with number of unique athletes
-- WHO/Entity : olympics
-- Metrics : COUNT(DISTINCT id); SELECT MAX(num_athletes)
-- Hidden : Must apply distinct to get the unique count of athletes
-- filter : none

-- Level 0: Output(olympic, num_athletes)
-- grain : one row per olympic 
-- columns : olympic, num_athletes
-- operation : PROJECT; SELECT where num_athletes=MAX

-- Level 1: Need to compute the num_athletes
-- grain : one row per id
-- columns : id, games
-- operation : COLLAPSE ROWS; GROUP BY games;COUNT(DISTINCT id) AS num_athletes

-- RAW TABLE:
-- olympic_athletes_events : one row per athlete

-- Build Up the data
-- LEVEL 1

WITH olympic_athletes AS (SELECT
     games AS olympic,
     COUNT(DISTINCT id) AS num_atheletes

FROM olympics_athletes_events
GROUP BY games)

-- LEVEL 0
SELECT 
    olympic,
    num_atheletes
FROM olympic_athletes
WHERE num_atheletes = (SELECT MAX(num_atheletes) FROM olympic_athletes)