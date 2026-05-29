/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
DATA CLEANSING, TRANSFORMATION, AND STANDARDIZATION OF DATA FOR FILLING silver.crm_cust_info TABLE
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

SCRIPT PURPOSE:
This scripts takes data from bronze.crm_cust_info, performs data cleansing, transformation,
and standardization to ensure data quality and integrity before inserting it into silver.crm_cust_info. 
The script includes the following steps:
1. Removing unwanted spaces from first and last names using the TRIM function.
2. Standardizing gender and marital status values 
3. Handling duplicates by keeping only the latest record based on the create date for each cust_id.

Some tests are included at the end of this script to vaidate the data quality and integrity
of the silver.crm_cust_info table after the transformation and loading process. 

*/

-- Preparing 'silver.crm_cust_info' table for new data by removing existing records.
TRUNCATE TABLE silver.crm_cust_info;
-- Inserting data from the query into the silver.crm_cust_info table.
INSERT INTO silver.crm_cust_info(
	cust_id, 
	cst_key, 
	cst_firstname, 
	cst_lastname, 
	cst_marital_status,
	cst_gndr, 
	cst_create_date)
	SELECT
		cust_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname,--Removing unwanted spaces from the first name
		TRIM(cst_lastname) AS cst_lastname,--Removing unwanted spaces from the last name
		CASE WHEN cst_marital_status = 'S' THEN 'Single'
			WHEN cst_marital_status = 'M' THEN 'Married'
			ELSE 'n/a'
		END AS cst_marital_status,--Standardizing marital status values to 'Single', 'Married', or 'n/a'
		CASE WHEN cst_gndr = 'F' THEN 'Female'
			WHEN cst_gndr = 'M' THEN 'Male'
			ELSE 'n/a'
		END AS cst_gndr,--Standardizing gender values to 'Female', 'Male' or 'n/a'
		cst_create_date
		FROM (
			SELECT
			*,
			ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY cst_create_date DESC) AS latest_record
			FROM bronze.crm_cust_info
			WHERE cust_id IS NOT NULL
			)t WHERE latest_record = 1 --Subquery to filter out duplicates, keeping only the latest record based on create date for each cust_id



-- Test Cases to Validate Data Quality and Integrity in silver.crm_cust_info

SELECT 
*
FROM silver.crm_cust_info
WHERE cst_marital_status NOT IN ('Single', 'Married')

--- Check for Duplicates, WE EXPECT 0 RECORDS
SELECT 
cust_id,
COUNT(*) AS total_records
FROM silver.crm_cust_info
GROUP BY cust_id
HAVING COUNT(*) > 1


--- Check for unwanted Spaces, WE EXPECT 0 RECORDS
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- Data Standardization and Consistency 
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info
