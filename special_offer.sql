-- с покупателями первая покупка которых пришлась на время проведения специальных акций - special_offer
WITH first_sales AS (
    SELECT 
        customer_id,
        MIN(sale_date) AS first_sale_date
    FROM sales
    GROUP BY customer_id
)
SELECT DISTINCT
    c.first_name || ' ' || c.last_name AS customer,
    TO_CHAR(s.sale_date, 'YYYY-MM-DD') AS sale_date,
    e.first_name || ' ' || e.last_name AS seller
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
INNER JOIN products p ON s.product_id = p.product_id
INNER JOIN employees e ON s.sales_person_id = e.employee_id
INNER JOIN first_sales fs 
    ON c.customer_id = fs.customer_id 
    AND s.sale_date = fs.first_sale_date
WHERE p.price = 0
ORDER BY customer;