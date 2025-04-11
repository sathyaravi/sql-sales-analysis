SHOW DATABASES;
use sql_project1;
/**********Create Table*********/
DROP TABLE IF EXISTS sales_db; 
CREATE TABLE sales_db(transactions_id INTEGER PRIMARY KEY,
sale_date DATE,	
sale_time	TIME,
customer_id	INTEGER,
gender	VARCHAR(20),
age	INTEGER,
category VARCHAR(20),
quantity INTEGER,	
price_per_unit	FLOAT,
cogs FLOAT,
total_sale FLOAT
);

SHOW TABLES;

SELECT * FROM sales_db;

/******* Data Exploration and Cleaning ***********/
SELECT * FROM sales_db;

SELECT COUNT(*) FROM sales_db;

SELECT COUNT(DISTINCT customer_id) FROM sales_db;

SELECT DISTINCT category FROM sales_db;

SELECT * FROM sales_db
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
DELETE FROM sales_db
WHERE
	sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    

/***********Data analysis and findings*****/

/******Write a SQL query to retrieve all columns for sales made on '2022-11-05****/
SELECT * FROM sales_db WHERE sale_date = '2022-11-05';

/***Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:***/

SELECT * FROM sales_db WHERE category = 'Clothing' AND quantity >= 4 AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';


/****
Write a SQL query to calculate the total sales (total_sale) for each category.:*****/
SELECT category,SUM(total_sale) as net_sales, COUNT(*) as total_orders FROM sales_db
GROUP BY category;
/****Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:********/
SELECT AVG(age) as avg_age FROM sales_db WHERE category='Beauty';


/*****Write a SQL query to find all transactions where the total_sale is greater than 1000*****/

SELECT * FROM sales_db WHERE total_sale > 1000;


/***********Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category******/
SELECT COUNT(transactions_id) as total_transactions,category,gender FROM sales_db
GROUP BY gender,category
ORDER BY category;


/*************Write a SQL query to calculate the average sale for each month. Find out best selling month in each year************/
WITH monthly_avg_sales AS (
  SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS avg_sales
  FROM sales_db
  GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
),
ranked_sales AS (
  SELECT 
    year,
    month,
    avg_sales,
    RANK() OVER (
      PARTITION BY year 
      ORDER BY avg_sales DESC
    ) AS rank_sale
  FROM monthly_avg_sales
)
SELECT year, month, avg_sales
FROM ranked_sales
WHERE rank_sale = 1;

/***************Write a SQL query to find the top 5 customers based on the highest total sales **************/
SELECT * FROM sales_db;
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM sales_db
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


/********Write a SQL query to find the number of unique customers who purchased items from each category.****************/
SELECT category, COUNT(DISTINCT customer_id) as unique_customers_count FROM sales_db
GROUP BY category;

/******************Write a SQL query to create each shift and number of orders*******************/

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM sales_db
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;