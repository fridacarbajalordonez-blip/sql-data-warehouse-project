
CREATE VIEW gold.dim_customers AS
--Gathering all costumers information into one single table
SELECT 
ROW_NUMBER() OVER (ORDER BY cust_id) AS customer_key,--SURROGATE KEY 
ci.cust_id AS customer_id,
ci.cst_key AS customer_serie,
ci.cst_firstname AS first_name,
ci.cst_lastname AS last_name,
la.cntr AS country,
ci.cst_marital_status AS marital_status,
--DATA INTEGRATION FOR GENDER COLUMNS:
-- CRM is the main source, if there is no data in CRM, then we will use ERP, if there is no data in both systems, then we will put 'n/a'
CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr 
	 ELSE COALESCE(ca.gen, 'n/a') 
END as gender,
ca.bdate AS birth_date,
ci.cst_create_date AS dwh_create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid

