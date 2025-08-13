-- SQL RETAIL SALES ANALYSIS -P1
create database sql_project_p1;

-- create table 
drop table if exists retail_sales;
create table retail_sales (
    transactions_id	 int primary key,
    sale_date	date,
    sale_time	time,
    customer_id	int ,
    gender varchar(10),
	age int,
	category varchar(60),
	quantiy int,
	price_per_unit	float,
    cogs	float,
    total_sale float
);

select * from retail_sales
limit 10; 

-- data cleaning

select count(*) from retail_sales;

select * from retail_sales where transactions_id is null;
select * from retail_sales where sale_date is null;

select * from retail_sales
  where transactions_id is null
  or 
  sale_date is null
  or 
  sale_time is null
  or 
  gender is null
  or category is null
  or quantiy is null or
  cogs is null
  or total_sale is null;

DELETE FROM retail_sales
WHERE
    transactions_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    gender IS NULL OR
    category IS NULL OR
    quantiy IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;
    
-- data exploration
-- ======================================== 
-- how many sales we have
select count(transactions_id) as total_sales from retail_sales;

-- howmany customers we have
select  count(distinct customer_id) from retail_sales;

-- how many category we have
select	count( distinct category) from retail_sales;

-- which catagories we have
select distinct category from retail_sales;

-- data analysis & business key problems & answers
-- ----------------------------------- 
 -- 1. retrieve all columns for slaes made on '2022-11-05'
 select * from retail_sales where sale_date ="2022-11-05" ;
 
 -- 2.retrieve all transactions where the category is 'clothing' and the quantity is more than equal to 4 in month of november-2022
select * from retail_sales where category="Clothing" and quantiy >=4 and date_format(sale_date,'%Y-%m')="2022-11"; 

-- 3.calculate total sales for each category
select category,sum(total_sale),count(*)  as total_orders from retail_sales group by category;

-- 4.find average age of  customers who puchased items from the category 'beauty'
select round(avg(age),2),category from retail_sales where category="Beauty" ;

-- 5.find all transactions where the total_sale is greaterthan 1000
select * from retail_sales where total_sale > 1000;

-- 6.find the total number of transactions (transaction_id ) made by each gender in each category
select count(transactions_id) as total_transactions,gender,category from retail_sales group by gender, category order by category;

-- 7.calculate average sales for each month ,find out best selling month in each year
select date_format(sale_date,'%y-%M')as sale_month, avg(total_sale) from retail_sales group by date_format(sale_date,'%y-%M') order by min(sale_date);


select * from(
select year(sale_date) as year,month(sale_date)as month,avg(total_sale) as average_sale ,
rank() over(partition by year(sale_date)order by avg(total_sale) desc) as rank_order 
from retail_sales
   group by 1,2
   ) as t1
   where rank_order=1;

-- 8. find the top 5 customers based on the highest total sales
select customer_id,sum(total_sale) as total_sales from retail_sales 
group by customer_id
 order by total_sales
 desc limit 5;
 
-- 9.find the number of unique customers who purchased item from each category
select count(distinct customer_id) as no_of_customers,category from retail_sales group by category;

-- 10.create each shifts and no.og orders (eg:= morning <=12,afternoon 12&17,evening >17)
select case
   when hour(sale_time) <=12 then 'morning'
   when hour(sale_time)between 12 and 17 then 'afternoon'
   else 'evening'
end as shifts,
sum(transactions_id) as no_of_orders from retail_sales
group by shifts
order by min(sale_time);

-- 11.What are the top 5 best-selling products by quantity?
select category ,sum(quantiy) as total_quantity_sold from retail_sales group by category order by total_quantity_sold  desc limit 5;

-- 12.What was the total sales amount for each month?
select sum(total_sale) as total_sales ,year(sale_date) as year,month(sale_date) as month from retail_sales group by year,month order by year,month ;

-- 13.What is the total profit for the business?
select (sum(total_sale-cogs)) as total_profit from retail_sales ;

-- 14.What are the busiest hours for sales?
select hour(sale_time) as Hour, count(transactions_id) as total_orders
from retail_sales group by Hour 
order by total_orders 
limit 5;
