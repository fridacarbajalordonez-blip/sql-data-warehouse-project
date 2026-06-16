# Data Dictionary for Gold Layer
## Overview 
On this layer the prepared data is presented for the business-level use, with 
improvents on cathegorization and making it more acessible for generating analisis and reports. 
We followed a star schema and defined two dimension tables (customers and products)  and 
one fact table (sales). 
The information for both dimension and fact tables are explained below given by a description for purpose and columns for each table.

### 1. gold.dim_customers 
* **Purpose:** Stores data about customers identity and demographical information.
* **Columns:**

| Column Name     | Data Type     | Description                                                                   |
|-----------------|---------------|-------------------------------------------------------------------------------|
| customer_key    | BIGINT        | Surrogate generated key created for each customer record in the dimension table.|
| customer_id     | INT           | Unique numerical identification number assigned to each customer.             |
| customer_number | NVARCHAR(50)  | Alphanumerical identifier representing the customer, used for tracking and referencing. |
| first_name      | NVARCHAR(50)  | Customer's first name given in the source data.                               |
| last_name       | NVARCHAR(50)  | Customer's last name given in the source data.                                |
| country         | NVARCHAR(50)  | Residence country of each customer.                                           |
| marital_status  | NVARCHAR(50)  | Marital status of the customer (Married, Single).                             |
| gender          | NVARCHAR(50)  | Customer gender ('Male', 'Female', 'n/a').                                    |
| birthdate       | DATE          | Customer's date of birth in YYYY-MM-DD format.                                |
| create_date     | DATE          | Date when the customer record was created in the system.                      |

## 2. gold.dim_products

**Purpose:** Stores descriptive information about products, including categories, costs, and product hierarchy. This table is used to provide context and attributes for sales analysis.

### Columns

| Column Name    | Data Type    | Description                                                                                          |
| -------------- | ------------ | ---------------------------------------------------------------------------------------------------- |
| product_key    | BIGINT       | Surrogate key generated for each product record in the dimension table.                              |
| product_id     | INT          | Unique numerical identification number assigned to each product.                                     |
| product_number | NVARCHAR(50) | Alphanumerical identifier representing the product, used for tracking and referencing.               |
| product_name   | NVARCHAR(50) | Name of the product.                                                                                 |
| category_id    | NVARCHAR(50) | Identifier of the product category.                                                                  |
| category       | NVARCHAR(50) | Main category to which the product belongs.                                                          |
| subcategory    | NVARCHAR(50) | More specific classification within a product category.                                              |
| maintenance    | NVARCHAR(50) | Indicates whether the product requires maintenance and its corresponding maintenance classification. |
| product_cost   | INT          | Cost of the product before sales.                                                                    |
| product_line   | NVARCHAR(50) | Product line classification (Mountain, Road, Touring, etc.).                                         |
| start_date     | DATE         | Date when the product version or record became effective.                                            |

---

## 3. gold.fact_sales

**Purpose:** Stores sales transactions and business metrics used for reporting and analytics. This fact table connects customer and product dimensions through surrogate keys.

### Columns

| Column Name  | Data Type    | Description                                                                  |
| ------------ | ------------ | ---------------------------------------------------------------------------- |
| order_number | NVARCHAR(50) | Unique identifier assigned to each sales order.                              |
| product_key  | BIGINT       | Foreign key referencing the product dimension table (`gold.dim_products`).   |
| customer_key | BIGINT       | Foreign key referencing the customer dimension table (`gold.dim_customers`). |
| order_date   | DATE         | Date when the order was placed by the customer.                              |
| ship_date    | DATE         | Date when the order was shipped.                                             |
| due_date     | DATE         | Expected delivery or due date for the order.                                 |
| sales_amount | INT          | Total sales amount generated by the transaction.                             |
| price        | INT          | Unit price of the product sold in the transaction.                           |

