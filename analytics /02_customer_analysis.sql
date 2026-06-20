/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-
CUSTOMERS EXPLORATION 
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-

Script purpose:
On this script we are interested on our customers activity

*/



-- Order per customers
SELECT
sls.customer_key,
ctm.first_name,
ctm.last_name,
COUNT(*) AS order_per_customer
FROM gold.fact_sales sls
LEFT JOIN gold.dim_customers ctm
 ON sls.customer_key = ctm.customer_key
GROUP BY sls.customer_key, ctm.first_name,ctm.last_name
ORDER BY order_per_customer DESC
