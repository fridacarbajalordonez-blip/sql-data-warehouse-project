
/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
                            SALES TREND ANALYSIS
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

Script Purpose:

This script analyzes sales performance over time using the Gold layer.

The analysis focuses on identifying revenue and order trends at different
time granularities (yearly, quarterly, and monthly), as well as measuring
month-over-month (MoM) growth.

The objective is to identify seasonality, growth patterns, and unusual
variations that can support business planning and strategic decision-making.

===============================================================================
*/


-- -- -- -- -- -- -- -- -- -- Orders Time period -- -- -- -- -- -- -- -- -- -- 
SELECT
MIN(order_date) AS first_order,
MAX(order_date) AS last_order
FROM gold.fact_sales;

-- -- -- -- -- -- -- -- --  Annual Performance -- -- -- -- -- -- -- -- -- -- 
SELECT
YEAR(order_date) AS year,
COUNT(DISTINCT order_number) AS orders,
SUM(sales_amount) AS revenue,
AVG(sales_amount) avg_sale,
SUM(sales_amount)/COUNT(DISTINCT order_number) as avg_sale_per_order
FROM gold.fact_sales
GROUP BY YEAR(order_date)
ORDER BY year

/*
Analyzing annual performance:

* ORDERS: Orders increased slightly from 2010 to 2011, but years 2012 and 2013 
reported the best orders.

* SALES: Follows a similar growth pattern as Orders from 2010 to 2012, where 
year 2013 was the best period. For 2014 the sales also drop dramatically decreasing on 97%.

*AVERAGE SALES: Even though the orders and sales grew along the years, the average 
sales shows a downward trend with particular falls starting 2012 and 2013 respectively. 

IMPORTANT OBSERVATION:
The dataset contains records through January 28, 2014 only.

Although the number of orders is comparable to previous periods,
the reported revenue is significantly lower than expected.
This suggests the last period may be incomplete or affected by
data quality issues and should not be considered representative
of the full year.


*/

 
-- -- -- -- -- -- -- -- --  Monthly Sales Performance -- -- -- -- -- -- -- -- -- -- 
 
SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    COUNT(DISTINCT order_number) AS orders,
    SUM(sales_amount) AS revenue,
    SUM(sales_amount)/COUNT(DISTINCT order_number) as avg_sales_by_order
FROM gold.fact_sales
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    year,
    month;


-- Month Over Month Growth (MoM Growth)
-- To avoid distortion caused by the partial datasets in 2010 and 2014,
-- the MoM analysis includes only complete years (2011–2013).
SELECT 
    year,
    month, 
    orders, 
    revenue,
   ROUND( (revenue - prev) * 100.0 / prev, 2) AS mom_growth_pct
FROM (
SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    COUNT(DISTINCT order_number) AS orders,
    SUM(sales_amount) AS revenue,
    LAG(SUM(sales_amount)) OVER (ORDER BY YEAR(order_date),MONTH(order_date) ) AS prev
FROM gold.fact_sales
WHERE order_date IS NOT NULL AND YEAR(order_date) IN (2011, 2012, 2013)
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
)t
ORDER BY MOM DESC


-- Quarterly Revenue
SELECT
    YEAR(order_date) AS year,
    DATEPART(QUARTER,order_date) AS quarter,
    SUM(sales_amount) AS revenue
FROM gold.fact_sales
GROUP BY
    YEAR(order_date),
    DATEPART(QUARTER,order_date)
ORDER BY
    year,
    quarter;


/*
Analyzing monthly behaviour:

* ORDERS: 
Keeps a slight increase from 2010 to 2012. Starting 2013 duplicates 
and mantains a considerable growth until 2014 were drops dramatically reducing on 60%.

* SALES: 
Follows a similar growth behaviour as Orders from 2010 to 2012, where year 2013 w
as the best period. For 2014 the sales also drop dramatically reducing on 97%.

*AVERAGE SALES BY ORDER: 
Eventhough the orders and sales grew along the years, the average 
sales by order shows a decreasing behaviour with particular falls
starting 2012 and 2013 respectively. 

* MoM observations:
- June 2012 reported the best growth, incremented 54.6% compared to May 
- March 2012 reported the worst fall, decreasing 26.3% compared to February

* Quarterly pattern:
By sales, we can find a common behaviour for 2011, 2012 and 2013, 
where the the fourth quarter consistently generated the highest revenue. 
*/


/*
===============================================================================
CONCLUSIONS

• Sales and order volume increased consistently from 2010 through 2013,
  indicating sustained business growth.

• Revenue follows a clear seasonal pattern, with the fourth quarter
  consistently generating the highest sales each year.

• Although revenue increased over time, the average revenue per order
  gradually decreased after 2012, suggesting customers placed
  smaller-value orders on average.

• June 2012 recorded the strongest month-over-month revenue growth,
  while March 2012 experienced the largest monthly decline.

• Data from 2014 should be interpreted with caution because only
  January records are available and revenue appears incomplete.
*/

