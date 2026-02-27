-- CREATE DATABASE IF NOT EXISTS zepto;
-- USE zepto;

-- create table product (
-- sku_id INT AUTO_INCREMENT PRIMARY KEY ,
-- category VARCHAR(150),
-- name VARCHAR(150) NOT NULL,
-- mrp DECIMAL(8,2),
-- discountPercent DECIMAL(5,2),
-- availableQuantity INT,
-- discountedSellingPrice DECIMAL(8,2),
-- weightInGms INT,
-- outOfStock BOOLEAN,	
-- quantity INT
-- );



-- [ DATA EXPLORATION ]

-- checking table
select * from product;

-- count of rows
select count(*) as No_of_rows from product;


-- sample data
SELECT * FROM product
LIMIT 10 ;

 
--  checking null values
SELECT * 
FROM product
WHERE name IS NULL
	OR
category IS NULL
	OR
mrp IS NULL
	OR
discountPercent IS NULL
	OR
discountedSellingPrice IS NULL
	OR
weightInGms IS NULL
	OR
availableQuantity IS NULL
	OR
outOfStock IS NULL
	OR
quantity IS NULL;

-- different product categories
SELECT DISTINCT category 
FROM product
ORDER BY category;



-- products in stock vs out of stock
 select outOfStock ,  count(sku_id) AS Total
 from product
 group by outOfStock;

select * from product;

-- product names present multiple times
select name , count(category) as No_Of_times
from product
group by name 
having No_Of_times > 1
order by No_Of_times desc ;


-- [ DATA CLEANING ]

-- products with price = 0
SELECT * FROM product
WHERE mrp = 0 OR discountedSellingPrice = 0;


DELETE FROM product
WHERE mrp = 0;



-- convert paise to rupees
UPDATE product
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

-- to disable SAFE MODE
SET SQL_SAFE_UPDATES = 0 ;


SELECT mrp, discountedSellingPrice FROM product; -- coverted into rupees 



-- [ DATA ANALYSIS ]

-- Q1. Find the top 10 best-value products based on the discount percentage.
select  distinct name , mrp , discountPercent
from product
order by discountPercent desc
LIMIT 10;



-- Q2.What are the Products with High MRP but Out of Stock
select distinct name , mrp
from product
where outOfStock = 'True'
order by mrp desc;




-- Q3.Calculate Estimated Revenue for each category
select category , sum(discountedSellingPrice * availableQuantity) as Total_Revenue
from product
group by category 
order by Total_Revenue desc;




-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
select distinct name , mrp , discountPercent
from product
where mrp > '500' AND discountPercent < 10 
order by mrp Desc ;




-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select category , ROUND(avg(discountPercent) ,2 ) as Average_Discount
from product
group by category
order by Average_Discount desc
limit 5;



-- Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name , discountedSellingPrice , weightInGms , round(discountedSellingPrice/weightInGms , 2) AS price_per_gm
from product
where weightInGms > 100 
order by price_per_gm ;




-- Q7.Group the products into categories like Low, Medium, Bulk.
select distinct name , weightInGms , 
 case when weightInGms < 1000 then "LOW"
      WHEN weightInGms < 5000 THEN "MEDIUM"
      else "BULK"
 end as weight_category
from product;



-- Q8.What is the Total Inventory Weight Per Category 
select  category , sum(availableQuantity * weightInGms) as Total_weight
from product
group by category 
order by Total_weight desc ;





