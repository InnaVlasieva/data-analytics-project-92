--отчет с продавцами, чья выручка ниже средней выручки всех продавцов - lowest_average_income
SELECT e.first_name || ' ' || e.last_name AS seller,
       FLOOR(AVG(s.quantity * p.price)) AS average_income
FROM employees e
INNER JOIN sales s ON e.employee_id = s.sales_person_id
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY e.first_name, e.last_name
HAVING AVG(s.quantity * p.price) < (SELECT AVG(sub.total_income)
FROM (SELECT AVG(s2.quantity * p2.price) AS total_income
FROM employees e2
INNER JOIN sales s2 ON e2.employee_id = s2.sales_person_id
INNER JOIN products p2 ON s2.product_id = p2.product_id
GROUP BY e2.employee_id
        ) sub
    )
ORDER BY average_income ASC;