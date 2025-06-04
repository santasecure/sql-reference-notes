-- 📚 SQL Reference Guide | Created by Kristie | 2025
-- SQL Modules 1–9 | University of Cincinnati

-- ========================================
-- CHEAT SHEET
-- ========================================

-- SQL Statement Types
-- DDL (Data Definition Language):
--     CREATE, ALTER, DROP, TRUNCATE, RENAME
-- DML (Data Manipulation Language):
--     SELECT, INSERT, UPDATE, DELETE, MERGE
-- DCL (Data Control Language):
--     GRANT, REVOKE
-- TCL (Transaction Control Language):
--     COMMIT, ROLLBACK, SAVEPOINT

-- Basic Syntax Patterns
SELECT columns
FROM table
WHERE condition
ORDER BY column ASC|DESC;

-- JOIN Syntax
SELECT columns
FROM table1
INNER JOIN table2 ON table1.id = table2.id;

-- GROUP BY Syntax
SELECT column, COUNT(*)
FROM table
GROUP BY column;

-- INSERT Syntax
INSERT INTO table_name (col1, col2)
VALUES (val1, val2);

-- UPDATE Syntax
UPDATE table_name
SET column = value
WHERE condition;

-- DELETE Syntax
DELETE FROM table_name
WHERE condition;

-- Common Operators
-- =, <>, >, <, >=, <=, BETWEEN, IN, LIKE, IS NULL

-- Aggregate Functions
-- COUNT(), SUM(), AVG(), MIN(), MAX()

-- String Functions
-- LEN(), LEFT(), RIGHT(), SUBSTRING(), CONCAT(), UPPER(), LOWER()

-- Date/Time Functions
-- GETDATE(), DATEADD(), DATEDIFF(), EOMONTH(), YEAR(), MONTH(), DAY()

-- Window/Ranking Functions
-- ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE()

-- Best Practices
-- - Use meaningful aliases
-- - Avoid SELECT *
-- - Indent SQL properly
-- - Comment complex code
-- - Use transactions for bulk changes

-- Pro Tips
-- - Always test DELETE/UPDATE with SELECT first
-- - Prefer explicit JOINs
-- - Use CTEs (WITH) for readability

-- ========================================
-- Module 1: Intro to Relational Databases and SQL
-- ========================================

-- Creating a Database
CREATE DATABASE Northwind;

-- Creating a Table
CREATE TABLE Orders (
    OrderID int PRIMARY KEY IDENTITY(1,1),
    CustomerID nchar(5) NULL,
    OrderDate datetime NULL,
    Freight money NULL DEFAULT(0)
);

-- Simple SELECT
SELECT * FROM Customers;

-- INSERT Data
INSERT INTO Customers (CustomerID, CompanyName)
VALUES ('ALFKI', 'Alfreds Futterkiste');

-- UPDATE Data
UPDATE Orders
SET Freight = 10
WHERE OrderID = 10244;

-- DELETE Data
DELETE FROM Orders
WHERE OrderID = 10244;

-- Creating a VIEW
CREATE VIEW USAEmployees AS
SELECT LastName, FirstName, Country
FROM Employees
WHERE Country = 'USA';

-- Creating a Stored Procedure
CREATE PROCEDURE LondonEmployees AS
SELECT LastName, FirstName, City FROM Employees
WHERE City = 'London';

-- ========================================
-- Module 2: SQL Server Management Studio (SSMS) Basics
-- ========================================

-- Connect using Windows Authentication or SQL Server Authentication
-- Attach Database
-- Backup Database
-- Set Compatibility Level

-- ========================================
-- Module 3: Basic SELECT Statements
-- ========================================

-- SELECT specific columns
SELECT CompanyName, City FROM Customers;

-- SELECT with WHERE clause
SELECT * FROM Customers
WHERE Country = 'USA';

-- SELECT DISTINCT
SELECT DISTINCT Country FROM Customers;

