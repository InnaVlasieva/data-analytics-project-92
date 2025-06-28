-- данные по количеству уникальных покупателей и выручке, которую они принесли-customers_by_month
SELECT 
    TO_CHAR(s.sale_date, 'YYYY-MM') AS selling_month,
    COUNT(DISTINCT c.last_name) AS total_customers,
    ROUND(SUM(s.quantity * p.price), 0) AS income
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
INNER JOIN employees e ON s.sales_person_id = e.employee_id
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY TO_CHAR(s.sale_date, 'YYYY-MM')
ORDER BY selling_month ASC;