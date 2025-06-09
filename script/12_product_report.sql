/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
CREATE VIEW product_report AS 
WITH base_query AS 
(
SELECT 
	p.product_key,
	p.product_name, 
	p.category, 
	p.sub_category, 
	p."cost",
	f.order_number,
	f.order_date,
	f.customer_key,
	f.sales,
	f.quantity
FROM fact_sales AS f
LEFT JOIN dim_products AS p 
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
),
product_segregation AS
(
SELECT 
	product_key,
	product_name, 
	category, 
	sub_category, 
	COST,
	quantity,
	EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
    EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS lifespan,
    MAX(order_date) AS last_sale_date,
    COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales) AS total_sales,
    SUM(quantity) AS total_quantity,
	round(AVG(sales) / NULLIF(quantity, 0), 2) AS avg_selling_price
FROM base_query
GROUP BY product_key, product_name, category, sub_category, COST, quantity
)
/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT 
	product_key,
	product_name,
	category,
	sub_category,
	cost,
	last_sale_date,
	EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_sale_date)) * 12 +
	EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_sale_date)) AS recency,
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	-- Average Order Revenue (AOR)
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_revenue,
	-- Average Monthly Revenue
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE round(total_sales / lifespan, 2)
	END AS avg_monthly_revenue
FROM product_segregation;
