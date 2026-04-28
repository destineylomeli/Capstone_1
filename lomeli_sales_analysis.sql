USE sample_sales; 

-- Finding territory 
SELECT *
FROM management
WHERE SalesManager = 'See Ellefson';
-- Region: East & State: New York

-- Q1: Total revenue + date range
SELECT
SUM(ss.sale_amount) AS total_revenue,
MIN(ss.transaction_date) AS start_date,
MAX(ss.transaction_date) AS end_date
FROM store_sales ss
JOIN store_locations sl
ON ss.store_id = sl.storeid
WHERE sl.state = 'New York';