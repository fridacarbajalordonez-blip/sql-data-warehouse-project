/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
DATA CLEANSING, TRANSFORMATION, AND STANDARDIZATION OF DATA FOR FILLING silver.erp_cust_az12 TABLE
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

Script purpose:
This script is designed to perform data cleansing, transformation, and standardization on the data from the
silver.erp_cust_az12 table before inserting it into the silver.erp_cust_az12 table.

Standardizes cid column lenght to 10 characters, corrects inconsistencies on the birth dates of the customers 
and standardizes genre column into 'Male' and 'Female'
*/




-- Checking for invalid cid values
-- We found 11042 out of 18483 records starting with 'NAS'
SELECT *
FROM bronze.erp_cust_az12
WHERE cid IS NULL --Finding records with null cid values
	OR  10 <  LEN(cid)--Finding records with cid values have more than 10 characters
	


-- Checking for invalid ages in the erp_cust_az12 table
-- We found 35 records with invalid ages (age less than 0 or greater than 100) .
SELECT *
FROM(
SELECT 
cid,
bdate,
DATEDIFF(YEAR, bdate, GETDATE()) age,
gen
FROM bronze.erp_cust_az12
)t WHERE age < 0 OR age > 100 --Finding records with age less than 0 or greater than 100
OR bdate > GETDATE() --Finding records with birth dates in the future
OR bdate IS NULL--Finding records with null birth dates in the bdate column

--Cheking gen column for unwanted spaces or diferent allowed values
SELECT *
FROM bronze.erp_cust_az12
WHERE gen LIKE '% %'--Finding records with unwanted spaces in the gen column
	OR gen NOT IN ('Male', 'Female')--Finding records with values other than Male or Female
	OR gen IS NULL--Finding records with null values in the gen column


--Building the final query to handle all the inconsistencies and invalid values found in the previous checks and insert clean, consistent, and ready for analysis data into silver.erp_cust_az12 table
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

SELECT * 
FROM silver.erp_cust_az12
WHERE bdate --Finding records with birth dates in the future
