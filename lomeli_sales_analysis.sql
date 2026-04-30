-- Capstone 1 Sales Analysis 
-- By: Destiney Lomeli 
-- Assigned Sales Manager: See Ellefson
-- Sales Territory: New York
-- Region: East
USE sample_sales; 

-- Finding territory 
SELECT *
FROM management
WHERE SalesManager = 'See Ellefson';

-- Q1: Total revenue + the start and end date of the sales data 
SELECT
	SUM(ss.sale_amount) AS total_revenue,
	MIN(ss.transaction_date) AS start_date,
	MAX(ss.transaction_date) AS end_date
FROM store_sales ss
JOIN store_locations sl
	ON ss.store_id = sl.storeid
WHERE sl.state = 'New York';

-- Q2: Monthly revenue breakdown for my sales territory
SELECT
	YEAR(ss.transaction_date) AS year, 
	MONTH(ss.transaction_date) AS month,
	SUM(ss.sale_amount) AS monthly_revenue
FROM store_sales ss
JOIN store_locations sl
	ON ss.store_id = sl.storeid
WHERE sl.state = 'New York' 
GROUP BY YEAR(ss.transaction_date), MONTH(ss.transaction_date)
ORDER BY year, month;

-- Q3: Compare total revenue for my sales territory and the region is belongs to
SELECT
	'New York Territory' AS comparison_group,
	SUM(ss.sale_amount) AS total_revenue
FROM store_sales ss
JOIN store_locations sl
	ON ss.store_id = sl.storeid
WHERE sl.state = 'New York'
UNION ALL 
SELECT 
	'East Region' AS comaprison_group,
	SUM(ss.sale_amount) AS total_revenue
FROM store_sales ss
JOIN store_locations sl
	ON ss.store_id = sl.storeid
JOIN management m
	ON sl.state = m.state
WHERE m.Region = 'East';

-- Q4: Number of transactions per month and average transaction size by product category
SELECT
	YEAR(ss.transaction_date) AS year, 
    MONTH(ss.transaction_date) AS month, 
	ic.Category,
    COUNT(*) AS total_transactions,
    AVG(ss.sale_amount) AS avg_transaction_size
FROM store_sales ss
JOIN products p 
	ON ss.prod_num = p.ProdNum
JOIN inventory_categories ic
	ON p.Categoryid = ic.Categoryid
JOIN store_locations sl
	ON ss.store_id = sl.storeid    
WHERE sl.state = 'New York' 
GROUP BY year, month, ic.Category
ORDER BY year, month, total_transactions DESC;

-- Q5: Ranking of in-store sales performance by each store in my sales territory 
SELECT
	ss.store_id,
    sl.StoreLocation,
    sl.State,
    SUM(ss.sale_amount) AS total_revenue,
    COUNT(*) AS total_transactions, 
    AVG(ss.sale_amount) AS avg_transaction_size
FROM store_sales ss
JOIN store_locations sl
	ON ss.store_id = sl.StoreID
WHERE sl.State = 'New York'
GROUP BY ss.store_id, sl.StoreLocation, sl.State
ORDER BY total_revenue DESC;

-- Q6: Recommendation for where to focus sales attetion next quarter
-- I highly recommend focusing on Technology and Accessories mainly because it has the highest average
-- transaction size and strong revenue potential. We can increase marketing efforts, promotions, and inventory 
-- for this category causing it to boost its overall revenue. Overall I feel like improving lower performing 
-- categories like Stationary and Books can also help increase sales by finding their opportunities for improvement.
-- If we focus on the high value categories while actively improving weaker ones the company can maximize
-- sales growth in the next quarter. This recommendation is based on the transaction counts, average transaction size,
-- meaning each sale brings in more revenue compared to other categories.
