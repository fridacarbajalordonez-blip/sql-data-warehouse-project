/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
DATA CLEANSING, TRANSFORMATION, AND STANDARDIZATION OF DATA FOR FILLING silver.crm_prd_info TABLE
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

Script purpose:
This script is designed to perform data cleansing, transformation, and standardization on the data from the
bronze.crm_prd_info table before inserting it into the silver.crm_prd_info table.
The script includes steps to handle duplicates, unwanted spaces, null values, negative numbers,
data standardization for product lines, and validation of date ranges. 
The goal is to ensure that the data in the silver.crm_prd_info table is clean, consistent, and ready for analysis.

Some test are included at the end to validate data quality and integrity in the silver.crm_prd_info table
(checking for duplicates, unwanted spaces, null values, negative numbers, data standardization, and invalid date ranges.*/


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

TRUNCATE TABLE silver.crm_prd_info;-- Deleting existing records to avoid duplicates before inserting new data.
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
	ISNULL(prd_cost,0) AS prd_cost, --Replacing null values in prd_cost with 0
	CASE UPPER(TRIM(prd_line))
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Other Sales'
		WHEN 'T' THEN 'Touring'
		ELSE 'n/a'
	END AS prd_line, --Standardizing product line values to 'Mountain', 'Road', 'Other Sales', 'Touring' or 'n/a'
	CAST(prd_start_dt AS DATE) as prd_start_dt,
	CAST(LEAD (prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt --Data enrichment by calculating prd_end_dt based on the next prd_start_dt for the same prd_key, subtracting 1 day to avoid overlap
	FROM bronze.crm_prd_info


-- TEST CASES TO VALIDATE DATA QUALITY AND INTEGRITY IN silver.crm_prd_info

--- Check for Duplicates, WE EXPECT 0 RECORDS
SELECT 
prd_id,
COUNT(*) AS total_records
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 or prd_id IS NULL

--- Check for unwanted Spaces, WE EXPECT 0 RECORDS
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

--Check for Nulls or negative numbers, WE EXPECT 0 RECORDS
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0

-- Check for Data Standardization and Consistency in prd_line, WE EXPECT 0 RECORDS
SELECT 
prd_line,
prd_nm
FROM silver.crm_prd_info
WHERE prd_line NOT IN ('Mountain', 'Road', 'Other Sales', 'Touring', 'n/a')

-- Check for Invalid Date Ranges where prd_end_dt is before prd_start_dt, WE EXPECT 0 RECORDS
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt
