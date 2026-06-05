/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
DATA CLEANSING, TRANSFORMATION, AND STANDARDIZATION OF DATA FOR FILLING silver.erp_loc_a101 TABLE
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

Script purpose:
This script is designed to perform data cleansing, transformation, and standardization on the data from the
silver.erp_loc_a101 table before inserting it into the silver.erp_loc_a101 table.

Standardizes cid column format, corrects duplicates for countries of the customers 
and standardizes values.
*/


-- Checking the list of countries 
SELECT DISTINCT cntr
FROM bronze.erp_loc_a101

-- Building the query to clean cid column and standardize country names 
TRUNCATE TABLE silver.erp_loc_a101
INSERT INTO silver.erp_loc_a101 (
cid, 
cntr
)
SELECT 
REPLACE(cid, '-','') cid,
CASE WHEN TRIM(cntr)= ('DE') THEN 'Germany'
	 WHEN TRIM(cntr) IN ('US', 'USA') THEN 'United States'
	 WHEN TRIM(cntr)= '' OR cntr IS NULL THEN 'n/a'
	 ELSE TRIM(cntr)
END cntr
FROM bronze.erp_loc_a101

