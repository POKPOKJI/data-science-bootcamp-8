-- Data Cleaning for Northwind traders Analytics Project
-- Check duplicate categories
SELECT
	companyName,
	COUNT(companyName)
FROM customers
GROUP BY companyName
HAVING COUNT(companyName) > 1;

SELECT
	customerID,
	COUNT(customerID)
FROM customers
GROUP BY customerID;

SELECT
	contactName,
	COUNT(contactName)
FROM customers
GROUP BY contactName;

SELECT
	*
FROM orders;

SELECT
	productName,
	COUNT(productName)
FROM products
GROUP BY productName;



-- check dulicated หมดแล้วไม่มีตัวไหนซ้ำถึงแม้ว่า ชื่อบางอันตัวอักษรนะเพี้ยนๆ


-- change type ให้ตรงกับ ER diagram
-- แก้ใน database structure ได้เลย กด modify table ถ้าต้องมานั่ง code ถ้าจะพิมพ์ใช้ Alter table , update table set ... = cast(... as type)
