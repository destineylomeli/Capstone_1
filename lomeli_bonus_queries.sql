-- Bonus Questions
USE sample_sales;

-- SELECT, Filtering & Sorting

-- Q1: Create a list of all transactions that took place on January 15, 2024, sorted by sale amount from highest to lowest.
SELECT *
FROM store_sales
WHERE transaction_date = '2024-01-15'
ORDER BY sale_amount DESC;

-- Q2: Which transactions had a sale amount greater than $500? Display the transaction date, store ID, product number, and sale amount.
SELECT
	transaction_date,
    store_id
    prod_num,
    sale_amount
FROM store_sales
WHERE sale_amount > 500;

-- Q3: Find all products whose product number begins with the prefix 105250. What category do they belong to?
SELECT
	p.ProdNum,
    p.Product,
    ic.Category
FROM products p 
JOIN inventory_categories ic
	ON p.Categoryid = ic.Categoryid
WHERE p.ProdNum LIKE '105250%';

-- Aggregation 

-- Q4: What is the total sales revenue across all transactions? What is the average transaction amount?
SELECT 
	SUM(sale_amount) AS total_revenue,
    AVG(sale_amount) AS avg_transaction
FROM store_sales;

-- Q5: How many transactions were recorded for each product category? Which category has the most transactions?
SELECT 
	ic.Category,
    COUNT(*) AS total_transactions
FROM store_sales ss
JOIN products p ON ss.prod_num = p.ProdNum
JOIN inventory_categories ic ON p.Categoryid = ic.Categoryid
GROUP BY ic.Category
ORDER BY total_transactions DESC;

-- Q6: Which store generated the highest total revenue? Which generated the lowest?
SELECT
	ss.store_id,
    SUM(ss.sale_amount) AS total_revenue
FROM store_sales ss
GROUP BY ss.store_id
ORDER BY total_revenue DESC;

-- Q7: What is the total revenue for each category, sorted from highest to lowest?
SELECT
	ic.Category,
    SUM(ss.sale_amount) AS total_revenue
FROM store_sales ss
JOIN products p
	ON ss.prod_num = p.ProdNum
JOIN inventory_categories ic
	ON p.Categoryid = ic.Categoryid
GROUP BY ic.Category
ORDER BY total_revenue DESC;

-- Q8: Which stores had total revenue above $50,000? (Hint: you'll need HAVING.)
SELECT
	ss.store_id,
    SUM(ss.sale_amount) AS total_revenue
FROM store_sales ss
GROUP by ss.store_id
HAVING total_revenue > 50000;

-- JOINS

-- Q9: Find all sales records where the category is either "Textbooks" or "Technology & Accessories."
SELECT * 
FROM store_sales ss
JOIN products p 
	ON ss.prod_num = p.ProdNum
JOIN inventory_categories ic
	ON p.Categoryid = ic.Categoryid
WHERE ic.Category IN ('Textbooks', 'Technology & Accessories');

-- Q10: List all transactions where the sale amount was between $100 and $200, and the category was "Textbooks".
SELECT *
FROM store_sales ss
JOIN products p 
	ON ss.prod_num = p.ProdNum
JOIN inventory_categories ic 
	ON p.Categoryid = ic.Categoryid
WHERE ss.sale_amount BETWEEN 100 AND 200
AND ic.Category = 'Textbooks';

-- Q11: Write a query that displays each store's total sales along with the city and state where that store is located.
SELECT
	ss.store_id,
    sl.StoreLocation,
    sl.State,
    SUM(ss.sale_amount) AS total_sales
FROM store_sales ss
JOIN store_locations sl
	ON ss.store_id = sl.StoreID
GROUP BY ss.store_id, sl.StoreLocation, sl.State;

-- Q12: For each sale, display the transaction date, sale amount, city, state, and the name of the store manager responsible for the state.
SELECT 
	ss.transaction_date,
    ss.sale_amount,
    sl.StoreLocation,
    sl.State,
    m.SalesManager
FROM store_sales ss
JOIN store_locations sl
	ON ss.store_id = sl.StoreID
JOIN management m 
	ON sl.State = m.State; 
    
-- Q13: Write a query that shows total sales by region. Which region generates the most revenue?
SELECT
	m.Region,
    SUM(ss.sale_amount) AS total_revenue
FROM store_sales ss
JOIN store_locations sl
	ON ss.store_id = sl.StoreID
JOIN management m
	ON sl.State = m.State
GROUP BY m.Region
ORDER BY total_revenue DESC;

-- Q14: For states that have a preferred shipper listed in Shipper_List, show the total sales alongside the preferred and volume discount.
SELECT
	sl.State,
    sh.PreferredShipper,
    sh.VolumeDiscount,
    SUM(ss.sale_amount) AS total_revenue
FROM store_sales ss
JOIN store_locations sl
	ON ss.store_id = sl.StoreID
JOIN shipper_list sh 
	ON sl.State = sh.ShipToState
GROUP BY sl.State, sh.PreferredShipper, sh.VolumeDiscount
ORDER BY total_revenue DESC;


