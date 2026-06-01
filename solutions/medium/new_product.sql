
-- OUTPUT: company_name, net_diff
-- Who/ Entity: company_name
-- Metric : Calculate the net change of products launched in 2020 compared to 2019
--- net_diff = count(product_name in 2020) - count(product_name in 2019)
-- filter : year IN(2020, 2019)

-- Level 0: Output(company_name, net_diff)
-- grain: one row represent company_name
-- columns : company_name, products_2020, products_2019, net_diff
-- operation : net_diff = products_2020 - products_2019
-- Select company_name and the net_diff

-- Level: Need to compute products_2020 and products_2019
-- grain : one row per company_name
-- columns : company_name, product_name
-- operation :COLLAPSE — GROUP BY company_name
--               LABEL products_2020 = COUNT(CASE WHEN year = 2020 THEN product_name END)
--               LABEL products_2019 = COUNT(CASE WHEN year = 2019 THEN product_name END)
-- Raw grain : year, company_name details

WITH cars AS (
SELECT 
    year, company_name, product_name
FROM car_launches
WHERE year IN (2019, 2020)),

products AS(SELECT 
    company_name,
    COUNT(CASE WHEN year = 2019 THEN product_name END) AS product_2019,
    COUNT(CASE WHEN year = 2020 THEN product_name END) AS product_2020
FROM cars
GROUP BY 1)
SELECT
    company_name,
    (product_2020 - product_2019) AS net_diff
FROM products