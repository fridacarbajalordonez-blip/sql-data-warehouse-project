/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
DATA DEFINITION LENGUAGE FOR THE GOLDEN LAYER
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

Script purpose:
After correcting, cleansing, and standardizing the data in the Bronze and Silver layers,
the data is ready to be presented for business-level analysis and reporting.

For the Gold layer, we organize the prepared data according to business concepts.
Considering the structure and content of the source tables, we determined that a star
schema is the most appropriate model for data organization and analysis.

Therefore, three tables were created based on their quantitative and qualitative
information.

For qualitative information, we built two dimension tables: Customers and Products.
These tables contain descriptive details about customers and products, respectively.

For quantitative information, we built one fact table: Sales. This table contains
numerical measures that support business analysis and reporting.

The Sales fact table is connected to the Customers and Products dimension tables
through surrogate keys, enabling efficient analytical queries and reporting.

*/

-------------------------------- CREATION OF DIMENSION TABLE: CUSTOMERS --------------------------------------
CREATE VIEW gold.dim_customers AS
--Gathering all customers information into one single table
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


------------------------------- CREATION OF DIMENSION TABLE: PRODUCTS ------------------------------------

CREATE VIEW gold.dim_products AS
	--Gathering all products information into one single table
SELECT
ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
pn.prd_id AS product_id,
pn.prd_key AS product_number, 
pn.prd_nm AS product_name,
pn.cat_id AS category_id,
pc.cat AS category,
pc.subcat AS subcategory,
pc.maintenance AS maintenanca,
pn.prd_cost AS product_cost,
pn.prd_line AS product_line, 
pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id =pc.id
WHERE pn.prd_end_dt IS NULL 


------------------------------------ CREATION OF FACT TABLE: SALES -------------------------------------
	
CREATE VIEW gold.fact_sales AS
	--Gathering sales information into one single table conecting by customers and product surrogated keys 
SELECT 
sd.sls_ord_num AS order_number,
pr.product_key, --Surrogate key from Product dimension table
cu.customer_key, --Surrogate key from Customers dimension table
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS ship_date, 
sd.sls_due_dt AS due_date,
sd.sls_sales AS sales_amount,
sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id


