/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/

-- =============================================================================
-- Create Report: customers_report view
-- =============================================================================
CREATE VIEW customer_report AS 
WITH base_query AS 
(
SELECT 
	p.product_key,
	c.customer_key,
	c.customer_number,
	concat(c.first_name, ' ', c.last_name) AS customer_name,
	extract(YEAR FROM age(c.birthdate)) AS customer_age,
	f.order_date,
	f.sales,
	f.quantity,
	f.price,
	f.order_number
FROM fact_sales AS f
LEFT JOIN dim_customers AS c
ON f.customer_key = c.customer_key
LEFT JOIN dim_products AS p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
)
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
, customer_aggregation AS 
(
SELECT 
	customer_key,
	customer_number,
	customer_name,
	customer_age,
	count(DISTINCT order_number) AS total_orders,
	sum(sales) AS total_sales,
	sum(quantity) AS total_quantity,
	count(DISTINCT product_key) AS total_product,
	max(order_date) AS last_order,
	EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
    EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS lifespan
FROM base_query
GROUP BY customer_key, customer_number, customer_name, customer_age
)
SELECT 
	customer_key,
	customer_number,
	customer_name,
	customer_age,
	CASE 
		WHEN customer_age < 20 THEN 'Under 20'
	 	WHEN customer_age between 20 and 29 THEN '20-29'
	 	WHEN customer_age between 30 and 39 THEN '30-39'
	 	WHEN customer_age between 40 and 49 THEN '40-49'
	 	ELSE '50 and above'
	END AS age_group,
	total_orders,
	total_sales,
	total_quantity,
	total_product,
	last_order,
	EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_order)) * 12 +
	EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_order)) AS recency,
	lifespan,
	CASE 
		WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	-- Compuate average order value (AVO)
	CASE 
		WHEN total_sales = 0 THEN 0
	 	ELSE total_sales / total_orders
	END AS avg_order_value,
	-- Compuate average monthly spend
	CASE 
		WHEN lifespan = 0 THEN total_sales
     	ELSE round(total_sales / lifespan, 2)
	END AS avg_monthly_spend
FROM customer_aggregation;
