CREATE DATABASE superstore_db;
USE superstore_db;
CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    region VARCHAR(50)
);
CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(200)
);
CREATE TABLE orders (
    order_id VARCHAR(20),
    order_date DATE,
    order_month VARCHAR(7), -- Format: YYYY-MM
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    product_id VARCHAR(20),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(4,2),
    profit DECIMAL(10,2),
    PRIMARY KEY (order_id, product_id), -- composite key because one order can have multiple products
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE superstore_staging (
    order_id VARCHAR(20),
    order_date DATE,
    order_month VARCHAR(7),
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(20),
    product_id VARCHAR(20),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(200),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(4,2),
    profit DECIMAL(10,2)
);
