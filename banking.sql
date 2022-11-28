3.Write a SQL statement to list all Customers sorted by Customer Name.
Query needs to return CustomerID & CustomerName

SELECT CustomerID, CustomerName
FROM Customers 
ORDER BY CustomerName ASC;

4.Write a SQL statement to add a new Customer called "Bank of America" to the Customers table.
INSERT INTO Customers (CustomerID, CustomerName) 
VALUES (103, 'Bank of America');

5.Write a SQL Statement to rename "Wells" to "Wells Fargo" in the Customers table.

UPDATE Customers 
SET CustomerName='Wells Fargo'
WHERE CustomerID=101;

6.Write a SQL statement to list ALL Customers and the number of orders placed by each, sorted by the Customer with the most number of order.
- Query needs to return CustomerID, CustomerName and a column with the number of orders.

SELECT c.CustomerID, c.CustomerName, COUNT(o.OrderID) AS Number_of_Orders 
FROM Customers c INNER JOIN Orders o
ON c.CustomerID=o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY COUNT(o.OrderID) DESC;


7.Write a SQL statement to find all rows from the Orders table where there are no related rows in the OrderHistory table.

SELECT * 
FROM Orders o LEFT JOIN OrderHistory oh
ON o.OrderID=oh.OrderID
WHERE oh.HistoryID IS NULL;


8.Write a SQL statement to remove all rows identified in Question #7.
DELETE o
FROM Orders o LEFT JOIN OrderHistory oh
ON o.OrderID=oh.OrderID
WHERE oh.HistoryID IS NULL;



9.Write a SQL statement to list all Orders created in the first quarter of 2021 and the current Status of the Order.
Query needs to return CustomerID, CustomerName, OrderID & StatusName.

SELECT c.CustomerID, c.CustomerName, o.OrderID, s.StatusName
FROM Customers c INNER JOIN Orders o 
ON c.CustomerID=o.CustomerID INNER JOIN OrderHistory oh 
ON o.OrderID=oh.OrderID INNER JOIN StatusID s
ON oh.StatusID=s.StatusID
WHERE MONTH(o.CreateDate) <= 3 AND YEAR (o.CreateDate) = 2021; 




10.Write a SQL statement to list Customers and the number of orders placed by each, sorted by the Customer with the most number of order.
- Query needs to return CustomerID, CustomerName and a column with the highest number of orders.
- Only include Customers with more than 1 order.

SELECT * 
FROM (SELECT c.CustomerID, c.CustomerName, 
	COUNT(o.OrderID) AS 'Highest Number of Orders'
FROM Customers c INNER JOIN Orders o 
ON c.CustomerID=o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY COUNT(o.OrderID) DESC)
FETCH FIRST 1 ROW ONLY;






11.Write a SQL statement which will create a temp table called "Employees". Columns in the new table should be EmployeeID, EmployeeName and HireDate.
- EmployeeID should be an Identity column and the Primary Key of the table.
- EmployeeName should not allow more than 50 characters.  
- HireDate should have a default value allowing each new row to have a timestamp of when the row was created.

CREATE TABLE #Employees 
(
EmployeeID INT NOT NULL PRIMARY KEY, 
EmployeeName VARCHAR(50),
HireDate DATETIME);





12.Write a SQL statement which will populate the Employees temp table with data found in the EmployeeID and EmployeeName columns found in the OrderHistory table.
Enter your answer

INSERT INTO #Employees 
SELECT EmployeeID, EmployeeName
FROM OrderHistory; 



13.Write a SQL statement which will create a new row in the Employees temp table.
- EmployeeeID will be 50
- EmployeeName will be "Michael"
- HireDate will be March 24, 2005

INSERT INTO #Employees (EmployeeID, EmployeeName, HireDate)
VALUES (50,'Michael',03/24/2005);



14.Write a SQL statement to determine if any rows exist in a table named OrderArchive (table is not included in sample table structure diagram).
SELECT COUNT(1)
FROM OrderArchive;


