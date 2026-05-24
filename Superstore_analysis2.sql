-- 1.Create Customers Table using SELECT DISTINCT
CREATE TABLE customers AS
SELECT DISTINCT
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    region
FROM superstore_raw;

-- 2.Create Products Table using SELECT DISTINCT
CREATE TABLE products AS
SELECT DISTINCT
    product_id,
    category,
    sub_category,
    product_name
FROM superstore_raw;

-- 3.Create Orders Table
CREATE TABLE orders AS
SELECT
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    product_id,
    sales,
    quantity,
    discount,
    profit
FROM superstore_raw; 

-- 4.Subquery – Above Average Sales
SELECT order_id,
       sales
FROM orders
WHERE sales > (
    SELECT AVG(sales)
    FROM orders
); 

-- 5.Subquery – Highest Order Per Customer
SELECT customer_id,
       MAX(sales) AS highest_sale
FROM orders
GROUP BY customer_id; 

-- 6.CTE – Total Sales Per Customer 
WITH customer_sales AS (
    SELECT customer_id,
           SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT *
FROM customer_sales
ORDER BY total_sales DESC;

 -- 7.Window Function – ROW_NUMBER()
 SELECT customer_id,
       sales,
       ROW_NUMBER() OVER(ORDER BY sales DESC) AS row_num
FROM orders;

-- 8.Window Function – RANK()
SELECT customer_id,
       SUM(sales) AS total_sales,
       RANK() OVER(ORDER BY SUM(sales) DESC) AS ranking
FROM orders
GROUP BY customer_id;

-- 9.JOIN + CTE + Window Function 
WITH customer_sales AS (
    SELECT customer_id,
           SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT c.customer_name,
       cs.total_sales,

       RANK() OVER(
           ORDER BY cs.total_sales DESC
       ) AS customer_rank

FROM customer_sales cs
JOIN customers c
ON cs.customer_id = c.customer_id;

-- 10. Top Customers Analysis
SELECT customer_name,
       SUM(sales) AS total_sales
FROM superstore_raw
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- 11.Low Customers Analysis
SELECT customer_name,
       SUM(sales) AS total_sales
FROM superstore_raw
GROUP BY customer_name
ORDER BY total_sales ASC
LIMIT 10 

-- 12.Single-Order Customers
SELECT customer_id,
       COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) = 1; 

-- 13.Above Average Sales Customers
WITH customer_totals AS (
    SELECT customer_id,
           SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT *
FROM customer_totals
WHERE total_sales > (
    SELECT AVG(total_sales)
    FROM customer_totals
); 

 -- 14.Additional Business Insights
-- Region-wise sales
SELECT region,
       SUM(sales) AS total_sales
FROM superstore_raw
GROUP BY region
ORDER BY total_sales DESC;

-- Category-wise profit
SELECT category,
       SUM(profit) AS total_profit
FROM superstore_raw
GROUP BY category
ORDER BY total_profit DESC;

-- Most sold products
SELECT product_name,
       SUM(quantity) AS total_quantity
FROM superstore_raw
GROUP BY product_name
ORDER BY total_quantity DESC
LIMIT 10; 