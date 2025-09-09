# Retail Sales Analysis SQL Project 
## Project Overview 
Project Title: Retail Sales Analysis

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT, 
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT, 
	price_per_unit FLOAT, 
	cogs FLOAT,
	total_sale FLOAT
	)
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
DELETE FROM retail_sales
WHERE
	category IS NULL OR
	quantity IS NULL OR
	price_per_unit IS NULL OR
	cogs IS NULL OR
	total_sale IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Peak Shopping Hours by Total Transactions and Sales**:
```sql
SELECT
    EXTRACT(HOUR FROM sale_time) AS sales_hour,
    COUNT(transactions_id) AS total_transaction,
    SUM(total_sale) AS sales
FROM retail_sales
GROUP BY sales_hour
ORDER BY total_transaction DESC;
```

2. **Peak Shopping Dates and Total Sales**:
```sql
SELECT
    sale_date,
    COUNT(transactions_id) AS total_transaction,
    SUM(total_sale) AS sales
FROM retail_sales
GROUP BY sale_date
ORDER BY sales DESC;
```

3. **Customer Demographics: Average Age and Total Transactions by Gender**:
```sql
SELECT
    COUNT(transactions_id) AS transactions,
    gender,
    AVG(age) AS average_age
FROM retail_sales
GROUP BY gender;
```

4. **Best-selling month overall**:
```sql
SELECT
    TO_CHAR(sale_date, 'YYYY-MM') AS year_month,
    SUM(total_sale) AS total
FROM retail_sales
GROUP BY year_month
ORDER BY total DESC;
```

5. **Best-selling month overall**:
```sql
SELECT
    customer_id,
    COUNT(transactions_id) AS number_of_transactions,
    SUM(total_sale) AS sum_of_total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY number_of_transactions DESC
LIMIT 5;
```

6. **Sales Performance by Time of Day (Morning, Afternoon, Evening)**:
```sql
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
```

7. **Top-Selling Categories by Quantity**:
```sql
SELECT 
SELECT
    category,
    SUM(quantity) AS total_quantity
FROM retail_sales
GROUP BY category

ORDER BY total_quantity DESC;
```


## Findings

- **Customer Demographics**: 
