/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Explore the earlies and latest dates
-- How many years of sales are available
SELECT 
	MIN(order_date) AS lowest_date,
	MAX(order_date) AS highest_date,
    EXTRACT(YEAR FROM age(MAX(order_date), MIN(order_date))) AS years_difference
FROM fact_sales;

-- Find the youndest and olderst customer
SELECT 
	MIN(birthdate) AS youngest_birthdate,
	MAX(birthdate) AS oldest_birthdate,
    extract(YEAR FROM AGE(MAX(birthdate), MIN(birthdate))) AS age_difference,
    extract(YEAR FROM AGE(current_date, MAX(birthdate))),
    extract(YEAR FROM AGE(current_date, MIN(birthdate)))
FROM dim_customers;
