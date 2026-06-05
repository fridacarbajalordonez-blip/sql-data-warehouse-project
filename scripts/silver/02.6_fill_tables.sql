/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
DATA CLEANSING, TRANSFORMATION, AND STANDARDIZATION OF DATA FOR FILLING silver.erp_px_cat_g1v2 TABLE
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

Script purpose:
This script is designed to perform data cleansing, transformation, and standardization on the data from the
silver.erp_px_cat_g1v2 table before inserting it into the silver.erp_px_cat_g1v2 table.

We explored the source data and found out everything looks good. 
We have no duplicates on cat and subcat columns, and we have no invalid values on maintenance column. 
So we can proceed with the data load to silver layer without any transformation or standardization.
*/

SELECT *
FROM bronze.erp_px_cat_g1v2

-- Checking for duplicates on cat and subcat Value LIST
-- We found 4 types of cat values that are well defined.
SELECT DISTINCT cat
FROM bronze.erp_px_cat_g1v2

-- We found 37 types of subcat values that are well defined. 
SELECT DISTINCT subcat
FROM bronze.erp_px_cat_g1v2

-- Checking invalid values on maintenance column. 
-- We found no invalid values on maintenance column.
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE maintenance NOT IN ('Yes', 'No') OR maintenance IS NULL

--Everything looks good on the source table. We can proceed with the data load to silver layer.

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
