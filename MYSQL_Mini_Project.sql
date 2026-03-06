

-- ________START_____OF_____SQL____SCRIPT_____


-- Ques1. Which products generate the highest and lowest revenue?

(select p.productName,sum(od.quantityordered*od.priceEach)as highest_and_lowest_revenue from products p join 
orderdetails od on p.productCode = od.productCode group by p.productName order by highest_and_lowest_revenue desc limit 1)
union
(select p.productName,sum(od.quantityordered*od.priceEach)as highest_and_lowest_revenue from products p join 
orderdetails od on p.productCode = od.productCode group by p.productName order by highest_and_lowest_revenue asc limit 1);



-- Q2. Which product lines result in highest revenue?

SELECT 
    p.productLine, 
    SUM(od.quantityOrdered * od.priceEach) AS total_revenue
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productLine
ORDER BY total_revenue DESC limit 3;



-- Q3. Who are the top customers, and what are their purchasing behaviours?

SELECT 
    c.customerName, 
    COUNT(DISTINCT o.orderNumber) AS total_orders,
    SUM(od.quantityOrdered * od.priceEach) AS total_spent,
    ROUND(SUM(od.quantityOrdered * od.priceEach) / COUNT(DISTINCT o.orderNumber), 2) AS avg_order_value
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerName
ORDER BY total_spent DESC
LIMIT 5;



-- Q4. How do seasonal trends and order volumes vary over time?

SELECT 
    YEAR(o.orderDate) AS Year, 
    MONTH(o.orderDate) AS Month, 
    COUNT(o.orderNumber) AS Order_Volume,
    SUM(od.quantityOrdered * priceEach) AS Monthly_Revenue
FROM orders o
JOIN orderdetails od on o.orderNumber = od.orderNumber
GROUP BY Year, Month
ORDER BY Year, Month;



-- Q5. How does the status of orders affect purchases?
SELECT 
    o.status, 
    COUNT(o.orderNumber) AS order_count, 
    SUM(od.quantityOrdered * od.priceEach) AS total_value
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY o.status
ORDER BY total_value DESC;



-- Q6. Understanding employee contribution in processing orders?
SELECT 
    e.employeeNumber, 
    CONCAT(e.firstName, ' ', e.lastName) AS sales_rep_name, 
    COUNT(DISTINCT o.orderNumber) AS total_orders_handled,
    SUM(od.quantityOrdered * od.priceEach) AS total_revenue_generated
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY e.employeeNumber, sales_rep_name
ORDER BY total_revenue_generated DESC;



-- Q7. Whether credit limit of customers affects purchase?
SELECT 
    c.customerName, 
    c.creditLimit, 
    SUM(od.quantityOrdered * od.priceEach) AS total_order_value,
    (SUM(od.quantityOrdered * od.priceEach) / c.creditLimit) * 100 AS credit_utilization_pct
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerName, c.creditLimit
ORDER BY total_order_value DESC;



-- Q8. Which countries are driving the most revenue?
SELECT 
    c.country, 
    COUNT(DISTINCT c.customerNumber) AS customer_count, 
    SUM(od.quantityOrdered * od.priceEach) AS total_revenue
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.country
ORDER BY total_revenue DESC;



-- Q9. What is the average "Time to Ship" across different product lines?
SELECT 
    p.productLine, 
    ROUND(AVG(DATEDIFF(o.shippedDate, o.orderDate)), 2) AS avg_days_to_ship
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
WHERE o.shippedDate IS NOT NULL
GROUP BY p.productLine
ORDER BY avg_days_to_ship DESC;




-- Q10. Which products have zero sales?
SELECT 
    p.productCode, 
    p.productName, 
    p.productLine, 
    p.quantityInStock
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
WHERE od.productCode IS NULL;


-- _____THE_________End______OF______SCRIPT________________










