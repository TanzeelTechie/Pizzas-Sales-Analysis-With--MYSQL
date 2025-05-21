-- group the orders by date and calculate the average numbers of pizzas ordered per day

SELECT 
    ROUND(AVG(quantity), 0) AS avg_pizza_ordered_per_day
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;


-- calculate the percentage contribution of each pizza type to total revenue

SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON order_details.pizza_id = pizzas.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;


-- analyze the cumulative revenue generated over time

SELECT 
	order_date, sum(revenue) over (partition by order_date ) AS cum_revenue 
FROM
	(select orders.order_date,sum(order_details.quantity * pizzas.price)  AS revenue 
FROM
	order_details JOIN  pizzas
	ON  order_details.pizza_id =pizzas.pizza_id
	JOIN orders
	ON  orders.order_id =order_details.order_id
	GROUP BY  orders.order_date) AS sales;

-- determine the top 3 most ordered pizza types based on revenue for each pizza category
select name,revenue from
(select name,category,revenue, rank() over(partition by category order by revenue desc) as rn
from
(select pizza_types.name, pizza_types.category, sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name, pizza_types.category ) as a )as b
where rn <=3;