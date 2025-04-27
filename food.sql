create database sale;
use sale ;
create table orders (
order_id int not null,
order_date  date not null ,
order_time time not null ,
primary key (order_id));

create table order_details (
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null, 
primary key (order_details_id));
-- Retrieve the total number of orders placed.
SELECT COUNT(order_id) AS total_orders
FROM orders;

-- Calculate the total revenue generated from pizza sales.
SELECT ROUND(SUM(pizzas.price * order_details.quantity), 2) AS total_revenue
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id;

-- Identify the highest-priced pizza.
SELECT pizza_id, price
FROM pizzas
ORDER BY price DESC
LIMIT 1;

-- Identify the most common pizza size ordered.
SELECT pizzas.size, COUNT(order_details.pizza_id) AS frequency
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.size
ORDER BY frequency DESC
LIMIT 1;


-- List the top 5 most ordered pizza types along with their quantities.
 
SELECT pizzas.pizza_type_id, SUM(order_details.quantity) AS total_quantity
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.pizza_type_id
ORDER BY total_quantity DESC
LIMIT 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pizza_types.category, SUM(order_details.quantity) AS total_quantity
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
JOIN pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.category
ORDER BY total_quantity DESC;

-- Determine the distribution of orders by hour of the day.
SELECT HOUR(order_time) AS order_hour, COUNT(*) AS total_orders
FROM orders
GROUP BY HOUR(order_time)
ORDER BY order_hour;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT orders.order_date, AVG(daily_pizzas.total_quantity) AS average_pizzas
FROM orders
JOIN (
    SELECT order_id, SUM(order_details.quantity) AS total_quantity
    FROM order_details
    GROUP BY order_id
) AS daily_pizzas ON orders.order_id = daily_pizzas.order_id
GROUP BY orders.order_date
ORDER BY orders.order_date;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT pizzas.pizza_type_id, SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.pizza_type_id
ORDER BY total_revenue DESC
LIMIT 3;

-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT pizzas.pizza_type_id, 
       SUM(order_details.quantity * pizzas.price) AS total_revenue,
       ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT SUM(order_details.quantity * pizzas.price) 
                                                          FROM order_details
                                                          JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id) * 100, 2) AS percentage_contribution
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.pizza_type_id
ORDER BY percentage_contribution DESC;


