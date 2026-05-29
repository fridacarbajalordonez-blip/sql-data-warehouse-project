/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
DATA CLEANSING, TRANSFORMATION, AND STANDARDIZATION OF DATA FOR FILLING silver.crm_prd_info TABLE
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
*/


SELECT 
	prd_id,
	prd_key,
	REPLACE(SUBSTRING(prd_key, 1,5), '-', '_') as cat_id, --Extracting category ID from prd_key and replacing '-' with '_'
	SUBSTRING(prd_key, 7,LEN(prd_key)) as subcat_id, --Extracting subcategory ID from prd_key
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
	FROM bronze.crm_prd_info
	WHERE SUBSTRING(prd_key, 7,LEN(prd_key))  IN
	(
		SELECT
		sls_prd_key
		FROM bronze.crm_sales_details
	)

/*
--- Check for Duplicates, WE EXPECT 0 RECORDS
SELECT 
prd_key,
COUNT(*) AS total_records
FROM bronze.crm_prd_info
GROUP BY prd_key
HAVING COUNT(*) > 1 or prd_key IS NULL

--- Check for unwanted Spaces, WE EXPECT 0 RECORDS
SELECT prd_key
FROM bronze.crm_prd_info
WHERE prd_key != TRIM(prd_key)
*/
