-- Data Exploration for Northwind traders Analytics Project
/* Research Questions
=======================================================================================================
- Are there any noticable sales trends over time?
- Which are the best and worst selling products?
- Can you identify any key customers?
- Are shipping costs consistent across providers?
- Which products show seasonal variations in sales?
- Do specific employees significantly impact sales, positively or negatively?
- Is there a correlation between customer demographics and sales?
- Do shipping costs vary by day of the week? 
======================================================================================================= */

-- Are there any noticable sales trends over time?
SELECT
	strftime('%m',orderDate) AS month,
	SUM(freight) AS total
FROM orders
GROUP BY strftime('%m',orderDate)
ORDER BY strftime('%m',orderDate);

-- Which are the best and worst selling products?
SELECT
	p.productName,
	SUM(od.quantity) AS number_total_sold
FROM orders AS o , order_details AS od , products AS p
WHERE o.orderID = od.orderID AND p.productID = od.productID
GROUP BY p.productName
ORDER BY number_total_sold DESC
LIMIT 1; -- best selling pro
-- Camembert Pierrot is the best selling products in quantity
SELECT
	p.productName,
	SUM(od.quantity) AS number_total_sold
FROM orders AS o , order_details AS od , products AS p
WHERE o.orderID = od.orderID AND p.productID = od.productID
GROUP BY p.productName
ORDER BY number_total_sold
LIMIT 1; -- worst selling pro
-- Mishi Kobe Niku is the worst selling product in quantity

-- Can you identify any key customers?
SELECT
	cus.companyName,
	SUM((unitPrice * quantity) * (1-discount)) AS total_revenue
FROM customers as cus
LEFT JOIN orders as o
ON cus.customerID = o.customerID
LEFT JOIN order_details as od
ON o.orderID = od.orderID
GROUP BY cus.companyName
ORDER BY total_revenue DESC;
-- QUICK-stop,Ernst HandelSave-a-lot Markets is the most top 3 paid's customers

-- Are shipping costs consistent across providers?
SELECT
	sh.companyName,
	ROUND(AVG(o.freight),2) as total_charge
FROM orders as o , shippers as sh
where o.shipperID = sh.shipperID
GROUP BY sh.companyName
ORDER BY total_charge DESC;
-- speedy Express is the least pay for shipping

-- Which products show seasonal variations in sales?
SELECT
	p.productName,
	CASE
		WHEN CAST(strftime('%m',o.orderDate) AS int) BETWEEN 1 AND 3 THEN 'Q1'
		WHEN CAST(strftime('%m',o.orderDate) AS int) BETWEEN 4 AND 6 THEN 'Q2'
		WHEN CAST(strftime('%m',o.orderDate) AS int) BETWEEN 7 AND 9 THEN 'Q3'
		WHEN CAST(strftime('%m',o.orderDate) AS int) BETWEEN 10 AND 12 THEN 'Q4'
		ELSE 'Error'
	END as Quarter,
	SUM((od.unitPrice * od.quantity) * (1-od.discount)) AS total_revenue
FROM orders as o , order_details as od , products as p
WHERE o.orderID = od.orderID AND p.productID = od.productID
GROUP BY Quarter , p.productName
ORDER BY p.productName, Quarter;
-- product ส่วนใหญ่จะมีการเปลี่ยนแปลงยอดขายอย่างมีนัยยะสำคัญตามฤดูกาล

-- Do specific employees significantly impact sales, positively or negatively?
SELECT
	em.employeeName,
	CAST(SUM((od.unitPrice * od.quantity) * (1-od.discount))AS int) AS total_sale,
	CAST(AVG((od.unitPrice * od.quantity) * (1-od.discount))AS int) AS avg_sale
FROM employees as em , orders as o, order_details as od
WHERE em.employeeID = o.employeeID AND o.orderID = od.orderID
GROUP BY em.employeeName
ORDER BY total_sale DESC;
-- positively employees is Margaret in total_sale and Anne Dodsworth in avg_sale
-- negatively employees is Steven B in total_sale and Michael S in avg_sale

-- Is there a correlation between customer demographics and sales?
SELECT
	cus.country,
	sum((od.unitPrice * od.quantity) * (1-od.discount)) AS total_sale
FROM customers as cus
LEFT JOIN orders as o
ON cus.customerID = o.customerID
LEFT JOIN order_details as od
ON od.orderID = o.orderID
GROUP BY cus.country
ORDER BY total_sale DESC;
-- country's customer have significantly correlate with sales 

SELECT
	cus.city,
	sum((od.unitPrice * od.quantity) * (1-od.discount)) AS total_sale
FROM customers as cus
LEFT JOIN orders as o
ON cus.customerID = o.customerID
LEFT JOIN order_details as od
ON od.orderID = o.orderID
WHERE cus.country = 'USA'
GROUP BY cus.city
ORDER BY total_sale DESC;
-- on the best country on selling which is USA also have significantly correlation between city and sales 

