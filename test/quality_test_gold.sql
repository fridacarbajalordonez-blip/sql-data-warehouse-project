/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
QUALITY CHECKS FOR GOLDEN LAYER
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

Script purpose:
For prooving the quality, integrity and consistency of the Gold Layer
some checks are included in order to ensure:
	- Uniqueness of the surrogate keys in Customers and Product dimension tables.
	- Referential integrity between the dimensions tables and fact table.
	- Valid relationships between tables proving the model for reporting and analitical decisions.

*/

-- Checking for uniqueness of Customer Surrogate Key 
-- We found no duplicated records for each surrogate key 
SELECT 
	customer_key,
	COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1

-- Checking for uniqueness of Product Surrogate Key 
-- We found no duplicated records for each surrogate key 
SELECT 
	product_key,
	COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1

-- Checking the correct relationship between dimensions and fact tables
-- VALIDATING: Data Integrations Checks
-- We found that all sales are connected to a product and customer.
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE c.customer_key  IS NULL 
OR p.product_key IS NULL -- All sales must be related to a product and customer.
