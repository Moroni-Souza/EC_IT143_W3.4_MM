/*****************************************************************************************************************
NAME:    EC_IT143_W3.4_MM
PURPOSE: My script purpose is to answer the questions relate to SQL server

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     01/29/2025   MORONI       1. Built script for 3.4 Adventure Works—Create Answers
					 MIRANDOLLI		and for learning process
RUNTIME: 
32s

NOTES:  I built this script to display all questions created by users regarding
adventureworks2022  and I will answer each of them in sequence, each according to their
degree of difficulty.
     
******************************************************************************************************************/

SELECT GETDATE() AS my_date;

======================================================================================================================

                                  /*Mine own Marginal Complexity Q1*/

-- How many types of Payments Cards are and what's the top one most used?

-- A1:The payment card most used was the SuperiorCard with an amount of 4839 users.

--Table used for this Query:
--Select * From [Sales].[CreditCard]

Select a.CardType,
	Count(b.CardType) as CardQty
From [Sales].[CreditCard] as a
Inner Join [Sales].[CreditCard] as b
	On a.CreditCardID = b.CreditCardID
Group by a.CardType
Order By CardQty desc;


======================================================================================================================


                                       /*Marginal Complexity Q2*/ 

-- What is the list price of the product with the name 'Mountain-100 Black, 42'
-- A2: The ListPrice for this specific product is 3374,99.

--Table used for this Query:
--Select * from [Production].[Product];

Select 
	[Name],
	ListPrice
From [Production].[Product]
Where [Name] like 'Mountain-100 Black, 42'

======================================================================================================================


                                 /*Mine own Moderate Complexity Q3*/

-- What are the 5 best-selling products from the 2 stores with the highest sales?

-- A3: Best-selling products:
-- 1° Touring-1000 Yellow, 46
-- 2° Mountain-100 Silver, 42
-- 3° Touring-1000 Blue, 60
-- 4° Road-350-W Yellow, 48
-- 5° Mountain-100 Black, 38 

--Tables used for this Query:
--Store    c Select * From [Sales].[Store]            SalesPersonID     
--Bridge   b Select * From [Sales].[SalesOrderHeader] SalesPersonId / SalesOrderID    
--Sales    a Select * From [Sales].[SalesOrderDetail]                 SalesOrderID / ProductID   
--Products d Select * from [Production].[Product]					                   ProductID 

-- I notice that many of them has the very same income results, then there is more than 2
-- stores standing out

SELECT 
	c.[name],
	d.[Name],
	a.UnitPrice *
	a.OrderQty as TotalSales
FROM       [Sales].[SalesOrderDetail] as a
Inner Join [Sales].[SalesOrderHeader] as b
	ON a.SalesOrderID = b.SalesOrderID
Inner Join [Sales].[Store]            as c
	ON b.SalesPersonID = c.SalesPersonID
Inner Join [Production].[Product]	  as d
	ON a.ProductID = d.ProductID
Group By c.[name],
	d.[Name],
	a.UnitPrice,
	a.OrderQty
Order By TotalSales desc;
-- Now we can see the top 5 best products according with their sales:
-- Touring-1000 Yellow, 46  -  Mountain-100 Silver, 42  -  Touring-1000 Blue, 60 
-- Road-350-W Yellow, 48    -  Mountain-100 Black, 38
	
======================================================================================================================

                                    /*Moderate Complexity Q4*/

-- We would like to know what our most popular part bikes are. Could you provide us with the top 10 bestselling
-- bikes parts with how many are sold and their list and total order price?

-- A4: The top 10 bestselling parts from bikes are  Full-Finger Gloves with 44 Orders , Women's Mountain Shorts L and S
-- with an average of 40, and Classic Vest the total order for each one is around 600 and 1400.
-- Full-finger Gloves prices between 600 and 750 and Women's Mountain Shorts between 1200 and 1400.

--Tables used for this Query:
--Select * From [Production].[Product];
--Select * From [Sales].[SalesOrderDetail]

Select Top 10 
	a.[Name],
	b.OrderQty,
	b.OrderQty * b.UnitPrice as TotalSold
From [Production].[Product] as a
	Inner Join [Sales].[SalesOrderDetail] as b
		ON a.ProductID = b.ProductID
Group By 
	a.[Name],
	b.OrderQty,
	b.UnitPrice
Order By 
	b.OrderQty desc,
	b.UnitPrice desc;

=======================================================================================================================

                              /*Increased Complexity Q5*/

--  Q5 The executive team wants to identify the top 5 most popular products sold in 2023,
--  grouped by category. What are their names, categories, and total sales quantities?

