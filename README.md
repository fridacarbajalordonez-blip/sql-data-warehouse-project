# SQL Data Warehouse & Business Intelligence Project

This project demonstrates an end-to-end Business Intelligence workflow, transforming raw CSV files into actionable business insights through a modern data architecture.

Starting from six raw datasets, the project builds a SQL Server data warehouse following the Medallion Architecture (Bronze, Silver, and Gold layers), applies ETL processes and data quality transformations, develops analytical SQL views, and delivers an interactive Power BI dashboard for business reporting.

The project demonstrates practical experience in:

- SQL Development
- ETL Design
- Data Warehousing
- Data Modeling
- Business Analytics
- KPI Design
- Power BI Dashboard Development
- Data Visualization

# SQL Project Overview
Building a SQL Server data warehouse by designing the data architecture, including ETL processes for cleansing and standardizing data in order to prepare it for data modeling, data science and analytics.

## Data Sources
The project uses six raw CSV files organized into two folders as it follows:

* source_crm
  - cust_info
  - pdr_info
  - sales_details
  
* source_erp:
  - CUST_AZ12
  - LOC_A201
  - PX_CAT_G1V2
  - 
## Data Architecture
The project follows a Medallion Architecture approach using Bronze, Silver, and Gold layers to organize raw, cleansed, and business-ready data throughout the ETL pipeline. 

## ETL Methodology 
The ETL methodology used to prepare the data for analysis is described below.

### Extraction
A pull extraction method is used with full extraction and file parsing techniques.

### Transformation
For this project, we are going to use:
* Data Enrichment: making data more complete.
* Data Integration: combining and grouping data from multiple sources into a unified dataset.
* Derived Columns: creating calculated columns that show results from original given columns.
* Data Cleansing: 
  - Removing duplicates
  - Data filtering
  - Handling missing data, invalid values and unwanted spaces
  - Data type casting
  - Outlier detection
* Data Aggregations: summarizing data to generate meaningful insights.
* Business Rules and Logic: categorizing and transforming data to make it more descriptive for busines requirements.
* Data Normalization and Standardization: making data more consistent for easier analysis and management.

### Load
The  processing type used is batch processing with a full load approach through a truncate-and-insert method. 
Since this project does not handle large-scale databases, a Slowly Changing Dimension Type 1 (SCD 1) overwrite strategy is enough.



## Analytics

Once the data warehouse was built and the Gold layer contained clean, structured, and business-ready data, the next step was to analyze the business performance.
The first stage of the analysis consisted of SQL queries designed to explore the database and answer key business questions regarding customer behavior, product performance, sales distribution, and revenue trends over time.
These analytical SQL views later served as the foundation for building an interactive Power BI dashboard, allowing business stakeholders to monitor KPIs and explore the data visually.

## Power BI Dashboard

The analytical SQL views created during this project were imported into Power BI to build an interactive business dashboard.

The dashboard is organized into five pages:

### Executive Dashboard
Provides a high-level overview of business performance through KPIs and key revenue indicators.

<img width="1490" height="852" alt="Executive Dashboard" src="https://github.com/user-attachments/assets/0e7550a6-22d1-4a72-82ea-743b342f1ca1" />

### Customer Analytics
Explores customer behavior by revenue, country, gender, marital status, and age group.
<img width="1487" height="850" alt="Customer Analytics" src="https://github.com/user-attachments/assets/889c7898-12e7-4a58-ba37-270cde267e70" />


### Product Analytics I
Analyzes product performance by revenue, orders, profit, and profit margin.
<img width="1492" height="845" alt="Product Analytics 1" src="https://github.com/user-attachments/assets/215aee52-b468-43b0-8fbe-6d87042626d1" />


### Product Analytics II
Provides aggregated analysis by category, subcategory, and product line.
<img width="1491" height="852" alt="Product Analytics 2" src="https://github.com/user-attachments/assets/ef926192-1cef-4407-b516-93975caf0954" />

### Sales Trend Analysis
Shows yearly, quarterly, monthly, and Month-over-Month (MoM) revenue trends.
<img width="1487" height="853" alt="Sales Trend" src="https://github.com/user-attachments/assets/7b87193f-8f2f-4ab8-bd39-ec74095aa1cd" />


## Business Insights

* The company generated **$29.36M in revenue** from **60K orders** between **December 29, 2010 and January 28, 2014**, serving more than **18K customers**. Only **44% of the product catalog** generated at least one sale.
- Customers from **United States, Australia, and the United Kingdom** generated the highest revenue. Revenue distribution is relatively balanced across genders, while customers aged **50–59** contributed the largest share of sales.

* **Bikes** represent the core business, accounting for **96.5% of total revenue** and generating more than **$11.1M in profit**. **Road** was the most profitable Product Line, Mountain Bikes achieved the highest average profit margin.

* Although **Water Bottle - 30 oz.** was the most frequently ordered product, **Mountain-200 Black-46** generated the highest total profit (**$597K**). Meanwhile, **Road Tire Tube** achieved the highest profit margin (**75%**).

* Revenue grew consistently until **2013**, which became the company's strongest year reporting **16M**. Quarterly analysis shows that **Q4 consistently generated the highest revenue**, suggesting a recurring seasonal pattern.

## Business Recommendations

* Continue prioritizing the United States and Australia, as these markets consistently generate the highest revenue.

* Evaluate growth opportunities in the United Kingdom, Germany, and France through targeted marketing campaigns.

* Since customers aged **50–59** represent the highest-value segment, marketing efforts could be tailored toward this demographic.

* Expand cross-selling opportunities by promoting accessories alongside bicycle purchases to increase average order value.

* Review the Components category, as none of its products generated sales during the analyzed period. This may indicate catalog, inventory, or demand issues.

* Analyze the pricing and cost structure of highly profitable products such as Road Tire Tubes to determine whether similar pricing strategies could be applied to comparable products.

## Future Improvements

* Develop predictive sales forecasting models using Python.

* Perform customer segmentation through machine learning techniques.

* Build recommendation models for cross-selling and upselling opportunities.

* Publish the dashboard using Power BI Service.

* Automate the ETL pipeline for scheduled data refreshes.
  
## License

This project is licensed under the MIT License.  
You are free to use, modify, and distribute this project with proper attribution.

See the `LICENSE.md` file for more details.

## About the Author

Developed by Frida Elizabeth Carbajal Ordóñez.

Actuarial Science graduate with an interest in data science, analytics, and data engineering. Passionate about transforming raw data into meaningful insights through SQL, Python, and data visualization.

