/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

-- Analyze the yearly performance of products by comparing their sales to both the average sales performance of the product and the previous year's sales
-- Year-Over-Year Analysis
SELECT
    p.product_name,
    EXTRACT(YEAR FROM f.order_date) AS sales_year,
    SUM(sales) AS total_sales,
    -- Average sales across all years for this product
    ROUND(AVG(SUM(sales)) OVER (PARTITION BY p.product_name), 2) AS avg_sales_per_product,
    -- Change vs average
    ROUND(SUM(sales) - AVG(SUM(sales)) OVER (PARTITION BY p.product_name), 2) AS diff_from_avg,
    CASE 
    	WHEN ROUND(SUM(sales) - AVG(SUM(sales)) OVER (PARTITION BY p.product_name), 2) > 0 THEN 'Above Avg'
    	WHEN ROUND(SUM(sales) - AVG(SUM(sales)) OVER (PARTITION BY p.product_name), 2) < 0 THEN 'Below Avg'
    	ELSE 'Avg'
    END AS avg_change,
     -- Previous year's sales for this product
    LAG(SUM(sales)) OVER (PARTITION BY p.product_name ORDER BY EXTRACT(YEAR FROM order_date)) AS prev_year_sales,
    -- Change vs previous year
    ROUND(SUM(sales) - LAG(SUM(sales)) OVER (PARTITION BY p.product_name ORDER BY EXTRACT(YEAR FROM order_date)), 2) AS diff_from_prev_year,
    CASE 
    	WHEN ROUND(SUM(sales) - LAG(SUM(sales)) OVER (PARTITION BY p.product_name ORDER BY EXTRACT(YEAR FROM order_date)), 2) > 0 THEN 'Increase'
    	WHEN ROUND(SUM(sales) - LAG(SUM(sales)) OVER (PARTITION BY p.product_name ORDER BY EXTRACT(YEAR FROM order_date)), 2) < 0 THEN 'Decrease'
    	ELSE 'No Change'
    END AS py_change
FROM fact_sales AS f
LEFT JOIN dim_products AS p
ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
GROUP BY p.product_name, EXTRACT(YEAR FROM f.order_date)
ORDER BY p.product_name, sales_year;
