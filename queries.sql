select COUNT(customer_id) as customers_count
from customers;
-- считает общее количество покупателей из таблицы customers

--  отчет с продавцами у которых наибольшая выручка - top_10_total_income.csv 
select
    e.first_name || ' ' || e.last_name as seller,
    COUNT(s.sales_id) as operations,
    FLOOR(SUM(s.quantity * p.price)) as income
from employees as e
inner join sales as s on e.employee_id = s.sales_person_id
inner join products as p on s.product_id = p.product_id
group by e.first_name || ' ' || e.last_name
order by income desc limit 10;

--отчет с продавцами, чья выручка ниже средней выручки всех продавцов - lowest_average_income
SELECT
    e.first_name || ' ' || e.last_name AS seller,
    FLOOR(AVG(s.quantity * p.price)) AS average_income
FROM employees AS e
INNER JOIN sales AS s ON e.employee_id = s.sales_person_id
INNER JOIN products AS p ON s.product_id = p.product_id
GROUP BY e.first_name, e.last_name
HAVING
    AVG(s.quantity * p.price) < (
        SELECT AVG(sub.total_income)
        FROM (
            SELECT AVG(s2.quantity * p2.price) AS total_income
            FROM employees AS e2
            INNER JOIN sales AS s2 ON e2.employee_id = s2.sales_person_id
            INNER JOIN products AS p2 ON s2.product_id = p2.product_id
            GROUP BY e2.employee_id
        ) AS sub
    )
ORDER BY average_income ASC;

--Отчет с данными по выручке по каждому продавцу и дню недели - day_of_the_week_income
SELECT
    e.first_name || ' ' || e.last_name AS seller,
    TO_CHAR(s.sale_date, 'day') AS day_of_week,
    FLOOR(SUM(s.quantity * p.price)) AS income
FROM employees AS e
INNER JOIN sales AS s ON e.employee_id = s.sales_person_id
INNER JOIN products AS p ON s.product_id = p.product_id
GROUP BY
    e.first_name || ' ' || e.last_name,
    TO_CHAR(s.sale_date, 'day'), EXTRACT(ISODOW FROM s.sale_date)
ORDER BY EXTRACT(ISODOW FROM s.sale_date), e.first_name || ' ' || e.last_name;

-- количество покупателей в разных возрастных группах - age_groups
SELECT 
    CASE 
        WHEN age BETWEEN 16 AND 25 THEN '16-25'
        WHEN age BETWEEN 26 AND 40 THEN '26-40'
        ELSE '40+'
    END AS age_category,
    COUNT(customer_id) AS age_count
FROM customers
GROUP BY age_category
order by age_category;

-- данные по количеству уникальных покупателей и выручке, которую они принесли-customers_by_month
SELECT 
    TO_CHAR(s.sale_date, 'YYYY-MM') AS selling_month,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    FLOOR (SUM(s.quantity * p.price)) AS income
FROM employees e
INNER JOIN sales s on e.employee_id = s.sales_person_id
INNER JOIN products p  on s.product_id = p.product_id    
INNER join customers c on c.customer_id = s.customer_id    
GROUP BY TO_CHAR(s.sale_date, 'YYYY-MM')
ORDER BY selling_month ASC;

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
FROM employees e
INNER JOIN sales s on e.employee_id = s.sales_person_id
INNER JOIN products p  on s.product_id = p.product_id    
INNER join customers c on c.customer_id = s.customer_id    
INNER JOIN first_sales fs 
    ON c.customer_id = fs.customer_id 
    AND s.sale_date = fs.first_sale_date
WHERE p.price = 0
ORDER BY customer;

