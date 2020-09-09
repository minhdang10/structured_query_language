---------------------------------------------------------------------------
-- Query 2
---------------------------------------------------------------------------
SELECT  TO_CHAR (o.order_date, 'YYYY-MM') AS Order_Month,
        NVL (s.prov_state, s.city) AS State_Province,
        SUM (od.quantity * od.extended_price) AS Total_Dollars
FROM   (camping.orderdetail od INNER JOIN camping.customerorder o
              ON od.order_no = o.order_no)
        INNER JOIN camping.customersite s ON o.cust_no = s.cust_no
			AND o.site_no = s.site_no
WHERE 	   od.returned = 'N'
GROUP BY      TO_CHAR (o.order_date, 'YYYY-MM'),
   NVL (s.prov_state, s.city)
ORDER BY      TO_CHAR (o.order_date, 'YYYY-MM'); 

---------------------------------------------------------------------------
-- Query 3
---------------------------------------------------------------------------
SELECT  RANK() OVER (ORDER BY SUM (od.quantity * od.extended_price) DESC) 
        AS Total_Dollar_Rank,
       TO_CHAR (o.order_date, 'YYYY-MM') AS Order_Month,
       p.product_name, 
       SUM (od.quantity * od.extended_price) AS Total_Dollars
FROM ((camping.product p INNER JOIN camping.orderdetail od 
                ON p.prod_no = od.prod_no) 
     INNER JOIN camping.customerorder o ON od.order_no = o.order_no)
     INNER JOIN camping.rep r ON o.rep_no = r.rep_no 
WHERE 	od.returned = 'N'
AND 		r.rep_sales_17 >= r.rep_quota_17
GROUP BY 	TO_CHAR (o.order_date, 'YYYY-MM'), p.product_name;

---------------------------------------------------------------------------
-- Query 4
---------------------------------------------------------------------------
SELECT      c.customer_name AS Customer_Name, 
            s.prov_state AS State_Province,
            SUM (od.quantity * od.extended_price) AS Total_Dollars
FROM    ((((camping.customer c INNER JOIN camping.customersite s
            	ON c.cust_no = s.cust_no)
      INNER JOIN camping.country ct ON s.country_cd = ct.country_cd)
      INNER JOIN camping.customerorder o ON s.cust_no = o.cust_no
AND s.site_no = o. site_no)
 	 INNER JOIN camping.orderdetail od ON o.order_no = od.order_no)
      INNER JOIN camping.product p ON od.prod_no = p.prod_no
WHERE	     p.prod_type IN ('Outdoor Products', 'Environmental Line')
AND 	     od.returned = 'N'
AND 	     ct.country_name = 'Canada'  
GROUP BY  	  c.customer_name, s.prov_state; 

---------------------------------------------------------------------------
-- Query 5
---------------------------------------------------------------------------
SELECT p.product_name, 
            ROUND(SUM((od.extended_price - p.prod_cost)/od.extended_price),2) 
 	AS Profit_Margin
FROM (camping.product p INNER JOIN camping.orderdetail od
          		ON p.prod_no = od.prod_no)
     		INNER JOIN camping.customerorder o 
ON od.order_no = o.order_no
WHERE 	o.channel = 'Internet Sales' 
AND 		od.returned = 'N'
GROUP BY 	p.product_name	
ORDER BY 	2 DESC
FETCH FIRST 1 ROW ONLY;

---------------------------------------------------------------------------
-- Query 6
---------------------------------------------------------------------------
SELECT 	c.cust_no, c.customer_name, 
SUM(od.extended_price * od.quantity) AS Total_Sales, 
        	COUNT(o.cust_no) AS Order_Count, 
		(SUM(od.extended_price * od.quantity)/COUNT(o.cust_no))
		AS Dollar_Per_Order 
FROM camping.customer c INNER JOIN camping.customersite s 
            ON c.cust_no = s.cust_no
        INNER JOIN camping.customerorder o 
            ON s.cust_no = o.cust_no
        INNER JOIN camping.orderdetail od 
            ON o.order_no = od.order_no
WHERE 	od.returned = 'N'
GROUP BY 	c.cust_no, c.customer_name, o.cust_no
ORDER BY 	Order_Count DESC
--ORDER BY Total_Sales DESC
FETCH FIRST 5 ROWS ONLY;

---------------------------------------------------------------------------
-- Query 7
---------------------------------------------------------------------------
SELECT Order_Month, 
ROUND((Order_Sales-Order_Prior_Sales)/(Order_Prior_Sales),2) 
AS Sales_Percentage_Change
FROM ( SELECT TO_CHAR(o.order_date, 'YYYY-MM') AS Order_Month,
       	   SUM(od.extended_price*od.quantity) AS Order_Sales,
              LAG (SUM(od.extended_price*od.quantity), 1, 
SUM(od.extended_price*od.quantity)) 
   	OVER(ORDER BY TO_CHAR(o.order_date, 'YYYY-MM')) 
              		AS Order_Prior_Sales
       FROM camping.orderdetail od 
INNER JOIN camping.customerorder o
                		ON od.order_no = o.order_no
       GROUP BY 	TO_CHAR(o.order_date, 'YYYY-MM')
       ORDER BY 	TO_CHAR(order_date, 'YYYY-MM')
      )
WHERE 	Order_Prior_Sales > 0
AND 		od.returned = 'N'
ORDER BY 	2 DESC
FETCH FIRST 1 ROW ONLY;

---------------------------------------------------------------------------
-- Query 8
---------------------------------------------------------------------------
CREATE VIEW Camping_DB
AS 
SELECT *
FROM    camping.product p NATURAL JOIN
        camping.orderdetail od NATURAL JOIN 
        camping.customerorder o NATURAL JOIN
        camping.rep r NATURAL JOIN
        camping.customersite s NATURAL JOIN
        camping.customer c NATURAL JOIN 
        camping.country ct NATURAL JOIN 
        camping.branch b;
