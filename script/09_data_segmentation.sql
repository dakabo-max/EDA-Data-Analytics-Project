/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

-- Segment products into cost ranges and count how many products fall into each segment

WITH segments AS 
(
SELECT 
	 product_key,
	 product_name,
	 cost,
	 CASE 
	 	WHEN COST < 100 THEN 'Below 100'
	 	WHEN COST BETWEEN 100 AND 500 THEN '100-500'
	 	WHEN COST BETWEEN 500 AND 1000 THEN '500-1000'
	 	ELSE 'Above 1000'
	 END AS cost_range
FROM dim_products
)
SELECT 
	cost_range,
	count(product_key) AS total_products
FROM segments
GROUP BY cost_range
ORDER BY total_products DESC;

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH segmentation AS 
(
WITH customer_spending AS 
(
SELECT 
	c.customer_key,
	sum(f.sales) AS total_spending,
	min(f.order_date) AS first_order,
	max(f.order_date) AS last_order,
	EXTRACT(YEAR FROM AGE(MAX(f.order_date), MIN(f.order_date))) * 12 +
    EXTRACT(MONTH FROM AGE(MAX(f.order_date), MIN(f.order_date))) AS lifespan
FROM fact_sales AS f
LEFT JOIN dim_customers AS c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)
SELECT 
	customer_key,
	total_spending,
	lifespan,
	CASE 
		WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment
FROM customer_spending
)
SELECT 
	count(customer_key) AS customer_count, 
	customer_segment
FROM segmentation
GROUP BY customer_segment
ORDER BY customer_count DESC;
