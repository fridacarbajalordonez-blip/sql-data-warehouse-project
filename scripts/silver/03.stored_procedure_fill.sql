

/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
CREATES AN STORED PROCEDURE FOR LOADING DATA INTO SILVER SCHEMA TABLES FROM CSV FILES 
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

Script purpose:
After checking one by one the source tables from bronze layer, and correcting data quality
issues such as duplicates, invalid values and dates and unwanted spaces by applying necessary
transformations and standardizations, we are now ready to load the cleansed and standardized 
data into silver schema tables.

The time taken to load each table is printed at the end of each insert statement, 
and the total load duration is printed at the end of the procedure.

*/



CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	BEGIN TRY

		DECLARE 
		@startdate DATETIME,
		@enddate DATETIME,
		@starttime DATETIME,
		@endtime DATETIME;
		SET @startdate = GETDATE();

		PRINT('======================================================================')
		PRINT('LOADING DATA INTO SILVER SCHEMA TABLES FROM CLEANSED AND NORMALIZED DATA')
		PRINT('======================================================================')
		PRINT('----------------------------------------------------------------------')
		PRINT('            L O A D I N G       C R M     T A B L E S')
		PRINT('----------------------------------------------------------------------')
		PRINT('>>>>>Truncating and inserting data into tables:')
		PRINT'------------------------------------------------'
		SET @starttime = GETDATE();
		PRINT 'Table: silver.crm_cust_info'
		TRUNCATE TABLE silver.crm_cust_info;
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
		SET @endtime = GETDATE();
		PRINT('Time taken to load silver.crm_cust_info: ' + CAST(DATEDIFF(SECOND, @starttime, @endtime) AS NVARCHAR(20)) + ' seconds')



		PRINT'------------------------------------------------'
		PRINT 'Table: silver.crm_prd_info'
		SET @starttime = GETDATE();
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
		SET @endtime = GETDATE();
		PRINT('Time taken to load silver.crm_prd_info: ' + CAST(DATEDIFF(SECOND, @starttime, @endtime) AS NVARCHAR(20)) + ' seconds')

		PRINT'------------------------------------------------'
		PRINT 'Table: silver.crm_sales_details'
		SET @starttime = GETDATE();
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
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) -- Validating and converting sls_order_dt to date format, setting invalid dates to NULL
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
			END AS sls_sales,-- Validating sls_sales value, if it's null, negative or not equal to sls_quantity * sls_price, then calculating it as sls_quantity * sls_price
			sls_quantity,
			CASE WHEN sls_price IS NULL OR sls_price <= 0 
				THEN sls_sales/NULLIF(sls_quantity,0) 
				ELSE sls_price 
			END AS sls_price-- Validating sls_price value, if it's null or negative, then calculating it as sls_sales divided by sls_quantity, using NULLIF to avoid division by zero
			FROM bronze.crm_sales_details
		SET @endtime = GETDATE();
		PRINT('Time taken to load silver.crm_sales_details: ' + CAST(DATEDIFF(SECOND, @starttime, @endtime) AS NVARCHAR(20)) + ' seconds')

		PRINT('----------------------------------------------------------------------')
		PRINT('            L O A D I N G       E R P     T A B L E S')
		PRINT('----------------------------------------------------------------------')
		PRINT('>>>>>Truncating and inserting data into tables:')
		PRINT'------------------------------------------------'

		PRINT 'Table: silver.erp_cust_az12'
		SET @starttime = GETDATE();
		TRUNCATE TABLE silver.erp_cust_az12
		INSERT INTO silver.erp_cust_az12(
		cid,
		bdate, 
		gen
		)
		SELECT 
		CASE WHEN cid LIKE 'NAS%' 
			OR 10 <  LEN(cid)
			THEN SUBSTRING(cid, 4,LEN(cid))
			ELSE cid
		END AS cid,
		CASE WHEN bdate > GETDATE()
			OR DATEDIFF(YEAR, bdate, GETDATE()) < 0 
			OR DATEDIFF(YEAR, bdate, GETDATE()) > 100
			THEN NULL
			ELSE bdate
		END AS bdate,
		CASE
			WHEN gen IS NULL OR TRIM(gen) = '' THEN 'n/a'
			WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
			WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
			ELSE 'n/a'
		END gen
		FROM bronze.erp_cust_az12
		SET @endtime = GETDATE();
		PRINT('Time taken to load silver.erp_cust_az12: ' + CAST(DATEDIFF(SECOND, @starttime, @endtime) AS NVARCHAR(20)) + ' seconds')

		PRINT'------------------------------------------------'
		PRINT 'Table: silver.erp_loc_a101'
		SET @starttime = GETDATE();
		TRUNCATE TABLE silver.erp_loc_a101
		INSERT INTO silver.erp_loc_a101 (
		cid, 
		cntr
		)
		SELECT 
		REPLACE(cid, '-','') cid,-- Removing dashes from cid to standardize the format
		CASE WHEN TRIM(cntr)= ('DE') THEN 'Germany'
			 WHEN TRIM(cntr) IN ('US', 'USA') THEN 'United States'
			 WHEN TRIM(cntr)= '' OR cntr IS NULL THEN 'n/a'
			 ELSE TRIM(cntr)
		END cntr -- Standardizing country names and handling missing values
		FROM bronze.erp_loc_a101
		PRINT('Time taken to load silver.erp_loc_a101: ' + CAST(DATEDIFF(SECOND, @starttime, @endtime) AS NVARCHAR(20)) + ' seconds')


		PRINT'------------------------------------------------'
		PRINT 'Table: silver.erp_px_cat_g1v2'
		TRUNCATE TABLE silver.erp_px_cat_g1v2
		INSERT INTO silver.erp_px_cat_g1v2 (
		id,
		cat,
		subcat,
		maintenance
		)
		SELECT 
		id,
		cat,
		subcat,
		maintenance
		FROM bronze.erp_px_cat_g1v2
		SET @endtime = GETDATE();
		PRINT('Time taken to load silver.erp_px_cat_g1v2: ' + CAST(DATEDIFF(SECOND, @starttime, @endtime) AS NVARCHAR(20)) + ' seconds')
		
		SET @enddate = GETDATE();
		PRINT('======================================================================')
		PRINT('Finished loading data into Silver Layer')
		PRINT('TOTAL LOAD DURATION:' + CAST(DATEDIFF(SECOND, @startdate, @enddate) AS NVARCHAR(20)) + ' seconds')
		PRINT('======================================================================')

	END TRY
	BEGIN CATCH
		PRINT 'An error occurred while loading data into silver tables: ' + ERROR_MESSAGE()
	END CATCH
END

EXEC silver.load_silver
