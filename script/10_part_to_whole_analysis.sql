/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.
    - Used to tell which aspect of the business is doing better

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?

SELECT 
	p.category,
	sum(f.sales) AS total_sale,
	round(sum(f.sales) / sum(sum(f.sales)) over() * 100, 2) AS per_contribution
FROM fact_sales AS f
LEFT JOIN dim_products AS p
ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_sale DESC;
