/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/
-- Calculate the total sales per month and the running total of sales over time 
SELECT 
	order_month,
	total_sales,
	avg_price,
	sum(total_sales) over(ORDER BY order_month) AS running_total,
	round(avg(avg_price) over(ORDER BY order_month), 2) AS running_total
FROM
(SELECT 
	EXTRACT(MONTH FROM order_date) AS order_month,
	sum(sales) AS total_sales,
	round(avg(price),2) AS avg_price
FROM fact_sales
WHERE EXTRACT(MONTH FROM order_date) IS NOT NULL
GROUP BY EXTRACT(MONTH FROM order_date)
ORDER BY order_month ASC
) AS t1;
