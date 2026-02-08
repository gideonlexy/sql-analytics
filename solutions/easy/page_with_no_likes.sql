-- Platform: DataLemur
-- Problem: Pages With No Likes
-- SQL Dialect: PostgreSQL
-- Concepts: anti-join, NOT EXISTS,  subquery

-- Summary:
-- Identify pages that do not have any corresponding records
-- in the page_like table.

SELECT
    p.page_id
FROM pages p
WHERE NOT EXISTS (
    SELECT page_id
    FROM page_likes pl
    WHERE pl.page_id = p.page_id
)
ORDER BY p.page_id;

-- Notes:
-- 1. The query is driven from the pages(Outer table) table since all returned rows
--    must represent existing pages.
-- 2. NOT EXISTS implements an anti-join by excluding any page for which
--    at least one matching row exists in page_like.
-- 3. The subquery checks existence only
-- 4. This approach is NULL-safe compared to
--    LEFT JOIN + IS NULL patterns.