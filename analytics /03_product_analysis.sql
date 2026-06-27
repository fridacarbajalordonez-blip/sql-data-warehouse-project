/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-
                        PRODUCTS EXPLORATION
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-

Script Purpose:
This script explores product performance using sales, quantity, cost,
and profit metrics from the Gold layer.

The analysis focuses on:
- Measuring overall product sales activity.
- Identifying the best-performing products by orders, revenue, and profit.
- Comparing business performance across categories, subcategories,
  and product lines.
- Evaluating products that have not generated sales.
- Analyzing maintenance requirements and their relationship to revenue.

These analyses provide a high-level overview of product performance and
support business decisions related to inventory management, product
strategy, and profitability.
===============================================================================
*/

IF OBJECT_ID('gold.report_products_revenue','V') IS NOT NULL
       DROP VIEW gold.report_products_revenue;
GO
    CREATE VIEW gold.report_products_revenue AS
    SELECT
        sls.product_key,
        prd.product_id,
        prd.product_name,
        COUNT(DISTINCT(sls.order_number)) AS order_per_product,
        SUM(sls.sales_amount) AS total_sales,
        SUM(sls.quantity * prd.product_cost) AS total_cost,
        SUM(sls.sales_amount - (sls.quantity * prd.product_cost)) AS total_profit,
        ROUND(SUM(sls.sales_amount - (sls.quantity * prd.product_cost)) *100.0/SUM(sls.sales_amount),2) AS profit_margin
    FROM gold.fact_sales sls
    JOIN gold.dim_products prd
        ON sls.product_key = prd.product_key
    GROUP BY
        sls.product_key,
        prd.product_id,
        prd.product_name

---------------------------------------------------------------------------------
-- Total number of products and sold products 
SELECT
    (SELECT COUNT(*) FROM gold.dim_products) AS total_products,
    (SELECT COUNT(DISTINCT product_key) FROM gold.fact_sales) AS sold_products
-- 44% of the products where sold at least once  

--No sales products list
SELECT
    prd.category,
    COUNT(DISTINCT
        CASE WHEN sls.sales_amount IS NOT NULL THEN prd.product_key
    END) AS products_sold,
    COUNT(DISTINCT 
        CASE WHEN sls.sales_amount IS NULL THEN prd.product_key
    END) AS products_not_sold
FROM gold.dim_products prd
LEFT JOIN gold.fact_sales sls
    ON prd.product_key = sls.product_key
GROUP BY prd.category
ORDER BY prd.category;
-- No products from 'Components' category were sold.  

---------------------------------------------------------------------------------
-- Orders per products
SELECT TOP 5 *
FROM gold.report_products_revenue
ORDER BY order_per_product DESC
-- TOP 5 PRODUCTS BY ORDERS
-- 1. Water Bottle -30 oz.
-- 2. Patch Kit/8 Patches
-- 3. Mountain Tire Tube 
-- 4. Road Tire Tube
-- 5. Sport-100 Helmet-Red

---------------------------------------------------------------------------------
-- Sales per product 
SELECT TOP 5 *
FROM gold.report_products_revenue
ORDER BY total_sales DESC
-- TOP 5 PRODUCTS BY SALES
-- 1. Mountain-200 Black- 46
-- 2. Mountain-200 Black- 42
-- 3. Mountain-200 Silver- 38
-- 4. Mountain-200 Silver- 46
-- 5. Mountain-200 Black- 38

---------------------------------------------------------------------------------
-- Profit per product 
SELECT TOP 5 *
FROM gold.report_products_revenue
ORDER BY total_profit DESC
-- TOP 5 PRODUCTS BY PROFIT
-- 1. Mountain-200 Black- 46
-- 2. Mountain-200 Black- 42
-- 3. Mountain-200 Silver- 38
-- 4. Mountain-200 Silver- 46
-- 5. Mountain-200 Black- 38

---------------------------------------------------------------------------------
-- Profit margin per product 
SELECT TOP 5 *
FROM gold.report_products_revenue
ORDER BY profit_margin DESC
-- Road Tire Tub has the highest profit_margin (75%)

---------------------------------------------------------------------------------
-- Orders, sales, cost and profit by Category 
SELECT 
    category,
    COUNT(DISTINCT(sls.order_number)) AS orders_per_subcategory,
    SUM(sls.sales_amount) AS total_sales,
    SUM(sls.quantity * prd.product_cost) AS total_cost,
    SUM(sls.sales_amount - (sls.quantity * prd.product_cost)) AS total_profit
FROM gold.fact_sales sls
LEFT JOIN gold.dim_products prd
  ON sls.product_key = prd.product_key
GROUP BY 
    category  
ORDER BY total_profit DESC
-- The category Bikes has the highest profit.


---------------------------------------------------------------------------------
-- Orders, Sales, Cost and Profit by Subcategory
SELECT 
    category,
    subcategory,
    COUNT(DISTINCT(sls.order_number)) AS orders_per_subcategory,
    SUM(sls.sales_amount) AS total_sales,
    SUM(sls.quantity * prd.product_cost) AS total_cost,
    SUM(sls.sales_amount - (sls.quantity * prd.product_cost)) AS total_profit
FROM gold.fact_sales sls
LEFT JOIN gold.dim_products prd
  ON sls.product_key = prd.product_key
GROUP BY 
    category,
    subcategory
ORDER BY total_profit DESC
-- TOP 3 SUBCATEGORIES BY PROFIT:
-- 1. Road Bikes
-- 2. Mountain Bikes
-- 3. Touring Bikes


---------------------------------------------------------------------------------
-- Sales, Cost and Profit by Product Line 
SELECT
    product_line,
    SUM(sls.sales_amount) AS total_sales,
    SUM(sls.quantity * prd.product_cost) AS total_cost,
    SUM(sls.sales_amount - (sls.quantity * prd.product_cost)) AS total_profit
FROM gold.fact_sales sls
JOIN gold.dim_products prd
    ON sls.product_key = prd.product_key
GROUP BY product_line
ORDER BY total_profit DESC;
-- The product line "Road" has the highest profit 



---------------------------------------------------------------------------------
-- Maintenance by category 
SELECT DISTINCT 
    category,
    maintenance,
    COUNT(*)
FROM gold.dim_products
GROUP BY 
    category, 
    maintenance
ORDER BY 
    category, 
    maintenance
-- All Bikes require maintenance.
-- Clothing requires no maintenance.
-- Accessories and Components is optional. 


-- Revenue from maintenance
SELECT
    prd.maintenance,
    SUM(sls.sales_amount) AS revenue,
    ROUND(
        SUM(sls.sales_amount) * 100.0 / SUM(SUM(sls.sales_amount)) OVER (), 2
    ) AS percentage
FROM gold.fact_sales sls
JOIN gold.dim_products prd
    ON sls.product_key = prd.product_key
GROUP BY prd.maintenance
-- 98.22% of the revenue comes from products that require maintenance. 


---------------------------------------------------------------------------------
/*
CONCLUSIONS
The product catalog contains 295 unique products, but only 44% were sold
   at least once during the analyzed period.

-- No products from the Components category generated sales, indicating no demand.

-- Water Bottle -30 oz. is the most frequently ordered product, while
   Mountain Bike models generate the highest revenue and profit.

-- Bikes represent the most profitable product category, with Road Bikes,
   Mountain Bikes, and Touring Bikes leading profitability among most sold 
   subcategories.

-- The Road product line contributes the highest overall profit.

-- Products requiring maintenance account for 98.22% of total revenue,
   showing that the company's revenue is highly concentrated in
   maintenance-dependent products.


*/

