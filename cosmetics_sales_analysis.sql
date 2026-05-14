SHOW TABLES;
SELECT * FROM cosmetics_sales_data LIMIT 10;
SELECT COUNT(*) FROM cosmetics_sales_data;
SELECT DISTINCT Product FROM Cosmetics_sales_data;
SELECT DISTINCT Country FROM cosmetics_sales_data;

ALTER TABLE cosmetics_sales_data
RENAME COLUMN `SalesPerson` TO sales_person;

ALTER TABLE cosmetics_sales_data
RENAME COLUMN `Country` TO country;

ALTER TABLE cosmetics_sales_data
RENAME COLUMN `Products` TO products;

ALTER TABLE cosmetics_sales_data
RENAME COLUMN `Amount ($)` TO amount;

ALTER TABLE cosmetics_sales_data
RENAME COLUMN `Date` TO sale_date;

ALTER TABLE cosmetics_sales_data
RENAME COLUMN `Boxes Shipped` TO boxes_shipped;

SELECT * FROM cosmetics_sales_data;

--  Which sales happened in India?
SELECT Sales_Person,product,amount FROM cosmetics_sales_data 
WHERE Country='India'
ORDER BY amount DESC;
-- i dont want amount in points i want exact value so iwill use 'ROUND'
SELECT Sales_Person,product,ROUND(amount) FROM cosmetics_sales_data 
WHERE Country='India'
ORDER BY amount DESC;

--  Which UK sales had Cream in the product name?
SELECT sales_person,product,amount
FROM cosmetics_sales_data
WHERE country='UK'
AND product LIKE '%cream%';

-- Which country made the highest total sales?
SELECT country,ROUND (SUM(amount)) AS total_sales
FROM cosmetics_sales_data
GROUP BY country
ORDER BY total_sales DESC;
-- If we not mention 'DESC' by default it gives in ASC order
SELECT product,amount FROM cosmetics_sales_data;

--  Average order value and total orders per product?
SELECT product,
COUNT(*) AS total_orders
FROM cosmetics_sales_data
GROUP BY product
ORDER BY total_orders DESC;

-- Which sales person made more than 10 sales?
SELECT sales_person,
COUNT(*) AS total_sales
FROM cosmetics_sales_data
GROUP BY sales_person
HAVING  total_sales>'10'
ORDER BY total_sales DESC;
-- When we wanted to use 'Where',then 'GROUP BY' is already used then in that case we can use 'HAVING' - To filter the rows.

SELECT * FROM cosmetics_sales_data;

--  Which sales were above average amount?
SELECT sales_person,country,product,
ROUND(amount) AS amount
FROM cosmetics_sales_data
WHERE amount>(SELECT AVG(amount) FROM cosmetics_sales_data)
ORDER BY amount DESC;

SELECT * FROM cosmetics_sales_data;
SELECT products,amount FROM cosmetics_sales_data;

ALTER TABLE cosmetics_sales_data
RENAME COLUMN `products` TO product;

 -- Show each sale with the overall average next to it.
 SELECT sales_person,product,ROUND(amount)AS amount,
 ROUND((SELECT AVG(amount) FROM Cosmetics_sales_data)) AS overall_avg_amt,
 CASE 
 WHEN amount>(SELECT AVG(amount) FROM cosmetics_sales_data)
 THEN "Above avg"
 ELSE "Below avg"
 END AS performance
 FROM cosmetics_sales_data
ORDER BY Amount DESC;

-- : Salespersons above average total revenue using CTE
WITH salesperson_totals AS 
(select sales_person,ROUND(SUM(amount)) AS total_revenue 
FROM cosmetics_sales_data
GROUP BY sales_person),
avg_revenue AS (SELECT(ROUND(AVG(total_revenue),2)) AS avg_rev FROM salesperson_totals)
SELECT s.sales_person,ROUND(s.total_revenue) AS total_revenue
FROM salesperson_totals AS s,
avg_revenue
WHERE s.total_revenue > avg_rev
ORDER BY s.total_revenue DESC;

-- Rank salespersons by total revenue
SELECT sales_person,
ROUND(SUM(amount)) AS total_revenue,
RANK() OVER (ORDER BY sum(amount) DESC) AS revenue_rank
FROM cosmetics_sales_data
GROUP BY sales_person;

-- Running total of sales amount by date
SELECT sales_person,sale_date,product,ROUND(amount) AS amount,
ROUND(SUM(amount) OVER (ORDER BY sale_date)) AS running_total
FROM cosmetics_sales_data
ORDER BY sale_date;
