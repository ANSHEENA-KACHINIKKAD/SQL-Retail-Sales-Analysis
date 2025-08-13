# Retail Sales Data Analysis with SQL

### Project Description

This project demonstrates a comprehensive data analysis of a retail sales dataset using only SQL. The primary goal was to load and query data to derive actionable business insights and showcase proficiency in data manipulation and analysis. The project focuses on key business questions related to sales performance, profitability, and customer behavior.

### Key Features

* **Database Management**: Used MySQL to manage and query a retail sales dataset.
* **Performance Metrics**: Calculated total monthly sales, average order value, and total profit to assess the business's financial performance.
* **Operational Insights**: Identified peak sales hours to provide recommendations for operational planning and resource allocation.
* **Business Analysis** :
  
   * calculate total sales for each category

         select category,sum(total_sale),count(*)  as total_orders from retail_sales group by category;
   * find average age of  customers who puchased items from the category 'beauty'

         select round(avg(age),2),category from retail_sales where category="Beauty" ;
   * find the total number of transactions (transaction_id ) made by each gender in each category

         select count(transactions_id) as total_transactions,gender,category from retail_sales group by gender, category order by category;
   * calculate average sales for each month ,find out best selling month in each year
  
          select * from(
          select year(sale_date) as year,month(sale_date)as month,avg(total_sale) as average_sale ,
          rank() over(partition by year(sale_date)order by avg(total_sale) desc) as rank_order 
          from retail_sales
             group by 1,2
             ) as t1
             where rank_order=1;

   * find the top 5 customers based on the highest total sales
     
         find the top 5 customers based on the highest total sales
          select customer_id,sum(total_sale) as total_sales from retail_sales 
          group by customer_id
         order by total_sales
         desc limit 5;

   * find the number of unique customers who purchased item from each category

         select count(distinct customer_id) as no_of_customers,category from retail_sales group by category;

   * create each shifts and no.og orders (eg:= morning <=12,afternoon 12&17,evening >17)

         select case
               when hour(sale_time) <=12 then 'morning'
               when hour(sale_time)between 12 and 17 then 'afternoon'
               else 'evening'
            end as shifts,
            sum(transactions_id) as no_of_orders from retail_sales
            group by shifts
            order by min(sale_time);
  * What are the top 5 best-selling products by quantity?

        select category ,sum(quantiy) as total_quantity_sold from retail_sales group by category order by total_quantity_sold  desc limit 5;
  * What was the total sales amount for each month?

        select sum(total_sale) as total_sales ,year(sale_date) as year,month(sale_date) as month from retail_sales group by year,month order by year,month ;
  * What is the total profit for the business?
  
         select (sum(total_sale-cogs)) as total_profit from retail_sales ;
  * What are the busiest hours for sales?

        select hour(sale_time) as Hour, count(transactions_id) as total_orders
        from retail_sales group by Hour 
        order by total_orders 
        limit 5;
    
### Technologies Used

* **Database**: MySQL
* **Language**: SQL
* **Tools**: MySQL Workbench