-- SELECT Calculated Column
SELECT UnitPrice * Quantity AS TotalPrice
FROM [Order Details];

-- SELECT with TOP
SELECT TOP 5 * FROM Customers;

-- WHERE with LIKE
SELECT CompanyName
FROM Customers
WHERE CompanyName LIKE 'A%';

-- ORDER BY multiple columns
SELECT CompanyName, ContactName
FROM Customers
ORDER BY Country ASC, City DESC;

-- OFFSET-FETCH for Pagination
SELECT CompanyName
FROM Customers
ORDER BY CompanyName
OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY;

-- ========================================
-- Module 4: JOINs and Unions
-- ========================================

-- INNER JOIN
SELECT Customers.CustomerName, Orders.OrderDate
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

-- LEFT JOIN
SELECT Departments.DeptName, Employees.LastName
FROM Departments
LEFT JOIN Employees ON Departments.DeptNo = Employees.DeptNo;

-- UNION
SELECT City FROM Customers WHERE Country = 'USA'
UNION
SELECT ShipCity FROM Orders WHERE ShipCountry = 'USA';

-- EXCEPT
SELECT CustomerFirst FROM Customers
EXCEPT
SELECT FirstName FROM Employees;

-- INTERSECT
SELECT CustomerFirst FROM Customers
INTERSECT
SELECT FirstName FROM Employees;

-- ========================================
-- Module 5: Summary Queries
-- ========================================

-- Aggregate Functions with GROUP BY
SELECT CustomerID, COUNT(*) AS OrdersCount
FROM Orders
GROUP BY CustomerID;

-- GROUP BY and HAVING
SELECT EmployeeID, COUNT(OrderID) AS NumberOfOrders
FROM Orders
GROUP BY EmployeeID
HAVING COUNT(OrderID) > 50;

-- ROLLUP
SELECT CustomerID, COUNT(*) AS OrdersCount
FROM Orders
GROUP BY CustomerID WITH ROLLUP;

-- CUBE
SELECT CustomerID, COUNT(*)
FROM Orders
GROUP BY CustomerID WITH CUBE;

-- GROUPING SETS
SELECT Region, City, COUNT(*)
FROM Customers
GROUP BY GROUPING SETS ((Region, City), PostalCode, ());

-- OVER Clause for windowed aggregation
SELECT OrderID, Freight,
    SUM(Freight) OVER (PARTITION BY CustomerID) AS TotalFreight
FROM Orders;

-- ========================================
-- Module 6: Subqueries and CTEs
-- ========================================

-- Simple Subquery in WHERE clause
SELECT OrderID, Freight
FROM Orders
WHERE Freight > (SELECT AVG(Freight) FROM Orders);

-- Subquery in FROM clause
SELECT AVG(TotalAmount) AS AverageOrder
FROM (
    SELECT SUM(UnitPrice * Quantity) AS TotalAmount
    FROM [Order Details]
    GROUP BY OrderID
) AS OrderTotals;

-- EXISTS Subquery
SELECT CustomerID
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
);

-- Common Table Expression (CTE)
WITH SalesCTE AS (
    SELECT CustomerID, SUM(Freight) AS TotalFreight
    FROM Orders
    GROUP BY CustomerID
)
SELECT * FROM SalesCTE
WHERE TotalFreight > 500;

-- ========================================
-- Module 7: INSERT, UPDATE, DELETE, MERGE
-- ========================================

-- INSERT INTO ... VALUES
INSERT INTO Employees (FirstName, LastName)
VALUES ('John', 'Doe');

-- INSERT INTO ... SELECT
INSERT INTO ArchiveOrders (OrderID, OrderDate)
SELECT OrderID, OrderDate
FROM Orders
WHERE OrderDate < '2020-01-01';

-- UPDATE
UPDATE Employees
SET Title = 'Manager'
WHERE LastName = 'Smith';

-- DELETE
DELETE FROM Orders
WHERE OrderDate < '2019-01-01';

