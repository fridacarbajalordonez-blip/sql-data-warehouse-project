/*
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-
CREATE DATABASE DataWarehouse and SCHEMAS bronze, silver, gold
-*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*--*-*-*-*-*-*-*-

Script purpose:
Before creating a database, it is important to check if a database with the same name already exists. 
If it does, we will drop it before creating a new one. 
Main purpose is to create a database named DataWarehouse and three schemas named bronze, silver, and gold.
*/


USE  master;
go
 
--Checking if a exist a database named "DataWarehouse" before creating one
IF  EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
go


--Creating the database named "DataWarehouse"
CREATE DATABASE DataWarehouse;

USE DataWarehouse;


-- Creating the schemas named bronze, silver, and gold
CREATE SCHEMA bronze;
go
CREATE SCHEMA silver;
go
CREATE SCHEMA gold;
go
