/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
DATA CLEANSING, TRANSFORMATION, AND STANDARDIZATION OF DATA FOR FILLING silver.crm_prd_info TABLE
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
*/

-- INITIALIZING THE TABLE STRUCTURE FOR silver.crm_prd_info
-- Dropping the silver.crm_prd_info table if it already exists
--to ensure a clean slate for data insertion.

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
	prd_id INT,
	cat_id NVARCHAR(50),
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()

);

INSERT INTO silver.crm_prd_info (
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT 
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1,5), '-', '_') as cat_id, --Extracting category ID from prd_key and replacing '-' with '_'
	SUBSTRING(prd_key, 7,LEN(prd_key)) as prd_key, --Extracting subcategory ID from prd_key
	prd_nm,
	ISNULL(prd_cost,0) AS prd_cost,
	CASE UPPER(TRIM(prd_line))
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Othe Sales'
		WHEN 'T' THEN 'Touring'
		ELSE 'n/a'
	END AS prd_line, --Standardizing product line values to 'Mountain', 'Road', 'Other Sales', 'Touring' or 'n/a'
	CAST(prd_start_dt AS DATE) as prd_start_dt,
	CAST(LEAD (prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
	FROM bronze.crm_prd_info

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
SELECT 
*
FROM silver.crm_prd_info
