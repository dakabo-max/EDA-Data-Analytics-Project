/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions
-- Yearly
SELECT 
	EXTRACT(YEAR FROM order_date) AS order_year,
	sum(sales) AS total_sales,
	count(DISTINCT customer_key) AS total_customers,
	sum(quantity) AS total_quantity
FROM fact_sales
WHERE EXTRACT(YEAR FROM order_date) IS NOT NULL 
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY order_year;

-- Monthly
SELECT 
	EXTRACT(MONTH FROM order_date) AS order_month,
	sum(sales) AS total_sales,
	count(DISTINCT customer_key) AS total_customers,
	sum(quantity) AS total_quantity
FROM fact_sales
WHERE EXTRACT(MONTH FROM order_date) IS NOT NULL 
GROUP BY EXTRACT(MONTH FROM order_date)
ORDER BY order_month;
