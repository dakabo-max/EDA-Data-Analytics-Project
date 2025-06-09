/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/
-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT 
	p.product_name,
	sum(f.sales) AS total_revenue
FROM fact_sales AS f
LEFT JOIN dim_products AS p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Complex but Flexibly Ranking Using Window Functions
SELECT 
	p.product_name,
	sum(f.sales) AS total_revenue,
	rank() over(ORDER BY sum(f.sales) DESC)
FROM fact_sales AS f
LEFT JOIN dim_products AS p
ON f.product_key = p.product_key
GROUP BY p.product_name
LIMIT 5;

-- What are the 5 worst-performing products in terms of sales?
SELECT 
	p.product_name,
	sum(f.sales) AS total_revenue,
	rank() over(ORDER BY sum(f.sales) ASC)
FROM fact_sales AS f
LEFT JOIN dim_products AS p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC
LIMIT 5;


-- Find the top 10 customers who have generated the highest revenue
SELECT 
	 c.customer_key,
	 c.first_name,
	 c.last_name,
	 sum(f.sales) AS total_revenue
FROM fact_sales AS f
LEFT JOIN dim_customers AS c 
ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC
LIMIT 10;


-- The 3 customers with the fewest orders placed
SELECT 
	 c.customer_key,
	 c.first_name,
	 c.last_name,
	 count(DISTINCT order_number) AS total_orders
FROM fact_sales AS f
LEFT JOIN dim_customers AS c 
ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_orders ASC
LIMIT 3;
