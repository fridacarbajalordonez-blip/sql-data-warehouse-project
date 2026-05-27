

/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-
CREATES AN STORED PROCEDURE FOR LOADING DATA INTO BRONZE SCHEMA TABLES FROM CSV FILES 
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze as
	BEGIN
	BEGIN TRY
	DECLARE @startdate DATETIME, @enddate DATETIME, @starttime DATETIME, @endtime DATETIME;
		SET @starttime = GETDATE();
		PRINT('======================================================================')
		PRINT('LOADING DATA INTO BRONZE SCHEMA TABLES FROM CSV FILES')
		PRINT('======================================================================')

		PRINT('----------------------------------------------------------------------')
		PRINT('Loading CRM tables')
		PRINT('----------------------------------------------------------------------')

		PRINT('>>>>>Truncating and inserting data into tables:')


		--------------------------------------------------------------  bronze.crm_cust_info
		SET @startdate = GETDATE();
		PRINT( 'TABLE: bronze.crm_cust_info')
		TRUNCATE TABLE bronze.crm_cust_info;
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\secFc\OneDrive\Documentos\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK--Block the table during the bulk insert operation for improved performance
		);
		SET @enddate = GETDATE();
		PRINT('Time taken to load bronze.crm_cust_info: ' + CAST(DATEDIFF(SECOND, @startdate, @enddate) AS NVARCHAR(20)) + ' seconds')
		PRINT(' ')


		--------------------------------------------------------------  bronze.crm_prd_info
		SET @startdate = GETDATE();
		PRINT( 'TABLE: bronze.crm_prd_info')
		TRUNCATE TABLE bronze.crm_prd_info;
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\secFc\OneDrive\Documentos\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @enddate = GETDATE();
		PRINT('Time taken to load bronze.crm_prd_info: ' + CAST(DATEDIFF(SECOND, @startdate, @enddate) AS NVARCHAR(20)) + ' seconds')
		PRINT(' ')


		--------------------------------------------------------------  bronze.crm_sales_details
		SET @startdate = GETDATE();
		PRINT( 'TABLE: bronze.crm_sales_details')
		TRUNCATE TABLE bronze.crm_sales_details;
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\secFc\OneDrive\Documentos\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @enddate = GETDATE();
		PRINT('Time taken to load bronze.crm_sales_details: ' + CAST(DATEDIFF(SECOND, @startdate, @enddate) AS NVARCHAR(20)) + ' seconds')
		PRINT(' ')
	 


		PRINT('----------------------------------------------------------------------')
		PRINT('Loading ERP tables')
		PRINT('----------------------------------------------------------------------')
		PRINT('>>>>>Truncating and inserting data into tables:')


		--------------------------------------------------------------  bronze.erp_cust_az12
		SET @startdate = GETDATE();
		PRINT( 'TABLE: bronze.erp_cust_az12')
		TRUNCATE TABLE bronze.erp_cust_az12;
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\secFc\OneDrive\Documentos\SQL\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @enddate = GETDATE();
		PRINT('Time taken to load bronze.erp_cust_az12: ' + CAST(DATEDIFF(SECOND, @startdate, @enddate) AS NVARCHAR(20)) + ' seconds')
		PRINT(' ')


		--------------------------------------------------------------  bronze.erp_cust_a101
		SET @startdate = GETDATE();
		PRINT('TABLE: bronze.erp_loc_a101')
		TRUNCATE TABLE bronze.erp_loc_a101;
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\secFc\OneDrive\Documentos\SQL\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @enddate = GETDATE();
		PRINT('Time taken to load bronze.erp_loc_a101: ' + CAST(DATEDIFF(SECOND, @startdate, @enddate) AS NVARCHAR(20)) + ' seconds')
		PRINT(' ')


		--------------------------------------------------------------  bronze.erp_px_cat_g1v2
		SET @startdate = GETDATE();
		PRINT('TABLE: bronze.erp_px_cat_g1v2')
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\secFc\OneDrive\Documentos\SQL\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @enddate = GETDATE();
		PRINT('Time taken to load bronze.erp_px_cat_g1v2: ' + CAST(DATEDIFF(SECOND, @startdate, @enddate) AS NVARCHAR(20)) + ' seconds')


		SET @endtime = GETDATE();
		PRINT('======================================================================')
		PRINT('Finished loading data into Bronze Layer')
		PRINT('TOTAL LOAD DURATION:' + CAST(DATEDIFF(SECOND, @starttime, @endtime) AS NVARCHAR(20)) + ' seconds')
		PRINT('======================================================================')


	END TRY

	BEGIN CATCH
		PRINT('An error occurred while loading data into bronze tables: ' + ERROR_MESSAGE());
	END CATCH
	END
