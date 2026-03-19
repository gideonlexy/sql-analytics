
-- Platform: StrataScratch
-- Problem:Brand Segmentation (WFM)
-- SQL Dialect: PostgreSQL
-- Concepts:  aggregation, GROUP BY, conditional filtering, JOINs

-- Summary:
-- Segment customers into High, Medium, Low based on their average basket size (total sales / number of transactions) for each brand.
WITH transactions AS(
SELECT 
    
    t.customer_id AS customer,
    s.store_brand AS brand,
    SUM(t.sales) AS total_sales,
    COUNT(DISTINCT t.transaction_id) AS transactions_count,
    SUM(t.sales)  / COUNT(DISTINCT t.transaction_id) AS basket_size
FROM wfm_transactions t
INNER JOIN wfm_stores s USING(store_id)
WHERE EXTRACT(YEAR FROM transaction_date) = 2017
GROUP BY 2, 1),

segment_rows AS (
SELECT 
    customer, brand, total_sales, transactions_count, basket_size,
    CASE 
        WHEN  basket_size > 30 THEN 'High'
        WHEN  basket_size BETWEEN 20 AND  30 THEN 'Medium'
        ELSE  'Low'
    END AS segment
FROM transactions)
SELECT
    brand, segment,
    COUNT(DISTINCT customer) AS customers,
    SUM(transactions_count) AS total_transactions,
    SUM(total_sales) AS sales,
    SUM(total_sales) /  SUM(transactions_count) AS avg_basket_size
FROM segment_rows
GROUP BY brand, segment



-- output shape: list or rows shwowing brand, segment, number of customers, 
-- total transactions, total sales, avg basket_size
-- row unit: (brand, segment) summary
-- Pattern:
-- Join the transactions table to stores to map each transactions with the store brand
-- filter rows to include only transactions that happened in the year 2017
-- Aggregate rows to (store_brand,customer) level grain
-- compute total_sales, number of transactions, average basket_size per customer within each brand
-- group customers into segemnts based on the  basket_size
-- aggregate again to (brand, segemnt) level to compute
-- distinct customers
-- total transactions
-- total sales
-- average basket size = total sales / total transactions

