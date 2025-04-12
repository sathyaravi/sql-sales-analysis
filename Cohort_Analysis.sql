SHOW DATABASES;
use sql_project1;

SELECT * FROM sales_db;

/***********Cohort analysis - super insightful way to track customer behaviour over time , especially repeat customers********/

/*************Create First Purchase Month per Customer (Cohort Month)************/

WITH first_purchase AS (
  SELECT 
    customer_id,
    MIN(sale_date) AS first_purchase_date
  FROM sales_db
  GROUP BY customer_id
),
sales_with_cohort AS (
  SELECT 
    s.customer_id,
    s.sale_date,
    f.first_purchase_date,
    DATE_FORMAT(f.first_purchase_date, '%Y-%m') AS cohort_month,
    DATE_FORMAT(s.sale_date, '%Y-%m') AS purchase_month
  FROM sales_db s
  JOIN first_purchase f ON s.customer_id = f.customer_id
),
cohort_indexed AS (
  SELECT 
    cohort_month,
    purchase_month,
    TIMESTAMPDIFF(
      MONTH,
      DATE_FORMAT(first_purchase_date, '%Y-%m-01'),
      DATE_FORMAT(sale_date, '%Y-%m-01')
    ) AS months_since_signup,
    customer_id
  FROM sales_with_cohort
)
SELECT *
FROM cohort_indexed;


