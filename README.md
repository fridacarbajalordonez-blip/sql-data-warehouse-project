# SQL Data Warehouse Project 

Building a data warehouse on SQL by designing the data architecture, including ETL processes for cleansing and standardizing data in order to prepare it for data modeling, data science and analytics.

## Data sources
Raw data is given on six csv files contained on two folders as it follows:

* source_crm
  - cust_info
  - pdr_info
  - sales_details
  
* source_erp:
  - CUST_AZ12
  - LOC_A201
  - PX_CAT_G1V2


## ETL methodology 
For this data engineering project, the ETL techniques used to prepare the data for analysis are described below for each  part of the ETL

### Extraction
A pull extraction method is used with full extraction and file parsing techniques.

### Transformation
For this project, we are going to use:
* Data Enrichment: making data more complete.
* Data Integration: combining and gropuing data from multiple sources into a unified dataset.
* Derived Columns: creating calculated columns that show results from original given columns.
* Data Cleansing: 
  - Removing duplicates
  - Data filtering
  - Handling missing data, invalid values and unwanted spaces
  - Data type casting
  - Outlier detection
* Data Aggregations: summarizing data to generate meaningful insights.
* Bussiness Rules and Logic: categorizing and transforming data to make it more descriptive for bussines requirements.
* Data Normalization and Standardization: making the data more even for a better management.

### Load
The  processing type used is batch processing with a full load approach through a truncate-and-insert method. 
Since this project does not handle large-scale databases, a Slowly Changing Dimension Type 1 (SCD 1) overwrite strategy is enough.

## Data Architechture
The project follows a Medallion Architecture approach using Bronze, Silver, and Gold layers to organize raw, cleansed, and business-ready data throughout the ETL pipeline. 

## Analytics

Once the data warehouse was built and the Gold layer contained clean, structured, and business-ready data, the next step was to analyze the business performance.
The first stage of the analysis consisted of SQL queries designed to explore the database and answer key business questions regarding customer behavior, product performance, sales distribution, and revenue trends over time.
These analytical SQL views later served as the foundation for building an interactive Power BI dashboard, allowing business stakeholders to monitor KPIs and explore the data visually.


## Business Insights
* Total Sales reports 29.36 Million dollars coming from 60K orders on a time period from December 29th,2010 to January 28th, 2014 with a 40% from the product catalog sold to 18K customers 
* Customers from USA, Australia and UK generate the highest revenue with no remarcable difference between genders, but an interesting bigger contribution for ages between 50-59. The average customer revenue is 1,588.20
* Product main category sold is "Bikes" representing the 96.5% of the revenue, which gives Profit of 11.1M. The most sold Subcategory is "Road Bikes" with a profit of 5.3M. Eventhough the  Product "Water Bottle - 30 oz." was the most ordered product, the "Mountain-200 Black-46" gave the highest profit of 597K, but the highest profit margin of 75% comes from "Road Tire Tube".  
* Best Year for Sales was 2013 reporting 16M. Along the years June was the month that recieved more orders, but accumulated quarterly, last fourth of the year showed the highest revenue.

## Business Insights

- The company generated **$29.36M in revenue** from **60K orders** between **December 29, 2010 and January 28, 2014**, serving more than **18K customers**. Only **44% of the product catalog** generated at least one sale.
- Customers from **United States, Australia, and the United Kingdom** generated the highest revenue. Revenue distribution is relatively balanced across genders, while customers aged **50–59** contributed the largest share of sales.

- **Bikes** represent the core business, accounting for **96.5% of total revenue** and generating more than **$11.1M in profit**. Road Bikes were the most profitable subcategory.

- Although **Water Bottle - 30 oz.** was the most frequently ordered product, **Mountain-200 Black-46** generated the highest total profit (**$597K**). Meanwhile, **Road Tire Tube** achieved the highest profit margin (**75%**).

- Revenue grew consistently until **2013**, which became the company's strongest year. Quarterly analysis shows that **Q4 consistently generated the highest revenue**, suggesting a recurring seasonal pattern.

## Business Recommendations and Future Improvements
* Given that United States and Australia are the best country buyers, I would suggest maintain and if posiible strenght current market strategy on both countries.
* United Kingdom, Germany and France are good buyers, but I would suggest some market strategies for improving sales.
* The main buyers are on their 50s, so I suggest target publicity to this sector of the population.
* Since Bikes is the main sold product, maintain current strategy for "Mountain Bike" Product Line and improve for "Road Bike".
* Apply cost strategy used for Road Tire Tube in order to reach its profit margin.
  
## License

This project is licensed under the MIT License.  
You are free to use, modify, and distribute this project with proper attribution.

See the `LICENSE.md` file for more details.

## About the Author

Developed by Frida Elizabeth Carbajal Ordóñez.

Actuarial science graduate with an interest in data science, analytics, and data engineering. Passionate about transforming raw data into meaningful insights through SQL, Python, and data visualization.

