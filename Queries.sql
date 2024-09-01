-- Write an SQL query to generate a daily report of the total revenue for a specific date.
SELECT DATE(order_date) AS OrderDate, SUM(total_amount) AS DailyRevenue
FROM Orders
WHERE DATE(order_date) = '2023-10-21'
GROUP BY DATE(order_date);

SELECT SUM(total_amount) AS DailyRevenue
FROM Orders
WHERE DATE(order_date) = '2023-10-11';

 -- Write an SQL query to generate a monthly report of the top-selling products in a given month.
 SELECT DATE_FORMAT(order_date, '%Y-%m') AS Month, product_id, 
(SELECT PRODUCT_NAME FROM FROM PRODUCT P WHRE P.PRODUCT_ID = OD.product_id) , SUM(quantity) AS TotalQuantity
FROM OrderDetails OD 
JOIN ORDER O ON O.ORDER_ID = OD.ORDER_ID
 WHERE DATE_FORMAT(order_date, '%Y-%m') = '2023-10'
GROUP BY DATE_FORMAT(order_date, '%Y-%m'), product_id
ORDER BY TotalQuantity DESC;

-- Write a SQL query to retrieve a list of customers who have placed orders totaling more than $500 in the past month. 
--  Include customer names and their total order amounts. 
SELECT CONCAT(C.first_name, ' ', C.last_name) AS CustomerName, SUM(O.total_amount) AS TotalOrderAmount
FROM Customers AS C
JOIN Orders AS O ON C.customer_id = O.customer_id
WHERE O.order_date = current_date - interval '1 month'
GROUP BY C.customer_id, CustomerName
HAVING SUM(O.total_amount) > 500;

-- Write a SQL query to search for all products with the word "camera" in either the product name or description.
select P.name
from products as P
where P.name like '%camera%'
or P.description like '%camera%'
