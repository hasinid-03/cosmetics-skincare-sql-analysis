-- ================================================
-- Cosmetics & Skincare Sales Analysis
-- Tool: MySQL Workbench
-- ================================================

-- EXPLORATION
-- ------------------------------------------------

-- View first 10 rows
SELECT * FROM cosmetics_sales_data LIMIT 10;

-- Total number of records
SELECT COUNT(*) AS total_records FROM cosmetics_sales_data;

-- All unique countries
SELECT DISTINCT country FROM cosmetics_sales_data;

-- All unique products
SELECT DISTINCT product FROM cosmetics_sales_data;

-- All unique salespersons
SELECT DISTINCT sales_person FROM cosmetics_sales_data;

-- Count of countries, products, salespersons
SELECT COUNT(DISTINCT country) AS total_countries,
       COUNT(DISTINCT product) AS total_products,
       COUNT(DISTINCT sales_person) AS total_salespersons
FROM cosmetics_sales_data;

-- ANALYSIS QUERIES
-- ------------------------------------------------

-- Q1: Which sales happened in India?
-- Concept: SELECT + WHERE + ORDER BY
SELECT sales_person, product, ROUND(amount) AS amount
FROM cosmetics_sales_data
WHERE country = 'India'
ORDER BY amount DESC;

-- Q2: Which UK sales had Cream in the product name?
-- Concept: AND + LIKE
SELECT sales_person, product, ROUND(amount) AS amount
FROM cosmetics_sales_data
WHERE country = 'UK'
AND product LIKE '%Cream%';

-- Q3: Which country made the highest total sales?
-- Concept: GROUP BY + SUM + ROUND
SELECT country,
       ROUND(SUM(amount)) AS total_sales
FROM cosmetics_sales_data
GROUP BY country
ORDER BY total_sales DESC;

-- Q4: Which product has most orders and best average order value?
-- Concept: GROUP BY + COUNT + AVG
SELECT product,
       COUNT(*) AS total_orders,
       ROUND(AVG(amount)) AS avg_order_value
FROM cosmetics_sales_data
GROUP BY product
ORDER BY avg_order_value DESC;

-- Q5: Which salesperson made more than 10 sales?
-- Concept: GROUP BY + HAVING
SELECT sales_person,
       COUNT(*) AS total_sales
FROM cosmetics_sales_data
GROUP BY sales_person
HAVING total_sales > 10
ORDER BY total_sales DESC;

-- Q6: Which sales were above the average sale amount?
-- Concept: Subquery in WHERE
SELECT sales_person, country, product,
       ROUND(amount) AS amount
FROM cosmetics_sales_data
WHERE amount > (SELECT AVG(amount) FROM cosmetics_sales_data)
ORDER BY amount DESC;

-- Q7: Show each sale with overall average and performance label
-- Concept: Subquery in SELECT + CASE WHEN
SELECT sales_person, product,
       ROUND(amount) AS amount,
       ROUND((SELECT AVG(amount) FROM cosmetics_sales_data)) AS overall_avg,
       CASE
           WHEN amount > (SELECT AVG(amount) FROM cosmetics_sales_data)
           THEN 'Above Average'
           ELSE 'Below Average'
       END AS performance
FROM cosmetics_sales_data
ORDER BY amount DESC;

-- Q8: Which salespersons are above average total revenue?
-- Concept: CTE (WITH clause)
WITH salesperson_totals AS (
    SELECT sales_person,
           ROUND(SUM(amount)) AS total_revenue
    FROM cosmetics_sales_data
    GROUP BY sales_person
),
avg_revenue AS (
    SELECT ROUND(AVG(total_revenue)) AS avg_rev
    FROM salesperson_totals
)
SELECT s.sales_person,
       s.total_revenue
FROM salesperson_totals AS s, avg_revenue
WHERE s.total_revenue > avg_rev
ORDER BY s.total_revenue DESC;

-- Q9: Rank all salespersons by total revenue
-- Concept: Window Function - RANK()
SELECT sales_person,
       ROUND(SUM(amount)) AS total_revenue,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS revenue_rank
FROM cosmetics_sales_data
GROUP BY sales_person;

-- Q10: Running total of revenue over time
-- Concept: Window Function - Running Total
SELECT sale_date, sales_person, product,
       ROUND(amount) AS amount,
       ROUND(SUM(amount) OVER (ORDER BY sale_date)) AS running_total
FROM cosmetics_sales_data
ORDER BY sale_date;