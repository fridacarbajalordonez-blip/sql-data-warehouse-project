
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

-- Defining a View table for joining sales to customers
IF OBJECT_ID('gold.report_customers_revenue','V') IS NOT NULL
    DROP VIEW gold.report_customers_revenue;
GO
CREATE VIEW gold.report_customers_revenue AS
SELECT
    sls.customer_key,
    ctm.first_name,
    ctm.last_name,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order
FROM gold.fact_sales sls
JOIN gold.dim_customers ctm
    ON sls.customer_key = ctm.customer_key
GROUP BY
    sls.customer_key,
    ctm.first_name,
    ctm.last_name;
   

---------------------------------------------------------------------------------
-- Order per customers
SELECT TOP 5 *
FROM gold.report_customers_revenue
ORDER BY total_orders DESC
-- TOP 5 CUSTOMERS BY ORDERS:
-- 1. Dalton Pérez
-- 2. Mason Roberts
-- 3. Ashley Henderson 
-- 4. Jason Griffin
-- 5. Hailey Patterson

---------------------------------------------------------------------------------
-- Revenue
SELECT
ROUND(AVG(total_sales),2) AS average_revenue
FROM gold.report_customers_revenue
-- Average revenue per customers: 1,588.20

---------------------------------------------------------------------------------
-- Revenue per customers 
SELECT TOP 5 *
FROM gold.report_customers_revenue
ORDER BY total_sales DESC
-- TOP 5 CUSTOMERS:
-- 1. Kaitlyn Henderson
-- 2. Nichole Nara
-- 3. Margaret He
-- 4. Randall Domimguez
-- 5. Adriana Gonzalez 

---------------------------------------------------------------------------------
-- Sales by country 
SELECT 
    country,
    SUM(sales_amount) AS revenue_per_country
FROM gold.fact_sales sls
LEFT JOIN gold.dim_customers ctm
ON sls.customer_key = ctm.customer_key
GROUP BY country
ORDER BY revenue_per_country DESC
-- Top 3: USA, Australia and UK

---------------------------------------------------------------------------------
-- Sales by Marital Status 
SELECT 
    marital_status,
    SUM(sales_amount) as sales_per_marital_status
FROM gold.fact_sales sls
LEFT JOIN gold.dim_customers ctm
ON sls.customer_key = ctm.customer_key
GROUP BY marital_status
ORDER BY sales_per_marital_status DESC
-- Married customers buy more than Single customers.

---------------------------------------------------------------------------------
-- Sales by gender
SELECT 
    gender,
    SUM(sales_amount) AS sales_per_gender
FROM gold.fact_sales sls
LEFT JOIN gold.dim_customers ctm
ON sls.customer_key = ctm.customer_key
GROUP BY gender
ORDER BY sales_per_gender DESC
-- Female: 30,004
-- Male: 30,361 

---------------------------------------------------------------------------------
-- Sales by age
WITH customer_age AS (
    SELECT
        DATEDIFF(YEAR, ctm.birth_date, sls.order_date) AS age,
        sls.sales_amount
    FROM gold.fact_sales sls
    LEFT JOIN gold.dim_customers ctm
        ON sls.customer_key = ctm.customer_key
),
age_groups AS (
    SELECT
        CASE
            WHEN age < 30 THEN '18-29'
            WHEN age < 40 THEN '30-39'
            WHEN age < 50 THEN '40-49'
            WHEN age < 60 THEN '50-59'
            ELSE '60+'
        END AS age_group,
        sales_amount
    FROM customer_age
)
SELECT
    age_group,
    SUM(sales_amount) AS sales_per_age
FROM age_groups
GROUP BY age_group
ORDER BY sales_per_age DESC;
-- Customers on their 30s are the main buyers


/*
CONCLUSIONS

1. Average customer revenue is 1,588.20.

2. USA, Australia and UK generate the highest revenue.

3. Married customers generate more total revenue than single customers.

4. Revenue distribution between male and female customers is relatively balanced.

5. Customers aged 30–39 contribute the highest share of revenue.

These findings provide a high-level understanding of customer demographics
and purchasing behavior and can serve as a foundation for deeper analysis
through Power BI dashboards and customer segmentation.
*/
