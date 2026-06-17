/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
QUALITY CHECKS FOR SILVER LAYER
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-


Script Purpose:
    This script performs data quality assessments on the Silver layer to ensure that
    transformed data meets business and analytical requirements before being promoted
    to the Gold layer. The checks include:

    - Primary key integrity validation (nulls and duplicates).
    - Text field cleansing verification.
    - Standardization and normalization validation.
    - Date quality and temporal consistency checks.
    - Cross-column and business rule consistency validation.

*/

-- ===============================silver.crm_cust_info=====================================

-- Looking for NULLs or Duplicates in Primary Key
-- We found no duplicate records for each Primary Key
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Looking for Unwanted Spaces
-- We found no Unwanted Spaces
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Data Standardization & Consistency
-- Marital Status data is consistent showing only Single and Married
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;

-- =================================silver.crm_prd_info===================================

-- Looking for NULLs or Duplicates in Primary Key
-- We found no duplicate records for each Primary Key
SELECT 
    prd_id,
    COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for Unwanted Spaces
-- We found no Unwanted Spaces
SELECT 
    prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Looking for NULLs or Negative Values in Cost
-- Cost values show consistency 
SELECT 
    prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency
SELECT DISTINCT 
    prd_line 
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders (Start Date > End Date)
-- Date orders show consistency 
SELECT 
    * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- =================================silver.crm_sales_details===================================

-- Looking for Invalid Dates
-- No Invalid Dates were found
SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt 
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
    OR LEN(sls_due_dt) != 8 
    OR sls_due_dt > 20500101 
    OR sls_due_dt < 19000101;

-- Looking for Invalid Date Orders (Order Date > Shipping/Due Dates)
-- Dates show consistency between them 
SELECT 
    * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Sales = Quantity * Price
-- We found no records where elationship between sales, quantity and price is incorrect 
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ================================silver.erp_cust_az12====================================

-- Identify Out-of-Range Dates
-- Birthdates only between 1910-01-01 and Today
SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1910-01-01' 
   OR bdate > GETDATE();

-- Data Standardization & Consistency
-- Gender data ins consistent: Male, Female, n/a
SELECT DISTINCT 
    gen 
FROM silver.erp_cust_az12;

-- ==================================silver.erp_loc_a101==================================

-- Data Standardization & Consistency
-- Shows valid Countries: Australia, canada, France, Germany, United Kingdom, United States, n/a
SELECT DISTINCT 
    cntr 
FROM silver.erp_loc_a101
ORDER BY cntr;

-- ===============================silver.erp_px_cat_g1v2=====================================

-- Check for Unwanted Spaces
-- No unwanted Spaces found 
SELECT 
    * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Data Standardization & Consistency
-- Only accepts yes and no 
SELECT DISTINCT 
    maintenance 
FROM silver.erp_px_cat_g1v2;
