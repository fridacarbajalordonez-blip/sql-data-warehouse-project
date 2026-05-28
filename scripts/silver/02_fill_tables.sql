-- FILLING THE TABLES ON THE SILVER LAYER WITH CLEANSED AND STARDARDIZED DATA FROM BRONZE LAYER

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
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN cst_marital_status = 'S' THEN 'Single'
	WHEN cst_marital_status = 'M' THEN 'Married'
	ELSE 'n/a'
END AS cst_marital_status,
CASE WHEN cst_gndr = 'F' THEN 'Female'
	WHEN cst_gndr = 'M' THEN 'Male'
	ELSE 'n/a'
END AS cst_gndr,
cst_create_date
FROM (
	SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY cst_create_date DESC) AS latest_record
	FROM bronze.crm_cust_info
	WHERE cust_id IS NOT NULL
)t WHERE latest_record = 1 

