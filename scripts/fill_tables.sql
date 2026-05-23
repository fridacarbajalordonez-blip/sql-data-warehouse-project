
/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-
CREATES AN STORED PROCEDURE FOR LOADING DATA INTO BRONZE SCHEMA TABLES FROM CSV FILES 
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze as
	BEGIN
	BEGIN TRY

		PRINT('======================================================================')
		PRINT('LOADING DATA INTO BRONZE SCHEMA TABLES FROM CSV FILES')
		PRINT('======================================================================')

		PRINT('----------------------------------------------------------------------')
		PRINT('Loading CRM tables')
		PRINT('----------------------------------------------------------------------')


	
		PRINT('>>>>>Tuncating and inserting data into tables:')
		PRINT( 'TABLE: bronze.crm_cust_info')
		TRUNCATE TABLE bronze.crm_cust_info;
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\secFc\OneDrive\Documentos\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK--Block the table during the bulk insert operation for improved performance
		);
		PRINT(' ')

		PRINT( 'TABLE: bronze.crm_prd_info')
		TRUNCATE TABLE bronze.crm_prd_info;
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\secFc\OneDrive\Documentos\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT(' ')

		PRINT( 'TABLE: bronze.crm_sales_details')
		TRUNCATE TABLE bronze.crm_sales_details;
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\secFc\OneDrive\Documentos\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT(' ')
	
		PRINT('----------------------------------------------------------------------')
		PRINT('Loading ERP tables')
		PRINT('----------------------------------------------------------------------')

		PRINT('>>>>>Tuncating and inserting data into tables:')
		PRINT( 'TABLE: bronze.erp_cust_az12')
		TRUNCATE TABLE bronze.erp_cust_az12;
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\secFc\OneDrive\Documentos\SQL\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT(' ')

		PRINT('TABLE: bronze.erp_loc_a101')
		TRUNCATE TABLE bronze.erp_loc_a101;
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\secFc\OneDrive\Documentos\SQL\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT(' ')

		PRINT('TABLE: bronze.erp_px_cat_g1v2')
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\secFc\OneDrive\Documentos\SQL\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
	END TRY
	BEGIN CATCH
		PRINT('An error occurred while loading data into bronze tables: ' + ERROR_MESSAGE());
	END CATCH
	END

