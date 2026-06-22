-- Platform: StrataScratch
-- Problem: Number of Units per Nationality
-- Summary: Calculate the number of apartment units owned by hosts of different nationalities who are under 30 years old, and output

-- Output : one row per nationality showing the nationality and the count of apartment units owned, ordered by the count of apartment units in descending order
-- Entity/Who: nationality (hosts)     
-- Metric: COUNT(DISTINCT unit_id) per  nationality
-- Hidden : filter units to only include 'Apartment' and hosts under 30 years old
-- filters : unit_type = 'Apartment'; age < 30      


-- LEVEL 0: Output
--    grain:     one row per nationality
--    columns:   nationality, apartment_count
--    operation: PROJECT; ORDER BY apartment_count DESC

-- LEVEL 1: Collapse to apartment count per nationality
--    grain:     one row per nationality
--    columns:   nationality, apartment_count
--    operation: COLLAPSE — GROUP BY nationality; COUNT(DISTINCT unit_id)

-- LEVEL 2: Enrich hosts with their units, apply filters
--    grain:     one row per (host_id, unit_id)
--    columns:   unit_id, nationality, age, unit_type
--    operation: ENRICH — INNER JOIN airbnb_hosts → airbnb_units ON host_id
--               ISOLATE WHERE unit_type = 'Apartment' AND age < 30

-- RAW:
--    airbnb_hosts: one row per host record (host_id, age, gender, nationality)
--    airbnb_units: one row per unit (unit_id, host_id, unit_type)

-- Build the data 
WITH valid_units AS (SELECT
    u.unit_id, u.unit_type, h.nationality, h.age

FROM airbnb_hosts h
INNER JOIN airbnb_units u
ON h.host_id = u.host_id
WHERE u.unit_type = 'Apartment'
AND h.age < 30)

-- Level 1: Need to compute the apartments per nationality and unit_id
SELECT
    nationality,
    COUNT(DISTINCT unit_id) AS apartment_count
FROM valid_units
GROUP BY 1
ORDER BY apartment_count DESC