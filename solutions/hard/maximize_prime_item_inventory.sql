
-- Platform: DataLemur
-- Problem: Advertiser Status (Facebook))
-- SQL Dialect: PostgreSQL
-- Concepts: Joins, Conditional Logic, CASE Statements

-- Summary:
-- Calculate how many prime and non-prime items can fit in a 500,000 sqft warehouse, prioritizing prime items first.

WITH space AS (SELECT 
  item_type,
  SUM(square_footage) AS batch_sqft,
  COUNT(*) AS item_per_batch
FROM inventory
GROUP BY item_type),

ps AS (SELECT 
  FLOOR(500000.0 / batch_sqft)  AS prime_batch,
  item_per_batch,
  batch_sqft, item_type
FROM space 
WHERE item_type = 'prime_eligible'),

np AS (
SELECT
  item_per_batch,
  batch_sqft,
  item_type,
  FLOOR(
        (500000.0 - (
    (SELECT prime_batch FROM ps) * (SELECT  batch_sqft FROM ps )
    )) / batch_sqft) AS non_prime_batch
FROM space
WHERE item_type = 'not_prime' )

SELECT 
  item_type,
  item_per_batch * prime_batch AS item_count
FROM ps 

UNION ALL

SELECT 
  item_type,
  item_per_batch * non_prime_batch AS item_count
FROM np 

-- NOTES

-- Output shape: 2 rows — one for 'prime_eligible' and one for 'not_prime'
-- showing total item_count that can fit within 500,000 sqft.
-- Row unit: item_type.

-- Pattern:
-- 1 Aggregate inventory to compute batch_sqft (space per full batch)
--    and items_per_batch for each item_type.
--
-- 2) Compute how many full prime batches fit in 500,000 sqft:
--       prime_batches = floor(500000 / prime_batch_sqft)
--
-- 3) Calculate remaining space after placing prime batches:
--       remaining_sqft = 500000 - (prime_batches * prime_batch_sqft)
--
-- 4) Compute how many non-prime batches fit into remaining space:
--       non_prime_batches = floor(remaining_sqft / non_prime_batch_sqft)
--
-- 5) Convert batch counts to item_count:
--       item_count = batch_count * items_per_batch
--
-- Key constraint:
-- Prime batches are allocated first; non-prime only uses leftover space.
-- Partial batches are not allowed (hence FLOOR).
