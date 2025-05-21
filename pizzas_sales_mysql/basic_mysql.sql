-- retrieve the total number of order place

SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;
    
    
-- calculate the total revenue generated from pizza sales

SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON  order_details.pizza_id = pizzas.pizza_id ;
    
    
-- identify the highest-priced pizza

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;


-- determine the distribution of order by hour of the day

SELECT 
    HOUR(order_time), COUNT(order_id)
FROM
    orders
GROUP BY HOUR(order_time);


-- join relevant tables to find the category -wise distribution of pizzas


SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;
