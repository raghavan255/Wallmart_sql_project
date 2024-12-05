use python_project;
show tables;
desc df_walmart;
##q2 select highest avg rating of each branch and also display category 
with get_max as (select branch,category,avg(rating)as avgg,rank() over(partition by branch order by avg(rating) desc) as ranks from df_walmart group by branch,category order by branch,avgg desc )
select * from get_max where ranks = 1;
##q3 identify the busiest day for each branch by number of transactions 
select * from df_walmart order by branch;
 with got_ranks as (select count(invoice_id)as transactions , 
branch ,dayname(str_to_date(date,'%d/%m/%y')) as formatted_day, rank() over (partition by branch order by count(invoice_id) desc) as ranks
from df_walmart group by branch,formatted_day order by branch, transactions desc )
select * from got_ranks where ranks =1;
##q4 calculate total wuantity of items per payment method list payment ma=ethod and total quantity
select sum(quantity) as 'total quantity', payment_method from df_walmart group by payment_method ;
##q5  determine the min ,max,avg  rating of pdts for each city 
select min(rating) as min,max(rating)as max,avg(rating) as avgg,city from df_walmart group by city;
## calculate total profit for each category by considering total_profit as (unit_price * quantity * profit_margin),list category and highest_profit 
select category,sum(unit_price * quantity * profit_margin) as total_profit from df_walmart group by category  order by total_profit desc ;
##q7 determine the most common payment method for each branch,display branch and preferef payment 
select count(*) as 'no of times', payment_method from df_walmart group by payment_method ;
with got_ranks as (select count(*) as 'no of payment times', 
payment_method, branch ,rank() over ( partition by branch order by count(*) desc ) as ranks 
from df_walmart group by payment_method,branch order by branch, 'no of payment times' desc) 
select *,payment_method as preffered_payment  from got_ranks where ranks =  1;
##q8 categorize sales into 3 groups morning,afternoon,evening,find out whic of the shift and numbber of invoices 
select * from df_walmart ;
desc df_walmart ;
select time , cast(time as time) as timee from df_walmart;
select count(invoice_id) as 'no of invoices',branch, case 
when cast(time as time) between '00:00:00' and '11:59:59' then 'Morning'
when  cast(time as time) between '12:00:00' and '17:59:59' then 'Afternoon'
when cast(time as time) between '18:00:00' and '23:59:59' then 'Evening'
end as shift 
from df_walmart group by branch,shift order by branch
 ;
##q9 identify the 5 branches with highest descrease in revenue compared to last yeaar rev in 2022 and 2023 decrease in rev =  (lasy_yr rev - current rev /last_yr rev )*100
desc df_walmart ;
select count(*) ,year(str_to_date(date,'%d/%m/%y')) as yearr  from df_walmart group by yearr order by yearr;
with rev_2022 as (select branch,sum(total_price) as revenue2022 from df_walmart where year(str_to_date(date,'%d/%m/%y')) = 2022 group by branch),
 rev_2023 as (select branch,sum(total_price) as revenue2023 from df_walmart where year(str_to_date(date,'%d/%m/%y')) = 2023 group by branch)
 select  ls.branch as branch, ls.revenue2022 as revenue2022,cs.revenue2023 as revenue2023, round(((ls.revenue2022 - cs.revenue2023)/ls.revenue2022)*100,2)as decrease_ratio 
 from rev_2022 as ls  join rev_2023 as cs  on ls.branch  = cs.branch where ls.revenue2022 > cs.revenue2023 order by decrease_ratio desc limit 5 ;
 ##q1 find the different payment method , number of transactions and number of quantity sold 
 select payment_method,count(*) as 'no of transactions',sum(quantity) as'no of quantity sold' from df_walmart group by payment_method;
 



