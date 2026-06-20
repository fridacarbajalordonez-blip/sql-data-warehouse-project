/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-
DATABASE EXPLORATION 
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-

Script purpose:
Explore the data in order to have a general idea of the information 
given for customers, products and sales.
We answer some questions with queries for an easier understanding and approach 
to our data.

*/


-- How many customers we have?
-- 18484 customers
SELECT 
COUNT(*) AS total_customers
FROM gold.dim_customers 

-- How many products we have?
-- 295 products
SELECT 
COUNT(*) AS total_products
FROM gold.dim_products

--How many orders we have?
-- 60398
SELECT 
COUNT(*) AS total_orders
FROM gold.fact_sales

SELECT 
COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales

-- Time period of the orders
-- From December 29th,2010
-- To Januaty 28th, 2014
SELECT
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order
FROM gold.fact_sales

