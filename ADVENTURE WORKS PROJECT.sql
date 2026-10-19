
CREATE DATABASE ADVENTUREWORKS;
USE ADVENTUREWORKS;
SHOW tables;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- QUESTION 0

CREATE TABLE SALES AS
SELECT * FROM factinternetsales
UNION ALL
SELECT * FROM fact_internet_sales_new;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- QUESTION 1

SELECT s.*,
p.EnglishProductName AS ProductName FROM sales s 
LEFT JOIN dimproduct p ON s.ProductKey = p.ProductKey;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- QUESTION 2

SELECT
    s.*, CONCAT(c.FirstName,' ',c.LastName) AS CustomerFullName, p.ListPrice AS UnitPrice
FROM sales s LEFT JOIN dimcustomer c
ON s.CustomerKey = c.CustomerKey LEFT JOIN dimproduct p
ON s.ProductKey = p.ProductKey;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- QUESTION 3

SELECT OrderDateKey, STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate FROM sales;

-- QUESTION 3 (A) -- YEAR -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS Year FROM sales;

-- QUESTION 3 (B) -- MONTH NUMBER  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthNo FROM sales;

-- QUESTION 3 (C) -- MONTH FULL NAME ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT MONTHNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName FROM sales;

-- QUESTION 3 (D) -- QUARTER --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT CONCAT('Q', QUARTER(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))) AS Quarter
FROM sales;

-- QUESTION 3 (E) -- YEAR MONTH  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DATE_FORMAT(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'),'%Y-%b') AS YearMonth
FROM sales;

-- QUESTION 3 (F) -- WEEK DAY NUMBER -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DAYOFWEEK(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS WeekdayNo
FROM sales;

-- QUESTION 3 (G) -- WEEK DAY NAME ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DAYNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS WeekdayName
FROM sales;

-- QUESTION 3 (H) -- FINANCIAL MONTH  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT CASE
	WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) >= 4
	THEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) - 3
	ELSE MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) + 9
END AS FinancialMonth FROM sales;

-- QUESTION 3 (I) -- FINANCIAL QUARTER  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT CASE
	WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 4 AND 6 THEN 'Q1'
	WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 7 AND 9 THEN 'Q2'
	WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 10 AND 12 THEN 'Q3'
ELSE 'Q4'
 END AS FinancialQuarter FROM sales;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- QUESTION 4      SALES AMOUNT

SELECT UnitPrice, OrderQuantity, UnitPriceDiscountPct,
UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct) 
AS SalesAmount
FROM sales;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- QUESTION 5      PRODUCTION COST

SELECT ProductStandardCost, OrderQuantity,
 (ProductStandardCost * OrderQuantity) 
AS ProductionCost FROM sales;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- QUESTION 6   PROFIT

SELECT SalesAmount, TotalProductCost,
(SalesAmount - TotalProductCost) 
AS Profit FROM sales;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- QUESTION 10 -- QUARTER WISE SALES PERCENTAGE

SELECT CONCAT('Q', QUARTER(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))) 
AS Quarter,
ROUND(SUM(SalesAmount) * 100 / (SELECT SUM(SalesAmount) FROM sales), 2) 
AS SalesPercentage FROM sales
GROUP BY Quarter
ORDER BY Quarter;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- QUESTION 12 -- TOP 5 CUSTOMERS BY SALES

SELECT CONCAT(c.FirstName,' ',c.LastName) 
AS CustomerName, SUM(s.SalesAmount) AS TotalSales
FROM sales s JOIN dimcustomer c ON s.CustomerKey = c.CustomerKey
GROUP BY CustomerName
ORDER BY TotalSales DESC
LIMIT 5;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------