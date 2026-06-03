/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
DATA CLEANSING, TRANSFORMATION, AND STANDARDIZATION OF DATA FOR FILLING silver.crm_sales_detail TABLE
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

Script purpose:
This script is designed to perform data cleansing, transformation, and standardization on the data from the
bronze.crm_sales_detail table before inserting it into the silver.crm_sales_detail table.

We made some initial checkings on dates and sales calculations and found some issues such as:
- Dates in sls_order_dt, sls_ship_dt and sls_due_dt have an integer format representing dates and 
some of them are invalid (less than or equal to 0, not 8 characters in length, or outside the range of 20000101 to 20500101).
- Sales calculations in sls_sales are not consistent with the values in sls_quantity and sls_price 
(sls_sales should be equal to sls_quantity * sls_price) and some of them have null or negative values.

All this inconsistencies and invalid values will be handled in the final query to ensure that the data 
in the silver.crm_sales_detail table is clean, consistent, and ready for analysis.

At the end of the script, some test cases are included to validate our new data
*/



-- CHECKING FOR INVALID RECORDS IN DATES bronze.crm_sales_details

-- Check for sls_order_dt
--We found 19 records with invalid sls_order_dt values.
SELECT
*
FROM bronze.crm_sales_details
WHERE  sls_order_dt <= 0 --Should be greater than 0
	OR LEN(CAST(sls_order_dt AS VARCHAR)) != 8 --Should be 8 characters in length
	OR sls_order_dt >20500101
	OR sls_order_dt < 20000101 --Should be between 20000101 and 20500101


-- Check for sls_ship_dt
--We found 0 records with invalid sls_ship_dt values.
SELECT
*
FROM bronze.crm_sales_details
WHERE  sls_ship_dt <= 0
	OR LEN(CAST(sls_ship_dt AS VARCHAR)) != 8
	OR sls_ship_dt >20500101
	OR sls_ship_dt < 20000101

-- Check for sls_due_dt
-- We found 0 records with invalid sls_due_dt values.
SELECT
*
FROM bronze.crm_sales_details
WHERE  sls_due_dt <= 0
	OR LEN(CAST(sls_due_dt AS VARCHAR)) != 8
	OR sls_due_dt >20500101
	OR sls_due_dt < 20000101
/*
 CHECKING FOR INVALID RECORDS IN SALES CALCULATIONS IN bronze.crm_sales_details

- Records where the sls_sales value is not equal to sls_quantity * sls_price
-Null values and negative values in sls_sales, sls_quantity and sls_price

We found 35 records
*/
SELECT
*
FROM bronze.crm_sales_details
WHERE sls_sales !=  sls_quantity * sls_price
	OR sls_sales IS NULL 
	OR sls_quantity IS NULL
	OR sls_price IS NULL
	OR sls_sales <= 0
	OR sls_quantity <= 0
	OR sls_price <= 0
	
-- Building the final query to select and insert the cleaned and validated data 
--from bronze.crm_sales_details to silver.crm_sales_details.


--INITIALIZING THE TABLE STRUCTURE FOR silver.crm_sales_details
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT, 
	sls_price INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()

);

TRUNCATE TABLE silver.crm_sales_details;-- Deleting existing records to avoid duplicates before inserting new data.
INSERT INTO silver.crm_sales_details (
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)
SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
		CASE WHEN sls_order_dt <=0 
		OR LEN(sls_order_dt) != 8 
		OR sls_order_dt >20500101 
		OR sls_order_dt < 20000101 THEN NULL 
		ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
	END AS sls_order_dt,
	CASE WHEN sls_ship_dt <=0 
		OR LEN(sls_ship_dt) != 8 
		OR sls_ship_dt >20500101 
		OR sls_ship_dt < 20000101 THEN NULL 
		ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
	END AS sls_ship_dt,
	CASE WHEN sls_due_dt <=0 
		OR LEN(sls_due_dt) != 8 
		OR sls_due_dt >20500101 
		OR sls_due_dt < 20000101 THEN NULL 
		ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
	END AS sls_due_dt,
	CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales !=  sls_quantity * ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales,
	sls_quantity,
	CASE WHEN sls_price IS NULL OR sls_price <= 0 
		THEN sls_sales/NULLIF(sls_quantity,0) 
		ELSE sls_price 
	END AS sls_price
	FROM bronze.crm_sales_details

	SELECT *
	FROM silver.crm_sales_details


--TEST CASES TO VALIDATE DATA QUALITY AND INTEGRITY IN silver.crm_sales_details

-- Check for consistency in dates between sls_order_dt, sls_ship_dt and sls_due_dt
SELECT
*
FROM silver.crm_sales_details
WHERE  sls_ship_dt < sls_order_dt
	OR sls_due_dt < sls_order_dt


-- Checking for invalid calculations in sales calculations 
SELECT
*
FROM silver.crm_sales_details
WHERE sls_sales !=  sls_quantity * sls_price
	OR sls_sales IS NULL 
	OR sls_quantity IS NULL
	OR sls_price IS NULL
	OR sls_sales <= 0
	OR sls_quantity <= 0
	OR sls_price <= 0

--DATA IS OK 
