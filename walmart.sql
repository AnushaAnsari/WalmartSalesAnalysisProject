-- Create database--
CREATE DATABASE IF NOT EXISTS walmartSales;

use walmartSales;

-- UPLOAD TABLE--

SELECT * FROM sales;

-- MAKE CHANGES IN THE TABLE --

SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(STR_TO_DATE(COALESCE(date, '2000-01-01'), '%d-%m-%Y'));

SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(STR_TO_DATE(date, '%d-%m-%Y %H:%i:%s'));

-- QUESTIONS --

-- 1.How many unique cities does the data have?--
Select distinct City from sales;  

-- 2. In which city is each branch? --
select distinct city, branch from sales;

-- 3. How many unique product lines does the data have? --
select distinct product_line from sales;

-- 4. What is the most selling product line --
select sum(quantity) as qty, product_line
from sales
group by product_line
order by qty desc;

-- 5.  What is the total revenue by month --
select month_name as month,
sum(total) as total_Revenue
from sales
group by month_name
order by total_Revenue DESC;

-- 6. What month had the largest COGS? --
select month_name as month,
sum(cogs) as max_cogs
from sales
group by month
order by max_cogs desc;

-- 7. What product line had the largest revenue? --

select product_line, 
sum(total) as revenue
from sales
group by product_line
order by revenue desc;

-- 8.  What is the city with the largest revenue? --
select city,
sum(total) as revenue
from sales
group by city
order by revenue desc;

-- 9. Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 5.5 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- 10. -- Which branch sold more products than average product sold? 

select branch, 
sum(quantity) 
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- 11. What is the most common product line by gender --
select gender, product_line,
count(gender) as tot
from sales
group by gender, product_line
order by tot desc limit 1;

-- 12. What is the average rating of each product line --
select round(avg(rating),2) as average
, product_line
from sales
group by product_line
order by  average desc;

-- 13. How many unique payment methods does the data have?

select distinct Payment from sales;

-- 14. What is the gender of most of the customers?
select gender,
count(*) as tot
from sales
group by gender
order by tot desc limit 1;

-- 15. What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;

-- 16. Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	round(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- 17. Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- 18. Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;

-- 19. Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
GROUP BY day_name
ORDER BY total_sales DESC;

-- 20. Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day 
ORDER BY total_sales DESC;

