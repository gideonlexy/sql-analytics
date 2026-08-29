-- Platform : ScrtaScratch
-- Problem : Most Sold in Germany

-- summary : Find the product market_name with the most orders from users in Germany

-- Output : one row(s) per product market_name with most orders from Germany
-- Enity : product(market_name)
-- Metric : count(product_id) isolate highest orders count
-- filter : users = 'Germany'

-- Level 0:Output(market_name)
-- grain : one row per product_id
-- columns : market_name
-- operation : project

-- Level 1: Need to compute top product orders made by users in Germany
-- grain : one row per (order_id, product_id)
-- columns : order_id, product_id
-- operation : count(*) as total_orders
-- filter : country = 'Germany'

-- Level 1b: Enrich orders with products 
-- grain : one row per (order_id, product_id)
-- columns : po.order_id, po.product_id, p.market_name
-- operation : INNER JOIN map_product_order.product_id ON dim_product.prod_sku_id

WITH orders AS (SELECT
    po.order_id, po.product_id, p.market_name

FROM map_product_order po
INNER JOIN dim_product p ON po.product_id = p.prod_sku_id
INNER JOIN shopify_orders o ON po.order_id = o.order_id
INNER JOIN shopify_users u ON o.user_id = u.id
    AND u.country = 'Germany'),
    
total_orders AS (
SELECT
    product_id,market_name,
    COUNT(*) AS total_orders
FROM orders
GROUP BY 1,2)
SELECT market_name FROM total_orders
WHERE total_orders = (SELECT MAX(total_orders) FROM total_orders)
    
