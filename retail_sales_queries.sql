/*
  Project: Retail Sales Data Analysis
  File: retail_sales_analysis.sql
  Description: This file contains all the SQL queries used for data
               cleaning and analysis of the retail sales dataset.
*/

-- ===================================================================
-- 1. Database & Table Setup
-- ===================================================================

-- Drop the table if it already exists to ensure a clean start
DROP TABLE IF EXISTS retail_sales;

-- Create the retail_sales table
CREATE TABLE retail_sales
	(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

-- ===================================================================
-- 2. Data Cleaning & Preparation
-- ===================================================================

-- Remove rows with NULL values in critical columns to ensure data integrity
DELETE FROM retail_sales
WHERE
	category IS NULL OR
	quantity IS NULL OR
	price_per_unit IS NULL OR
	cogs IS NULL OR
	total_sale IS NULL;

-- ===================================================================
-- 3. Key Business Questions & Analysis
-- ===================================================================

-- Peak Shopping Hours by Total Transactions and Sales
-- This query identifies the busiest hours of the day.
SELECT
    EXTRACT(HOUR FROM sale_time) AS sales_hour,
    COUNT(transactions_id) AS total_transaction,
    SUM(total_sale) AS sales
FROM retail_sales
GROUP BY sales_hour
ORDER BY total_transaction DESC;

-- Peak Shopping Dates and Total Sales
-- This query identifies the days with the highest total revenue.
SELECT
    sale_date,
    COUNT(transactions_id) AS total_transaction,
    SUM(total_sale) AS sales
FROM retail_sales
GROUP BY sale_date
ORDER BY sales DESC;

-- Customer Demographics: Average Age and Total Transactions by Gender
-- This analysis provides insights into customer profiles.
SELECT
    COUNT(transactions_id) AS transactions,
    gender,
    AVG(age) AS average_age
FROM retail_sales
GROUP BY gender;

-- Monthly Sales Trends
-- This section answers two questions: sales per month and the best-selling month.

-- Sales per month, ordered chronologically
SELECT
    TO_CHAR(sale_date, 'YYYY-MM') AS year_month,
    SUM(total_sale) AS total
FROM retail_sales
GROUP BY year_month
ORDER BY year_month ASC;

-- Best-selling month overall
SELECT
    TO_CHAR(sale_date, 'YYYY-MM') AS year_month,
    SUM(total_sale) AS total
FROM retail_sales
GROUP BY year_month
ORDER BY total DESC;


-- Top 5 Customers by Number of Transactions
-- This query identifies the most loyal customers based on transaction count.
SELECT
    customer_id,
    COUNT(transactions_id) AS number_of_transactions,
    SUM(total_sale) AS sum_of_total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY number_of_transactions DESC
LIMIT 5;


-- Sales Performance by Time of Day (Morning, Afternoon, Evening)
-- This query calculates the average daily number of transactions for each time period.
WITH DailyTransactions AS (
    SELECT
        sale_date,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) >= 5 AND EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) >= 12 AND EXTRACT(HOUR FROM sale_time) < 17 THEN 'Afternoon'
            WHEN EXTRACT(HOUR FROM sale_time) >= 17 AND EXTRACT(HOUR FROM sale_time) < 21 THEN 'Evening'
            ELSE 'Night'
        END AS time_of_day,
        COUNT(transactions_id) AS total_transactions
    FROM retail_sales
    GROUP BY
        sale_date,
        time_of_day
)
SELECT
    time_of_day,
    AVG(total_transactions) AS avg_daily_transactions
FROM DailyTransactions
GROUP BY time_of_day;


-- Top-Selling Categories by Quantity
-- This query identifies the most popular product categories.
SELECT
    category,
    SUM(quantity) AS total_quantity
FROM retail_sales
GROUP BY category
ORDER BY total_quantity DESC;