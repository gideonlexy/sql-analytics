-- Platform: StrataScratch
-- Problem: Minimum Number of Platforms (Train Station)
-- SQL Dialect: PostgreSQL
-- Concepts: window functions, cumulative sums, event counting

-- Summary:
-- Calculate the minimum number of platforms required at a train station to accommodate all train arrivals and departures scheduled for a day, 
-- given that each train occupies a platform from its arrival time until one minute after its departure time.


WITH events AS (
    SELECT
        arrival_time::time AS event_time,
        1 AS delta
    FROM train_arrivals

    UNION ALL

    SELECT
        (departure_time::time + INTERVAL '1 minute') AS event_time,
        -1 AS delta
    FROM train_departures
),
platform_usage AS (
    SELECT
        event_time,
        SUM(delta) OVER (
            ORDER BY event_time
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS trains_at_station
    FROM events
)
SELECT MAX(trains_at_station) AS min_platforms_needed
FROM platform_usage;

-- Output shape: One scalar value: minimum number of platforms required.

-- Row unit: single summary value

-- Step 1:
-- Represent arrivals and departures as events:
-- - arrival -> +1 (train enters)
-- - departure -> -1 (train leaves)

-- Step 2:
-- Adjust departure time by +1 minute to prevent overlap with arrivals at same time.

-- Step 3:
-- Combine both event streams using UNION ALL.

-- Step 4:
-- Order events by time and compute running total using:
-- SUM(delta) OVER (ORDER BY event_time)

-- Step 5:
-- Running total represents number of trains present at station at each moment.

-- Step 6:
-- Take MAX(trains_at_station) to get peak concurrency → required platforms.

