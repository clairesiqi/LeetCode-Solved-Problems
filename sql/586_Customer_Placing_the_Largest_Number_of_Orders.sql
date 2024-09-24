-- Write your PostgreSQL query statement below
SELECT customer_number
FROM   (
                       SELECT DISTINCT customer_number,
                                       Count(order_number) OVER(partition BY customer_number) AS count
                       FROM            orders
                       ORDER BY        count DESC) LIMIT 1