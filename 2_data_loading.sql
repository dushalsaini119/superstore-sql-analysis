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
