/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/
-- Explore All Countries Our Customers comes from.
SELECT 
	DISTINCT country 
FROM dim_customers;


-- Explore All Categories 'The major divisions'
SELECT 
	DISTINCT category, 
	sub_category, 
	product_name
FROM dim_products
ORDER BY category, sub_category, product_name;
