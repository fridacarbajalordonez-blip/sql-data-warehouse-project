/* 
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*
							KPIs  
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*
This script calculates the main business Key Performance Indicators (KPIs)
from the Gold layer, providing a high-level overview of business performance, 
including revenue, orders, customer activity, product sales, and profitability.

These metrics are intended to support executive reporting and serve as the
foundation for business dashboards in Power BI or other BI tools.

*/

-------------------------------------------------------------------------------
-- SALES KPIs
-------------------------------------------------------------------------------
SELECT
-- Total Revenue
SUM(sales_amount) AS total_revenue,
-- Total Orders
COUNT(DISTINCT order_number) AS total_orders,
-- Total Customers
COUNT(DISTINCT customer_key) AS total_customers,
-- Total Products Sold
COUNT(DISTINCT product_key) AS products_sold,
-- Average Order Value
ROUND(SUM(sales_amount)*1.0/COUNT(DISTINCT order_number),2) AS average_order_value,
-- Average Items per Order
ROUND(SUM(quantity)*1.0/COUNT(DISTINCT order_number),2) AS average_items_per_order,
-- Average Items per Customer
ROUND(SUM(quantity)*1.0/COUNT(DISTINCT customer_key),2) AS average_items_per_customer
FROM gold.fact_sales;

-------------------------------------------------------------------------------
-- FINANCIAL KPIs
-------------------------------------------------------------------------------
SELECT
-- Total Revenue
SUM(sales_amount) revenue,
-- Total Cost
SUM(quantity*product_cost) cost,
-- Total Profit
SUM(sales_amount-(quantity*product_cost)) profit,
-- Profit Margin
ROUND(SUM(sales_amount-(quantity*product_cost))*100.0/SUM(sales_amount),2) AS profit_margin
FROM gold.fact_sales sls
JOIN gold.dim_products prd
ON sls.product_key=prd.product_key;

/*
===============================================================================
CONCLUSIONS

• The business generated over $29 million in revenue across nearly 28 thousand
  orders, indicating a high-volume sales operation.

• Less than half of the product catalog generated sales, suggesting potential
  opportunities to review underperforming products.

• The average order value is approximately $1,061, providing a benchmark for
  evaluating future sales performance.

• The overall profit margin remains above 40%, indicating strong profitability
  across the products sold.

• These KPIs establish the baseline metrics that will be monitored in the
  Power BI executive dashboard.

===============================================================================
*/
