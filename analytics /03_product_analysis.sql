/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-
PRODUCTS EXPLORATION 
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-

Script purpose:
On this script we are interested on our products activity

*/

-- Order per products
SELECT
sls.product_key,
prd.product_name,
COUNT(*) AS order_per_product
FROM gold.fact_sales sls
LEFT JOIN gold.dim_products prd
 ON sls.product_key = prd.product_key
GROUP BY sls.product_key, prd.product_name
ORDER BY order_per_product DESC