-- MERGE (UPSERT)
MERGE INTO TargetTable AS Target
USING SourceTable AS Source
ON Target.ID = Source.ID
WHEN MATCHED THEN
    UPDATE SET Target.Name = Source.Name
WHEN NOT MATCHED THEN
    INSERT (ID, Name) VALUES (Source.ID, Source.Name);

-- ========================================
-- Module 8: Data Types and Conversion
-- ========================================

-- CAST Function
SELECT CAST(OrderDate AS VARCHAR) AS OrderDateText
FROM Orders;

-- CONVERT Function
SELECT CONVERT(VARCHAR, OrderDate, 101) AS OrderDateText
FROM Orders;

-- TRY_CONVERT Function
SELECT TRY_CONVERT(DATE, '2021-13-01') AS TryDate;

-- STR, CHAR, ASCII, UNICODE
SELECT STR(1234.5678, 7, 1) AS FormattedNumber;
SELECT CHAR(65) AS CharA;
SELECT ASCII('A') AS AsciiA;
SELECT UNICODE('A') AS UnicodeA;

-- ========================================
-- Module 9: Functions
-- ========================================

-- String Functions
SELECT LEN('SQL Server') AS Length;
SELECT LEFT('SQL Server', 3) AS Left3;
SELECT RIGHT('SQL Server', 3) AS Right3;
SELECT SUBSTRING('SQL Server', 1, 3) AS Substring;
SELECT CONCAT('SQL', 'Server') AS Concatenated;
SELECT UPPER('sql') AS Uppercase;
SELECT LOWER('SQL') AS Lowercase;

-- Numeric Functions
SELECT ROUND(123.4567, 2) AS Rounded;
SELECT ABS(-123) AS AbsoluteValue;
SELECT CEILING(123.45) AS CeilingValue;
SELECT FLOOR(123.45) AS FloorValue;

-- Date/Time Functions
SELECT GETDATE() AS CurrentDateTime;
SELECT DATEADD(day, 1, GETDATE()) AS Tomorrow;
SELECT DATEDIFF(day, '2024-01-01', GETDATE()) AS DaysSince;
SELECT EOMONTH(GETDATE()) AS EndOfMonth;

-- CASE Function
SELECT OrderID, 
    CASE WHEN Freight > 100 THEN 'High' ELSE 'Low' END AS FreightCategory
FROM Orders;

-- IIF Function
SELECT IIF(Freight > 100, 'High', 'Low') AS FreightCategory
FROM Orders;

-- COALESCE Function
SELECT COALESCE(NULL, NULL, 'Default') AS FirstNonNull;

-- ROW_NUMBER Function
SELECT ROW_NUMBER() OVER (ORDER BY CompanyName) AS RowNum, CompanyName
FROM Customers;

-- RANK and DENSE_RANK Functions
SELECT RANK() OVER (ORDER BY Freight) AS FreightRank,
       DENSE_RANK() OVER (ORDER BY Freight) AS DenseFreightRank
FROM Orders;

-- NTILE Function
SELECT NTILE(4) OVER (ORDER BY Freight) AS Quartile, OrderID
FROM Orders;

-- FIRST_VALUE and LAST_VALUE Functions
SELECT FIRST_VALUE(Freight) OVER (ORDER BY OrderDate ASC) AS FirstFreight,
       LAST_VALUE(Freight) OVER (ORDER BY OrderDate ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastFreight
FROM Orders;

-- LAG and LEAD Functions
SELECT OrderID, Freight,
    LAG(Freight, 1) OVER (ORDER BY OrderID) AS PrevFreight,
    LEAD(Freight, 1) OVER (ORDER BY OrderID) AS NextFreight
FROM Orders;

-- PERCENT_RANK and CUME_DIST Functions
SELECT PERCENT_RANK() OVER (ORDER BY Freight) AS PercentRank,
       CUME_DIST() OVER (ORDER BY Freight) AS CumeDist
FROM Orders;

-- DONE!
