SELECT *
  FROM [dbo].[zepto_v2]
--- Data Exploration

select count(*)
from [dbo].[zepto_v2];

--sample data

SELECT TOP 10 *
  FROM [dbo].[zepto_v2]

;
-- NULL Values


SELECT *
  FROM [dbo].[zepto_v2]
  where
  name IS NULL
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

-- aLL Product categories

SELECT DISTinct Category
  FROM [dbo].[zepto_v2]
  order by Category ;

  --- Product In-stock Vs out-of-stock
    
SELECT outOfStock, count(*)
  FROM [dbo].[zepto_v2]
  group by outOfStock;
 
 
 --- Product names present multiple times

     
SELECT name, count(*)
  FROM [dbo].[zepto_v2]
  group by name
  having count(*) > 1
  order by count(*) desc;

  ---Data Cleaning
   --- Product where price is 0
SELECT *
  FROM [dbo].[zepto_v2]
  where mrp = 0 or discountedSellingPrice= 0;
  -- we have to delete this row
delete
  FROM [dbo].[zepto_v2]
  where mrp = 0 ;
  

  -- convert  paise into Rupees
update [dbo].[zepto_v2]
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0 ;

SELECT mrp , discountedSellingPrice
  FROM [dbo].[zepto_v2];

  -- Q1. Find the top 10 best-value products based on the discount percentage.
  SELECT top(10) name,mrp , discountPercent
  FROM [dbo].[zepto_v2]
  order by discountPercent desc
;

--Q2.What are the Products with High MRP but Out of Stock

 SELECT distinct name,mrp 
  FROM [dbo].[zepto_v2]
  where outOfStock = 1 and mrp > 300
  order by mrp desc
   ;

   --Q3.Calculate Estimated Revenue for each category
   SELECT Category ,
   Sum(discountedSellingPrice * availableQuantity) as total_revenue
  FROM [dbo].[zepto_v2]
  group by Category
  order by total_revenue desc;

  -- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.

   SELECT distinct name,mrp, discountPercent
  FROM [dbo].[zepto_v2]
  where mrp > 500 and discountPercent <10
  order by mrp desc, discountPercent desc
  ;

  -- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT top(5) category,
ROUND(AVG(discountPercent),2) AS avg_discount
  FROM [dbo].[zepto_v2]
GROUP BY category
ORDER BY avg_discount DESC
;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
  FROM [dbo].[zepto_v2]
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
  FROM [dbo].[zepto_v2];

--Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
  FROM [dbo].[zepto_v2]
GROUP BY category
ORDER BY total_weight;

