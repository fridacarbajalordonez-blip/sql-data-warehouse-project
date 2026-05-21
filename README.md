# SQL Data Warehouse Project 

Making a data warehouse on SQL by designing the data architecture, including ETL processes for cleansing and standardizing data in order to prepare it for data modeling, data science and analytics.

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
For this proyect of data engineering, the techniques for preparing the data for analysis are described below for each  part of the ETL

### Extraction
A pull extraction method is used with full extraction and file parsing techniques.

### Transformation
For this project, we are going to use:
* Data Enrichment: making data more complete.
* Data Integration: combining and grouping similar data.
* Derived Columns: creating columns that show results from original given columns.
* Data Cleansing: 
  - Removing duplicates
  - Data filtering
  - Handling missing data, invalid values and unwanted spaces
  - Data type Casting
  - Outlier Detection
* Data Aggregations: summarizing important data.
* Bussiness Rules and Logic: cathegorizing data to make it more descriptive.
* Data Normalization and Standardization: making the data more even for a better management.

### Load
The type of processing used is batch for a full load through a truncate and insert method. Knowing that we are not treating with big database, an overwrite method would be enough for Slowly Changing Dimensions (SCD 1). 



