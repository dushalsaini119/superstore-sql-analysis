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
