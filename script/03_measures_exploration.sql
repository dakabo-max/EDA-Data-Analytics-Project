/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/
-- Find the total Sales
SELECT 
	sum(sales) AS total_sales
FROM fact_sales;

-- Find how many items are sold
SELECT 
	sum(quantity) AS total_quantity
FROM fact_sales;

-- Find the average selling price
SELECT 
	round(avg(price),2) AS avg_price
FROM fact_sales;

-- Find the Total number of Orders
SELECT count(DISTINCT order_number) AS toltal_orders
FROM fact_sales;

-- Find the Total number of products
SELECT count(DISTINCT product_id) AS toltal_products
FROM dim_products;

-- Find the Total number of Customers
SELECT 
	count(DISTINCT customer_key) AS toltal_customers 
FROM dim_customers;
-- Find the Total number of customers that has placed an order
SELECT count(DISTINCT customer_key) 
FROM fact_sales;

-- Generate a report that shows all key metrics of the business
SELECT 'Total Sale' AS measure_name, sum(sales) AS measure_value FROM fact_sales
UNION ALL 
SELECT 'Total quantity' AS measure_name, sum(quantity) AS measure_value FROM fact_sales
UNION ALL 
SELECT 'Avg Price' AS measure_name, round(avg(price),2) AS measure_value FROM fact_sales
UNION ALL 
SELECT 'Total Orders' AS measure_name, count(DISTINCT order_number) AS measure_value FROM fact_sales
UNION ALL 
SELECT 'Total products' AS measure_name, count(DISTINCT product_id) AS measure_value FROM dim_products
UNION ALL 
SELECT 'Total customers' AS measure_name, count(DISTINCT customer_key) AS measure_value FROM dim_customers;
