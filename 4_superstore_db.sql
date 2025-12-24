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
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/superstore.csv'
INTO TABLE superstore_staging
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) FROM superstore_staging;
SELECT*FROM superstore_staging
LIMIT 20;
INSERT INTO customers (
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    region
)
SELECT
    customer_id,
    MAX(customer_name),
    MAX(segment),
    MAX(country),
    MAX(city),
    MAX(state),
    MAX(region)
FROM superstore_staging
GROUP BY customer_id;
INSERT INTO products (
    product_id,
    category,
    sub_category,
    product_name
)
SELECT
    product_id,
    MAX(category),
    MAX(sub_category),
    MAX(product_name)
FROM superstore_staging
GROUP BY product_id;
INSERT INTO orders (
    order_id,
    order_date,
    order_month,
    ship_date,
    ship_mode,
    customer_id,
    product_id,
    sales,
    quantity,
    discount,
    profit
)
SELECT
    order_id,
    MIN(order_date) AS order_date,
    MIN(order_month) AS order_month,
    MIN(ship_date) AS ship_date,
    MIN(ship_mode) AS ship_mode,
    customer_id,
    product_id,
    SUM(sales) AS sales,
    SUM(quantity) AS quantity,
    MAX(discount) AS discount,
    SUM(profit) AS profit
FROM superstore_staging
GROUP BY order_id, product_id, customer_id;

SELECT COUNT(*) 
FROM orders
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;
SELECT
    SUM(sales) AS staging_sales,
    (SELECT SUM(sales) FROM orders) AS orders_sales
FROM superstore_staging;
SELECT
    SUM(profit) AS staging_profit,
    (SELECT SUM(profit) FROM orders) AS orders_profit
FROM superstore_staging;
SELECT                        -- It shows a matrix that gives details about KPIs.
    o.order_id,
    c.customer_name,
    p.product_name,
    o.sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
LIMIT 5;
SELECT                            
sum(sales) AS total_sales,
sum(profit) AS total_profit,
count(DISTINCT order_id) AS total_orders
FROM orders;
SELECT                              -- Gives monthly total sales.
    order_month,
    SUM(sales) AS monthly_sales
FROM orders
GROUP BY order_month
ORDER BY order_month;
SELECT                               -- It shows a table that tells how much contribution of each product category in total sales has.
    p.category,
    SUM(o.sales) AS total_sales,
    SUM(o.profit) AS total_profit
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_profit DESC;
SELECT region,                            -- Gives total profit and total sales based on the region in descending order of sales
	sum(o.sales) AS total_sales,
    sum(o.profit) AS total_profit
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY total_profit DESC;
SELECT c.customer_id, c.customer_name,     -- Gives the top 10 customers causing highest sales
sum(o.sales) AS total_sales,
sum(o.profit) AS total_profit
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 10;
SELECT discount,                        -- How Discount affects Sales and Profit?
SUM(sales),
SUM(profit)
FROM orders
GROUP BY discount
ORDER BY discount DESC;
SELECT c.customer_id, c.customer_name,     -- Brings all the customers that are causing loss in total profit
	sum(o.sales) AS total_sales,
    sum(o.profit) AS total_profit
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING SUM(o.profit) < 0
ORDER BY total_profit DESC;
SELECT                                  -- Which Customers are causing losses overall?
    c.customer_id,
    c.customer_name,
    SUM(o.sales) AS total_sales,
    SUM(o.profit) AS total_profit
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.profit) < 0
ORDER BY total_profit ASC;

SELECT                                  -- Find products with negative total profits.
    p.product_id,
    p.product_name,
    p.category,
    SUM(o.sales) AS total_sales,
    SUM(o.profit) AS total_profit
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
HAVING SUM(o.profit) < 0
ORDER BY total_profit ASC;

SELECT                                -- Which ship_mode generates high sales but low profit i.e. explains profit margin via each mode?
	ship_mode,                            
	sum(sales) AS  total_sales,
    sum(profit) AS total_profit,
    Round(sum(profit)/sum(sales)*100, 2) AS profit_margin
FROM orders
GROUP BY ship_mode
ORDER BY profit_margin ASC;




