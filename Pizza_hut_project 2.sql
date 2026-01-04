create table pizza(
                  pizza_id varchar(100),
				  pizza_type_id varchar(100),
				  size  varchar(10),
				  price numeric(10,2)
);
select * from pizza;

create table typ(
                  pizza_type_id varchar(100),
				  name varchar(100),
				  category varchar(100),
				  ingredients varchar(100)
);
drop table typ;
select * from typ;

create table orders(
                  order_id int primary key,
				  date  date,
				  time   time
);
select * from orders;

create table details(
                   order_details_id int primary key,
				   order_id int,
				   pizza_id  varchar(100),
				   quantity  int
);
select * from details;

copy pizza(pizza_id,pizza_type_id,size,price)
from 'C:\Users\pranay\Desktop\SQL Project_Data\pizza_sales_Project 2\pizzas.csv'
csv header;

copy typ(pizza_type_id,name,category,ingredients)
from 'C:\Users\pranay\Desktop\SQL Project_Data\pizza_sales_Project 2\pizza_types.csv'
csv header;

copy orders(order_id,date,time)
from 'C:\Users\pranay\Desktop\SQL Project_Data\pizza_sales_Project 2\orders.csv'
csv header;

copy details(order_details_id,order_id,pizza_id,quantity)
from 'C:\Users\pranay\Desktop\SQL Project_Data\pizza_sales_Project 2\order_details.csv'
csv header;

select * from pizza;
select * from typ;
select * from orders;
select * from details;

--1. Retrieve the total number of orders placed.
select count(*) from orders;

--2 Calculate the total revenue generated from pizza sales.
select sum(p.price*d.quantity) as total_sales from pizza p join details d
on p.pizza_id=d.pizza_id;

--3 Identify the highest-priced pizza.
select price from pizza order by price desc limit 1;

select t.name,p.price from typ t join pizza p on p.pizza_type_id=t.pizza_type_id
order by p.price desc limit 1;

--4 Identify the most common pizza size ordered
select p.size,count(d.order_id) as ordered from pizza p join details d on p.pizza_id=d.pizza_id
group by p.size order by ordered;

--5 List the top 5 most ordered pizza types along with their quantities.
select t.name,sum(d.quantity) as quantity_type from details d join pizza p on p.pizza_id=d.pizza_id
join typ t on p.pizza_type_id=t.pizza_type_id
group by t.name order by quantity_type desc limit 5;

select t.name,sum(d.quantity) as type_qty from typ t join pizza p on p.pizza_type_id=t.pizza_type_id
join details d on d.pizza_id=p.pizza_id
group by t.name order by type_qty desc limit 5;

--6 Join the necessary tables to find the total quantity of each pizza category ordered.
select t.category,sum(d.quantity) as each_cat from typ t join pizza p on p.pizza_type_id=t.pizza_type_id
join details d on p.pizza_id=d.pizza_id
group by t.category order by each_cat desc;

--7 Determine the distribution of orders by hour of the day.
select extract(hour from time) as hour,count(order_id) from orders
group by hour order by count(order_id);

--8 Join relevant tables to find the category-wise distribution of pizzas.
select category,count(name) from typ group by category;

--9 Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(sum_quantity) from (select o.date,sum(d.quantity) as sum_quantity from orders o join details d on o.order_id=d.order_id
group by o.date);

--10 Determine the top 3 most ordered pizza types based on revenue.
select t.name,sum(p.price*d.quantity) as revenue from typ t join pizza p on p.pizza_type_id=t.pizza_type_id
join details d on p.pizza_id=d.pizza_id
group by t.name order by revenue desc limit 3 ;

--11 Calculate the percentage contribution of each pizza type to total revenue.
select t.name,sum(d.quantity*p.price)*100/(select sum(d2.quantity*p2.price) 
from details d2 join pizza p2 on d2.pizza_id=p2.pizza_id) as revenue
from details d join pizza p on d.pizza_id=p.pizza_id join typ t on p.pizza_type_id=t.pizza_type_id
group by t.name order by revenue desc;

--12 Analyze the cumulative revenue generated over time.
select o.date,sum(p.price*d.quantity) as daily_revenue,sum(sum(p.price*d.quantity))
over(order by o.date) as cummlative from orders o join details d on o.order_id=d.order_id
join pizza p on p.pizza_id=p.pizza_id group by o.date order by o.date;

--13 










