<p align="center">
    <h1 align="center">e-commerce-Database-Design</h1>
</p>
<p align="center">
    <em>This repo is for our hands dirty in database analysis and design from 'Practical Web Database Design Book' 📖</em>
  </br>
   <em> and apply that in e-commerce system </em>
</p>

## 🔗 Quick Links

---
## 📍 E-Commerce Overview
![image](https://github.com/user-attachments/assets/269f4d08-ff2a-4524-b882-287dd6135337)

For this repo, we will work on :

- Drawing the ERD diagram of the sample schema.
- Creating a DB schema script with the following entities.
- Identifying the relationships between entities.
- Writing SQL queries for various reports.
- Applying denormalization mechanisms.
---
## 📊 ER Diagram of this busines model
![image](https://github.com/user-attachments/assets/ef0b4953-3c7f-441e-804e-bd2dcdfb6c15)
---
## 🔗 Relationships Between Entities
![image](https://github.com/user-attachments/assets/90261dfc-ff9a-4155-af0b-200a6458883a)
---
## 📄 Create the DB Schema Script
``` mysql
create schema if not exists ecommerce;

use ecommerce;

drop schema ecommerce;

DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS OrderDetails; 


CREATE TABLE Categories (
 category_id SERIAL PRIMARY KEY,
 name VARCHAR(255) NOT NULL
)
-- Create the Products table
CREATE TABLE Products (
 product_id SERIAL PRIMARY KEY,
 category_id INT,
 name VARCHAR(255) NOT NULL,
 description TEXT,
 price DECIMAL(10, 2) NOT NULL,
 stock_quantity INT NOT NULL,
 FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
-- Create the Customers table
CREATE TABLE Customers (
 customer_id SERIAL PRIMARY KEY,
 first_name VARCHAR(50) NOT NULL,
 last_name VARCHAR(50) NOT NULL,
 email VARCHAR(100) NOT NULL UNIQUE,
 password VARCHAR(255) NOT NULL
);
-- Create the Orders table
CREATE TABLE Orders (
 order_id SERIAL PRIMARY KEY,
 customer_id INT,
 order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 total_amount DECIMAL(10, 2) NOT NULL,
 FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
-- Create the OrderDetails table
CREATE TABLE OrderDetails (
 order_detail_id SERIAL PRIMARY KEY,
 order_id INT,
 product_id INT,
 quantity INT NOT NULL,
 unit_price DECIMAL(10, 2) NOT NULL,
 FOREIGN KEY (order_id) REFERENCES Orders(order_id),
 FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
```
---
## 📅 SQL query to generate a daily report of the total revenue for a specific date.
```mysql
SELECT DATE(order_date) AS OrderDate, SUM(total_amount) AS DailyRevenue
FROM Orders
WHERE DATE(order_date) = '2023-10-21'
GROUP BY DATE(order_date);

SELECT SUM(total_amount) AS DailyRevenue
FROM Orders
WHERE DATE(order_date) = '2023-10-11';
```
## 📅 SQL query to generate a monthly report of the top-selling products in a given month.
```mysql
SELECT
DATE_FORMAT(order_date, '%Y-%m') AS Month, product_id, 
(SELECT PRODUCT_NAME FROM FROM PRODUCT P WHRE P.PRODUCT_ID = OD.product_id),
SUM(quantity) AS TotalQuantity
FROM OrderDetails OD 
JOIN ORDER O ON O.ORDER_ID = OD.ORDER_ID
 WHERE DATE_FORMAT(order_date, '%Y-%m') = '2023-10'
GROUP BY DATE_FORMAT(order_date, '%Y-%m'), product_id
ORDER BY TotalQuantity DESC;
```
## 📅 SQL query to retrieve a list of customers who have placed orders totaling more than $500 in the past month. 
```mysql
SELECT CONCAT(C.first_name, ' ', C.last_name) AS CustomerName, SUM(O.total_amount) AS TotalOrderAmount
FROM Customers AS C
JOIN Orders AS O ON C.customer_id = O.customer_id
WHERE O.order_date = current_date - interval '1 month'
GROUP BY C.customer_id, CustomerName
HAVING SUM(O.total_amount) > 500;
```
## 📅 SQL query to search for all products with the word "camera" in either the product name or description.
```mysql
select  p.product_id , P.name
from products as P
where P.name like '%camera%'
or P.description like '%camera%'
```

## 📅 query to suggest popular products in the same category for the same author, excluding the Purchsed product from the recommendations?
```mysql

```
---
## 📚 Special Case :: Customer want to look for tha past order history 
#### 1- Traditional Approach
```mysql
    select  *
    from Order AS O
    JOIN Customer AS C ON O.customer_id = C.customer_id
    JOIN OrderDeatils AS OD on O.order_id = OD.order_id
    where C.customer_id = 122
```
note : in large scale od data this approach will be heavy and take alot of time to execute 
---
#### 2- Using Denormalization Techniques
rather than denormalize the entire database , a more common technique is to pre-compute the result of the join for all customers ,
then copy that result into a separata denomalized table 
so we might create a table that looked something like this:

```mysql
CREATE TABLE SaleHistory (
 customer_id INT ,
 first_name VARCHAR(50) NOT NULL,
 last_name VARCHAR(50) NOT NULL,
 address VARCHAR(100),
 description VARCHAR(100),
 price INT,
 category_id INT,
 name VARCHAR(255) NOT NULL,
 description TEXT,
 price DECIMAL(10, 2) NOT NULL,
 order_id INT NOT NULL,
 order_detail_id SERIAL PRIMARY KEY ,
 order_date TIMESTAMP NOT NULL,
 quantity INT NOT NULL,
 amount DECIMAL(10, 2) NOT NULL
);
```
All we need to do now is ensure that we refresh the SALE_HISTORY table at regular 
intervals to capture new sales. We can achieve this using something called a trigger
Note: Trigger will be triggered on 
-  Insert new record
-  Update existing record



