--Отчет с данными по выручке по каждому продавцу и дню недели - day_of_the_week_income
SELECT 
    e.first_name || ' ' || e.last_name AS seller,
    TO_CHAR(s.sale_date, 'Day') AS day_of_week,
    ROUND(SUM(s.quantity * p.price), 0) AS income
FROM employees e
INNER JOIN sales s ON e.employee_id = s.sales_person_id
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY e.first_name, e.last_name, 
TO_CHAR(s.sale_date, 'Day'), EXTRACT(ISODOW FROM s.sale_date)
ORDER BY EXTRACT(ISODOW FROM s.sale_date), e.last_name, e.first_name;