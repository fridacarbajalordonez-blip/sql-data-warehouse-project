/*Muy importante.
Ventas por:
•	Año
•	Trimestre
•	Mes
*/
/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
SALES TREND ANALYSIS 
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

Script purpose:
Detecting repeated behaviours for sales along time it´s important in order to help decision
makers built strategies improving the bussiness. 

On this script we will dig into revenue by:
•	Year
•	Trimester
•	Month 


*/
-- Orders Time period 
SELECT
MIN(order_date) AS first_order,
MAX(order_date) AS last_order
FROM gold.fact_sales;

-- Yearly revenue 
SELECT
    YEAR(order_date) AS year,
    SUM(sales_amount) AS revenue
FROM gold.fact_sales
GROUP BY
    YEAR(order_date)
ORDER BY
    year
-- Revenue has a significant growth from 2010 to 2013, 
  

-- Monthly revenue 
SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    SUM(sales_amount) AS revenue
FROM gold.fact_sales
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    year,
    month;

SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    COUNT(DISTINCT order_number) AS orders,
    SUM(sales_amount) AS revenue
FROM gold.fact_sales
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    year,
    month;


SELECT 
order_date, 
SUM(sales_amount) AS daily_revenue
FROM gold.fact_sales 
WHERE YEAR(order_date) = 2013
     AND MONTH(order_date) = 1
GROUP BY order_date
ORDER BY order_date DESC

SELECT 
order_date, 
SUM(sales_amount) AS daily_revenue
FROM gold.fact_sales 
WHERE YEAR(order_date) = 2014
     AND MONTH(order_date) = 1
GROUP BY order_date
ORDER BY order_date DESC

-- Sales 
    /*
Aquí después puedes añadir:
•	Running total.
•	YoY Growth.
•	MoM Growth.*/