-- Do shipping costs vary by day of the week?
SELECT
	CASE
		WHEN CAST(strftime('%w',orderDate)AS int)= 1 THEN 'Monday'
		WHEN CAST(strftime('%w',orderDate)AS int)= 2 THEN 'Tuesday'
		WHEN CAST(strftime('%w',orderDate)AS int)= 3 THEN 'Wednesday'
		WHEN CAST(strftime('%w',orderDate)AS int)= 4 THEN 'Thursday'
		WHEN CAST(strftime('%w',orderDate)AS int)= 5 THEN 'Friday'
		WHEN CAST(strftime('%w',orderDate)AS int)= 6 THEN 'Saturday'
		ELSE 'Sunday'
	END AS day_of_week,
	ROUND(AVG(freight),2) as avg_shipping_cost
FROM orders
GROUP BY day_of_week;
-- วันศุกร์ มีค่าส่งโดยเฉลี่ยสูงกว่าคนอื่นอย่างเห็นได้ชัด

-- สินค้าที่ส่ง มี delay บ้างไหม แล้ว shipping ไหนทำ delay มากที่สุด
WITH delay AS(SELECT
	sh.companyName,
	CAST(julianday(o.shippedDate)- julianday(o.requiredDate) AS int) AS delay_time
FROM orders as o
LEFT JOIN shippers as sh
ON o.shipperID = sh.shipperID)
SELECT
	companyName,
	COUNT(delay_time) AS num_delay
FROM delay
WHERE delay_time > 0
GROUP BY companyName
ORDER BY num_delay DESC;
-- United Package delay บ่อยมากที่สุด และ Federal Shipping delay น้อยสุด

WITH delay AS(SELECT
	sh.companyName,
	CAST(julianday(o.shippedDate)- julianday(o.requiredDate) AS int) AS delay_time
FROM orders as o
LEFT JOIN shippers as sh
ON o.shipperID = sh.shipperID)
SELECT
	companyName,
	MAX(delay_time) AS longest_delay
FROM delay
WHERE delay_time >= 0
GROUP BY companyName
ORDER BY longest_delay DESC;
-- United Package delay นานที่สุด

-- category ไหนขายดีสุด top 3 แล้วแบ่งออกมาดูรายปี
WITH join_all_table AS(SELECT
	cat.categoryID,
	cat.categoryName,
	od.unitPrice,
	od.quantity,
	od.discount,
	o.orderDate,
	cus.city,
	cus.country,
	strftime('%Y',o.orderDate) AS year_order
FROM categories as cat , products as pro , order_details as od , orders as o , customers as cus
WHERE cat.categoryID = pro.categoryID AND od.productID = pro.productID AND od.orderID = o.orderID AND o.customerID = cus.customerID)
,top3_cat AS(SELECT
	categoryName,
	year_order,
	SUM(quantity) as total_num,
	dense_rank() OVER(ORDER BY SUM(quantity) DESC) AS ranking
FROM join_all_table
GROUP BY categoryName , year_order)

SELECT
	categoryName,
	year_order as year,
	total_num
FROM top3_cat
WHERE categoryName IN (select categoryName FROM top3_cat WHERE ranking BETWEEN 1 AND 3)
ORDER BY year,total_num DESC;

-- category ไหนขายดีสุด top 3 เทียบลำดับปีต่อปี
WITH join_all_table AS(SELECT
	cat.categoryID,
	cat.categoryName,
	od.unitPrice,
	od.quantity,
	od.discount,
	o.orderDate,
	cus.city,
	cus.country,
	strftime('%Y',o.orderDate) AS year_order
FROM categories as cat , products as pro , order_details as od , orders as o , customers as cus
WHERE cat.categoryID = pro.categoryID AND od.productID = pro.productID AND od.orderID = o.orderID AND o.customerID = cus.customerID)
,top3_cat AS(SELECT
	categoryName,
	year_order,
	SUM(quantity) as total_num,
	dense_rank() OVER(PARTITION BY year_order ORDER BY SUM(quantity) DESC) AS ranking
FROM join_all_table
GROUP BY categoryName , year_order)

SELECT
	categoryName,
	year_order as year,
	total_num
FROM top3_cat
WHERE ranking BETWEEN 1 AND 3
ORDER BY year,total_num DESC;

-- แล้ว ในแต่ละประเทศ categories ไหนขายได้มากสุด
WITH join_all_table AS(SELECT
	cat.categoryID,
	cat.categoryName,
	od.unitPrice,
	od.quantity,
	od.discount,
	o.orderDate,
	cus.city,
	cus.country,
	strftime('%Y',o.orderDate) AS year_order
FROM categories as cat , products as pro , order_details as od , orders as o , customers as cus
WHERE cat.categoryID = pro.categoryID AND od.productID = pro.productID AND od.orderID = o.orderID AND o.customerID = cus.customerID)
, country_cat AS(SELECT
	country,
	categoryName,
	SUM((unitPrice * quantity) * (1 - discount)) AS total_sale
FROM join_all_table
GROUP BY country,categoryName)
SELECT
	country,
	categoryName,
	MAX(total_sale) AS best_selling
FROM country_cat
GROUP BY country
ORDER BY best_selling DESC;