-- A5: The Product's name are: Women's Mountain Short,L - Women's Mountain Short,S  - Women's Mountain Short,S 
-- and Racing Socks,L;
--  For the Categories they all match with the Clothing Category;
--  Their Sales Qty is: 31,4955 - 34,995 x3 and 4,495;
--  I have tried to inner join the category info but there isn't any column between tables that connect
-- the CategoryId with the Product itself.

--Table used for this Query:
--Select * From [Sales].[SalesOrderDetail];
--Select * from [Sales].[SalesOrderHeader];
--Select * from [Production].[Product];
--Select * from [Production].[ProductCategory];

-- This query is the Top Five products most Popular from all Years because there isn't any item sold in 2023
-- but down here i will be placing the answers using another year
Select Top 5 
	ProductID,
	sum(UnitPrice) as TotalSold,
	sum(OrderQty) as Popularity
From [Sales].[SalesOrderDetail]
	Group by ProductID
	Order by Popularity desc;

-- Then I Did it again now with year 2014, here is the products with more popularity within the year 2014:
Select Top 5 
	a.ProductID,
	a.OrderQty,
	c.[Name],
	Sum(a.UnitPrice) as TotalSold,
	Year(b.OrderDate) as Year2014
From [Sales].[SalesOrderDetail] as a
	Inner Join  [Sales].[SalesOrderHeader] as b
		On a.SalesOrderID = b.SalesOrderID
	Inner Join [Production].[Product] as c
		On a.ProductID = c.ProductID
Where 
	Year(OrderDate) = (2014)
Group by a.ProductID,
	Year(b.OrderDate),
	a.OrderQty,
	c.[Name]
Order by 
	a.OrderQty desc;

======================================================================================================================

                              /*Increased Complexity Q6*/ 

-- Q6  "An executive wants to understand customer retention." 
-- How many customers who purchased products last year also made a purchase this year?
-- Provide the percentage of retained customers.

-- A6: Here we can see customer orders from two separate years according to each customer's orders and
-- no customer purchased again between the two years surveyed, which are 2013 and 2014, the customers 
-- retained was equal to 0%

-- Tables used for this Query:
--Select * From[Sales].[SalesOrderHeader]
--Select * From[Person].[Person]

-- Here you can see the two years orders all in a single table. The Person's table that contains the names 
-- does not have a direct connection to connect the consumer ID within the SalesORderHeader, for this reason
-- I kept the consumer identification only by its ID because it is a unique piece of data that refers only
-- to a specific consumer.
Select 
	CustomerID,
	Count(SalesOrderID) as Orders,
	Year(OrderDate) as YearOrdered
From [Sales].[SalesOrderHeader]
Group By 
	SalesOrderID,
	Year(OrderDate),
	CustomerID
Order By 
	YearOrdered Desc

-- Here we see that there are no matches between the two years consulted.
Select 
	a.CustomerID, 
	Count(a.SalesOrderID) as Orders,
	Year(a.OrderDate) as OrdersFrom2014,
	Year(b.OrderDate) as OrdersFrom2013
From [Sales].[SalesOrderHeader] as a
Inner Join [Sales].[SalesOrderHeader] as b
	On a.OrderDate = b.CustomerID
Where 
	Year(a.OrderDate) in (2014) 
	And Year(b.OrderDate) in (2013)
Group by 
	a.SalesOrderID,
	Year(a.OrderDate),
	Year(b.OrderDate), 
	a.CustomerID;
-- The percentage of retained customers is equal to 0%

======================================================================================================================

                                       /*Metadada Q7*/

-- Can you provide a list of tables in AdventureWorks that contain a column named "ProductKey"
-- and belong to the "Production" schema?

-- A7: I did't found the ProductKey but I did found some variations in the column_name

Select Table_Schema, Column_Name FROM information_schema.Columns
Where Table_Schema = 'Production' AND Column_Name Like 'Product%'
Order By Column_Name



======================================================================================================================

                                        /*Metadata Q8*/


--What are the table names and column definitions for tables in the "Production" schema?

--A8: There is more than one, 28 tables were found with 210 columns different from each other

--This first code shows the 28 distinct tables
Select Table_Name
From Information_schema.columns
Where Table_Schema = 'Production'
Group BY Table_Name

-- This second one allows us to see the columns and their respective names,
-- we have 210 different ones in total.
Select 
	Table_Name,
	Column_Name 
From Information_schema.columns
Where Table_Schema = 'Production'
Group BY
	Table_Name,
	Column_Name 

