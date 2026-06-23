/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*
							CUSTOMERS EXPLORATION 
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*

Script Purpose:
This script explores customer-related information from the Gold layer in order
to identify patterns in customer behavior and revenue generation.

The analysis focuses on:
- Identifying Top 5 customers with the highest number of orders and highest revenue.
- Evaluating revenue distribution across countries.
- Comparing revenue by gender.
- Analyzing customer demographics, including marital status and age groups.
- Providing insights that support customer segmentation and business decisions.

These analyses are intended to help understand customer characteristics,
purchasing patterns, and their contribution to overall business performance.
===============================================================================
*/

-- Order per customers 
-- TOP 5 CUSTOMERS:
-- 1. Ashley Henderson 
-- 2. Fernando Barnes
-- 3. Charles Jackson
-- 4. Jennifer Simmons
-- 5. Henry Garcia

SELECT TOP 5
sls.customer_key,
ctm.first_name,
ctm.last_name,
COUNT(*) AS order_per_customer
FROM gold.fact_sales sls
LEFT JOIN gold.dim_customers ctm
 ON sls.customer_key = ctm.customer_key
GROUP BY sls.customer_key, ctm.first_name,ctm.last_name
ORDER BY order_per_customer DESC;


-- Average orders per customers: 3.27
SELECT 
ROUND(AVG(CAST(order_per_customer AS DECIMAL(4,1))),2) AS average_order
FROM (
SELECT 
sls.customer_key,
ctm.first_name,
ctm.last_name,
COUNT(*) AS order_per_customer
FROM gold.fact_sales sls
LEFT JOIN gold.dim_customers ctm
 ON sls.customer_key = ctm.customer_key
GROUP BY sls.customer_key, ctm.first_name,ctm.last_name
)t;

-- Revenue per customers 
-- TOP 5 CUSTOMERS:
-- 1. Nichole Nara
-- 2. Kaitlyn Henderson
-- 3. Margaret He
-- 4. Randall Domimguez
-- 5. Adriana Gonzalez 
SELECT TOP 5
    sls.customer_key,
    ctm.first_name,
    ctm.last_name,
    SUM(sales_amount) AS sales_per_customer
FROM gold.fact_sales sls
LEFT JOIN gold.dim_customers ctm
 ON sls.customer_key = ctm.customer_key
GROUP BY sls.customer_key, ctm.first_name,ctm.last_name
ORDER BY sales_per_customer DESC;


--Average sales per customer: 1,588.20
SELECT 
ROUND(AVG(sales_per_customer),2) AS average_order
FROM (
SELECT
    sls.customer_key,
    ctm.first_name,
    ctm.last_name,
SUM(sales_amount) AS sales_per_customer
FROM gold.fact_sales sls
LEFT JOIN gold.dim_customers ctm
 ON sls.customer_key = ctm.customer_key
GROUP BY sls.customer_key, ctm.first_name,ctm.last_name
)t;


-- Sales by country 
-- Top 3: USA, Australia and Canada
SELECT 
    country,
    COUNT(*) AS sales_per_country
FROM gold.fact_sales sls
LEFT JOIN gold.dim_customers ctm
ON sls.customer_key = ctm.customer_key
GROUP BY country
ORDER BY sales_per_country DESC;



-- Sales by Marital Status 
-- Married customers buy more than Single customers.
SELECT 
    marital_status,
    COUNT(*) as sales_per_marital_status
FROM gold.fact_sales sls
LEFT JOIN gold.dim_customers ctm
ON sls.customer_key = ctm.customer_key
GROUP BY marital_status
ORDER BY sales_per_marital_status DESC;



-- Sales by gender
-- Female: 30,004
-- Male: 30,361 
SELECT TOP 2
    gender,
    COUNT(*) AS sales_per_gender
FROM gold.fact_sales sls
LEFT JOIN gold.dim_customers ctm
ON sls.customer_key = ctm.customer_key
GROUP BY gender
ORDER BY sales_per_gender DESC;

-- Sales by age
-- Top 5 ages: 51, 52, 47, 45, 46
WITH customer_age AS (
    SELECT
        DATEDIFF(YEAR, ctm.birth_date, GETDATE()) AS age
    FROM gold.fact_sales sls
    LEFT JOIN gold.dim_customers ctm
        ON sls.customer_key = ctm.customer_key
)
SELECT TOP 5
    age,
    COUNT(*) AS sales_per_age
FROM customer_age
GROUP BY age
ORDER BY sales_per_age DESC;
