--------------------------------------------------------------------------
-- Q1.
--------------------------------------------------------------------------
SELECT customername, addressline1, addressline2, city, state, postalcode
FROM 	customers
WHERE 	creditlimit > 100000
AND 	country = 'USA';

--------------------------------------------------------------------------
-- Q2.
--------------------------------------------------------------------------
SELECT   c.customername, COUNT(o.status) AS Count_Shipped
FROM     customers c INNER JOIN orders o 
               ON c.customernumber = o.customernumber
WHERE    c.country = 'France'
AND      o.status = 'Shipped'
GROUP BY c.customername;

--------------------------------------------------------------------------
-- Q3.
--------------------------------------------------------------------------
SELECT  pl.productline, COUNT(p.productline) AS Count_Products,    ROUND(AVG(p.MSRP), 2) AS Average_MSRP
FROM     productlines pl INNER JOIN products p 
                ON pl.productline = p.productline
GROUP BY pl.productline; 

--------------------------------------------------------------------------
-- Q4.
--------------------------------------------------------------------------
SELECT p.productname, p.productline, p.msrp
FROM   products p
WHERE  p.msrp = (SELECT MAX(p.msrp) FROM products p);

--------------------------------------------------------------------------
-- Q5.
--------------------------------------------------------------------------
SELECT c.customername, e.lastname, e.firstname
FROM   (offices o INNER JOIN employees e
           ON o.officecode = e.officecode)
        INNER JOIN customers c 
           ON  e.employeenumber = c.salesrepemployeenumber 
WHERE   e.jobtitle = 'Sales Rep'
AND     o.territory = 'EMEA'
AND     c.country = o.country;

--------------------------------------------------------------------------
-- Q6.
--------------------------------------------------------------------------
SELECT    c.customername, SUM(od.quantityordered*od.priceeach) 
     AS Total_Order_Amount
FROM     (orders o INNER JOIN orderdetails od 
             ON o.ordernumber = od.ordernumber) 
          INNER JOIN customers c 
             ON o.customernumber = c.customernumber
WHERE     c.country IN ('Finland','Denmark','Sweden')
AND       o.status='Shipped'
GROUP BY  c.customername;

--------------------------------------------------------------------------
-- Q7.
--------------------------------------------------------------------------
SELECT   e.lastname, e.firstname, 
   COUNT(e.employeenumber) AS Report_Count
FROM     employees e INNER JOIN employees m
             ON e.employeenumber = m.reportsto
WHERE    e.jobtitle LIKE ('*Manager*')
GROUP BY e.lastname, e.firstname;

--------------------------------------------------------------------------
-- Extra Credit Query.
--------------------------------------------------------------------------
SELECT c.customername, ROUND(o.amt - p.amt, 2) AS Net_Balance
FROM (customers c 
INNER JOIN (SELECT ot.customernumber, 
                   SUM(od.quantityordered*od.priceeach) AS amt
            FROM orders ot
            INNER JOIN orderdetails od 
            ON ot.ordernumber = od.ordernumber
            GROUP BY ot.customernumber)
          o ON o.customernumber = c.customernumber)
INNER JOIN (SELECT customernumber, SUM(amount) AS amt
            FROM payments
            GROUP BY customernumber)
          p ON p.customernumber = c.customernumber;
