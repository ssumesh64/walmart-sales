create database if not exists Walmart_Sales;

create table if not exists sales(
       invoice_id varchar(30) not null primary key, 
       branch varchar(5) not null,
       city varchar(30) not null,
       customer_type varchar(30) not null,
       gender varchar(10) not null,
       product_line varchar(100) not null,
       unit_price decimal(10,2) not null,
       quantity int not null,
       vat float(6,4) not null,
       total decimal(12,4) not null,
       date datetime not null,
       time time not null,
       payment_method varchar(15) not null,
       cogs decimal(10,2) not null,
       gross_margin_pct float(11,9),
       gross_income decimal(12,4) not null,
       rating float(2,1)
);



-- --------------------------------------------------------------------------------------------------
-- -----------------------  FEATURE ENGINEERING -----------------------------------------------------

-- time_of _date

select 
     time,
     (case 
		when `time` between "00:00:00" and "12:00:00" then "morning"
        when `time` between "12:01:00" and "16:00:00" then "afternoon"
        else "evening"
	 end 
      ) as time_of_date   
from sales;     

alter table sales add column time_of_day varchar(20);

update sales 
set time_of_day =(
               case 
		when `time` between "00:00:00" and "12:00:00" then "morning"
        when `time` between "12:01:00" and "16:00:00" then "afternoon"
        else "evening"
	 end 
     );
     
-- day_name 

select 
      date ,
      dayname(date) as day_name
from sales ;      

alter table sales add column day_name varchar(10);
update sales 
set day_name = dayname(date);

-- month_name 

select
      date,
      monthname(date) as month_name
from sales;      

alter table sales add column month_name varchar(10);

update sales
set month_name = monthname(date);
-- ----------------------------------------------------------------------------------

-- ----------------------  GENERIC QUESTIONS ----------------------------------------

-- 1. How many unique cities does the data have?

select distinct city
from sales ;

-- 2. In which city is each branch?

select distinct city,branch
from sales; 

-- --------------------------PRODUCT QUESTIONS-----------------------------------------

-- 1. How many unique product lines does the data have?
select 
      distinct product_line
from sales ;

-- 2. What is the most common payment method?

select payment_method,
       count(payment_method) as total_count
from sales       
group by payment_method
order by total_count desc;

-- 3. What is the most selling product line?

select product_line,
       count(product_line) as total_products
from sales 
group by product_line 
order by total_products desc ;   

-- 4. What is the total revenue by month?

select month_name as month,
       sum(total) as total_revenue
from sales 
group by month_name
order by total_revenue desc ;	

-- 5. What month had the largest COGS?

select month_name, 
       sum(cogs) as largest_cogs
from sales 
group by month_name
order by largest_cogs desc ;      

-- 6. What product line had the largest revenue?         

select product_line,
       sum(total) as revenue
from sales 
group by product_line
order by revenue desc; 

-- 7. What is the city with the largest revenue?  

select city,branch,
       sum(total) as largest_revenue
from sales 
group by city,branch 
order by largest_revenue desc;      

-- 8. What product line had the largest VAT?

select product_line,
       avg(vat) as largest_vat 
from sales 
group by product_line 
order by largest_vat desc;       


-- 9. Which branch sold more products than average product sold?
select branch, 
	   sum(quantity) as total_quantity
from sales 
group by branch 
having total_quantity > (select avg(quantity) from sales);       

-- 10. What is the most common product line by gender?
 
 select gender, 
        product_line, 
        count(gender) as total_count
from sales
group by gender,product_line
order by total_count desc;      

-- 11. What is the average rating of each product line?  

select
       product_line,
       round(avg(rating),2) as average_rating
from sales 
group by product_line
order by average_rating desc;     

-- -----------------------------------SALES QUESTIONS------------------------------------------------

-- 1. Number of sales made in each time of the day per weekday
select time_of_day,
	   count(*) as total_sales 
from sales    
where day_name = 'saturday'
group by time_of_day
order by total_sales desc;

-- 2. Which of the customer types brings the most revenue?

select customer_type, 
	sum(total) as most_revenue
from sales 
group by customer_type 
order by most_revenue desc;  

-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?  

select city,
       avg(vat) as value_added_tax
from sales 
group by city 
order by value_added_tax desc;  

-- 4. Which customer type pays the most in VAT?

select customer_type,
	   avg(vat) as most_vat
from sales 
group by customer_type 
order by most_vat desc;    

-- -------------------------------CUSTOMER QUESTIONS--------------------------------------------------

-- 1. How many unique customer types does the data have?

select distinct customer_type 
from sales;

-- 2. How many unique payment methods does the data have?

select distinct payment_method
from sales;

-- 3. What is the most common customer type?

select customer_type, 
       count(customer_type) as most_common
from sales 
group by customer_type 
order by most_common desc;     

-- 4. Which customer type buys the most?

select customer_type,
       count(total) as most_buys
from sales 
group by customer_type 
order by most_buys desc;    

-- 5. What is the gender of most of the customers?   

select gender,
	   count(gender) as most_customers
from sales 
group by gender 
order by most_customers desc; 

-- 6. What is the gender distribution per branch?

select gender,
       count(*) as gender_per_branch
from sales 
where branch = 'c'
group by gender
order by gender_per_branch;   

-- 7. Which time of the day do customers give most ratings?

select time_of_day ,
	   avg(rating) as most_rating
from sales 
group by time_of_day
order by most_rating desc;  

-- 8. Which time of the day do customers give most ratings per branch?   

select time_of_day, 
       avg(rating) as most_rating
from sales 
where branch = 'b'
group by time_of_day
order by most_rating desc;

-- 9. Which day fo the week has the best avg ratings?

select day_name,
       avg(rating) as avg_rating
from sales 
group by day_name
order by avg_rating desc;  

-- 10. Which day of the week has the best average ratings per branch?

select day_name,
       avg(rating) as avg_rating 
from sales 
where branch = 'c'
group by day_name 
order by avg_rating desc;      







       









       
        


         






  

