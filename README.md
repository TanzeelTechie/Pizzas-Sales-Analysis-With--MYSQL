
# 🍕 Pizza Sales Analysis using MySQL

A complete SQL-based project to analyze pizza sales data for a fictional pizzeria. This project demonstrates the ability to manage, query, and analyze data using MySQL with real-world business scenarios.

---

## 📌 Project Objectives

- Create and manage a pizza sales database.
- Write and execute SQL queries to derive business insights.
- Use joins, aggregations, subqueries, and window functions.
- Analyze customer behavior and pizza performance.

---

## 🗃️ Database Schema

**Tables:**

- `orders` – Order ID, date, time.
- `order_details` – Order ID, pizza ID, quantity.
- *(Inferred)* `pizzas` – Pizza ID, size, price, type ID.
- *(Inferred)* `pizza_types` – Type ID, name, category.

Defined in `pizzas_sales.sql`:
```sql
CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY(order_id)
);

CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY(order_details_id)
);
```

---

## 📁 SQL Scripts Overview

### 1. `basic_mysql.sql`
- **Total number of orders**
```sql
SELECT COUNT(order_id) AS total_orders FROM orders;
```

- **Total revenue from pizza sales**
```sql
SELECT ROUND(SUM(order_details.quantity * pizzas.price), 2) AS total_sales
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id;
```

- **Highest-priced pizza**
```sql
SELECT pizza_types.name, pizzas.price
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;
```

- **Hourly distribution of orders**
```sql
SELECT HOUR(order_time), COUNT(order_id)
FROM orders
GROUP BY HOUR(order_time);
```

- **Category-wise pizza distribution**
```sql
SELECT category, COUNT(name)
FROM pizza_types
GROUP BY category;
```

---

### 2. `Aggregation_grouping.sql`
- **Most common pizza size**
```sql
SELECT pizzas.size, COUNT(order_details.order_details_id) AS count
FROM pizzas
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY count DESC;
```

- **Top 5 most ordered pizza types**
```sql
SELECT pizza_types.name, SUM(order_details.quantity) AS quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;
```

- **Quantity by category**
```sql
SELECT pizza_types.category, SUM(order_details.quantity) AS quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;
```

- **Top 3 pizzas by revenue**
```sql
SELECT pizza_types.name, SUM(order_details.quantity * pizzas.price) AS revenue
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;
```

---

### 3. `subqueries.sql`
- **Average pizzas ordered per day**
```sql
SELECT ROUND(AVG(quantity), 0) AS avg_pizza_ordered_per_day
FROM (
    SELECT orders.order_date, SUM(order_details.quantity) AS quantity
    FROM orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date
) AS order_quantity;
```

- **Revenue contribution by category**
```sql
SELECT pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / 
    (SELECT SUM(order_details.quantity * pizzas.price)
     FROM order_details
     JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id) * 100, 2) AS revenue
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;
```

- **Cumulative revenue by date**
```sql
SELECT order_date, SUM(revenue) OVER (PARTITION BY order_date) AS cum_revenue
FROM (
    SELECT orders.order_date, SUM(order_details.quantity * pizzas.price) AS revenue
    FROM order_details
    JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
    JOIN orders ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date
) AS sales;
```

- **Top 3 pizzas by revenue per category**
```sql
SELECT name, revenue
FROM (
    SELECT name, category, revenue, RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
    FROM (
        SELECT pizza_types.name, pizza_types.category, SUM(order_details.quantity * pizzas.price) AS revenue
        FROM pizza_types
        JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
        GROUP BY pizza_types.name, pizza_types.category
    ) AS a
) AS b
WHERE rn <= 3;
```

---

## ✅ Requirements

- MySQL or compatible RDBMS
- SQL client (e.g., DBeaver, MySQL Workbench)

---

## 📎 How to Use
1. The Repository:
   
2. Run `pizzas_sales.sql` to create tables.
3. Insert data into tables (manually or via CSV).
4. Use other `.sql` files to perform analysis.
5. Explore business metrics and visualize insights using SQL.

---
