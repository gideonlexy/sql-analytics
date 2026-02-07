-- Platform: DataLemur
-- Problem: Unfinished Parts Tesla 
-- SQL Dialect: PostgreSQL
-- Concepts: Logical Operator -> IS NULL, filtering, 

-- Summary:
-- Filter assembly parts without unfinished dates records

SELECT 
    part, 
    assembly_step
FROM parts_assembly
WHERE finish_date IS NULL;
