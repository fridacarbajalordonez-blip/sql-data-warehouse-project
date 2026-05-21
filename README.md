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

## License

This project is licensed under the MIT License.  
You are free to use, modify, and distribute this project with proper attribution.

See the `LICENSE.md` file for more details.

## About the Author

Developed by Frida Elizabeth Carbajal Ordóñez.

Actuarial science graduate with an interest in data science, analytics, and data engineering. Passionate about transforming raw data into meaningful insights through SQL, Python, and data visualization.

