-- Platform: DataLemur
-- Problem: Card Launch Success (JPMorgan)
-- SQL Dialect: PostgreSQL
-- Concepts: Window functions, Common Table Expressions (CTEs)

-- Summary:
-- Retrieve the card name and issued amount during it's first month launch

WITH gn AS (SELECT 
  card_name, issued_amount,
  ROW_NUMBER() OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) AS ranks
FROM monthly_cards_issued )

SELECT 
  card_name, issued_amount
FROM gn
WHERE ranks = 1
ORDER BY issued_amount DESC

-- NOTES
-- Output shape: one row per card_name showing issued_amount from the card's earliest (year, month) record.
-- Row unit: card_name (we select the first month record per card).

-- Step 1: Use ROW_NUMBER() to order each card’s records by (issue_year, issue_month) and mark the earliest row as rn = 1.
-- Step 2: Filter to rn = 1 to keep only the first-month issuance per card.
-- Step 3: Sort by issued_amount DESC to list cards by their first-month issuance.