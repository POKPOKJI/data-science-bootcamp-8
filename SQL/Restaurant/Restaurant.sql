-- open db file
.open restaraunt.db
DROP TABLE menus;
DROP TABLE ingredient;
DROP TABLE employees;
DROP TABLE customer;
DROP TABLE menus_ingre;
DROP VIEW today_work;

--create table
CREATE TABLE IF NOT EXISTS customer (
  customer_id int UNIQUE,
  name        text,
  gender      text,
  country     text
);

CREATE TABLE IF NOT EXISTS menus (
  menus_id    int UNIQUE,
  name        text,
  price       real,
  customer_id int
);

CREATE TABLE IF NOT EXISTS employees (
  emp_id      int UNIQUE,
  name        text,
  roles       text,
  menus_id    int
);

CREATE TABLE IF NOT EXISTS ingredient (
  ingre_id    int UNIQUE,
  name        text,
  price       real
);

CREATE TABLE IF NOT EXISTS menus_ingre (
  menus_id    int,
  ingre_id    int
);

SELECT "INSERT DATA";

INSERT INTO customer VALUES
  (1,"JAY","M","THAILAND"),
  (2,"NAT","M","CHINA"),
  (3,"TOY","F","JAPAN");

INSERT INTO menus VALUES
  (1,"hot dog",50,2),
  (2,"instantnoodle",20,1),
  (3,"curry",100,3);

INSERT INTO employees VALUES
  (1,"DUNK","CHEF1",2),
  (2,"JO","CHEF2",3),
  (3,"JAMES","CHEF3",1);

INSERT INTO ingredient VALUES
  (1,"sausage",10),
  (2,"noodle",5),
  (3,"pork",40),
  (4,"olive oil",5),
  (5,"ketchup",2);

INSERT INTO menus_ingre values
  (1,1),
  (1,5),
  (1,4),
  (2,2),
  (2,3),
  (3,3),
  (3,4);


--list table into db
.table

-- change how we display data in terminal/ shell
.mode column 
SELECT * FROM customer;
SELECT * FROM menus;
SELECT * FROM employees;
SELECT * FROM ingredient;
SELECT * FROM menus_ingre;


/*SELECT 
  sub1.name,
  sub2.name AS food,
  sub2.price 
FROM ( SELECT * FROM customer
  WHERE gender = "M") AS sub1
JOIN (  SELECT * FROM menus
  WHERE price > 30) AS sub2
ON sub1.customer_id = sub2.customer_id
;*/

--create case sernario
SELECT "create case sernario";


CREATE VIEW IF NOT EXISTS today_work as
  WITH sub1 AS (
    SELECT * FROM customer
    WHERE gender = "M"), 
    sub2 AS (
    SELECT * FROM ingredient
    WHERE name <> "pork"), 
    sub3 AS (
    SELECT * FROM employees
    WHERE roles <> "CHEF2")

  SELECT
    sub1.name,
    menus.name AS food,
    menus.price AS price,
    sub3.name AS CHEF_name,
    sub2.name AS ingredient,
    sub2.price AS ingre_price
    --sub2.SUM(price) AS total
  FROM sub1
  JOIN menus
  ON sub1.customer_id = menus.customer_id
  JOIN sub3
  ON menus.menus_id = sub3.menus_id
  JOIN menus_ingre
  ON menus_ingre.menus_id = menus.menus_id
  JOIN sub2
  ON menus_ingre.ingre_id = sub2.ingre_id;

select * FROM today_work;

SELECT "FIND PROFIT";
--หา profit แบบ 1
select 
  SUM(cost) as total_cost,
  revenue,
  SUM(cost) - revenue as Profit
FROM (SELECT  SUM(price)/COUNT(name) cost  FROM today_work
      GROUP BY name)
JOIN (SELECT  SUM(ingre_price) revenue  FROM today_work);

--create cost
/*SELECT
  SUM(price)/COUNT(name) cost
FROM today_work
GROUP BY name;

--create revenue
SELECT
  SUM(ingre_price) revenue
FROM today_work;*/

--หา Profit แบบ 2
--create cost
/*CREATE VIEW IF NOT EXISTS cost as
  SELECT 
  SUM(ingre_price) AS cost
  FROM today_work;

--creat revenue
CREATE VIEW IF NOT EXISTS revenue as
  SELECT 
    SUM(price) AS revenue
  FROM (
    SELECT
    *
    FROM today_work
    GROUP BY name);

--find profit
select 
  ingre_price AS Cost,
  menus_price AS Revenue,
  menus_price - ingre_price AS Profit
from cost
join
(SELECT * from revenue);*/

.save res.db
