-- Database: ecommerce

-- DROP DATABASE IF EXISTS ecommerce;

CREATE DATABASE ecommerce
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
-- Create the Categories table
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
