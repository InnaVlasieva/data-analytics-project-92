SELECT COUNT(c.customer_id) AS customers_count
FROM customers c;
-- считает общее количество покупателей из таблицы customers

--  отчет с продавцами у которых наибольшая выручка - top_10_total_income.csv 
SELECT
    e.first_name || ' ' || e.last_name AS seller,
    COUNT(s.sales_id) AS operations,
    FLOOR(SUM(s.quantity * p.price)) AS income
FROM employees e
INNER JOIN sales s ON e.employee_id = s.sales_person_id
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY income DESC
LIMIT 10;
--отчет с продавцами, чья выручка ниже средней выручки всех продавцов - lowest_average_income
SELECT
    e.first_name || ' ' || e.last_name AS seller,
    FLOOR(AVG(s.quantity * p.price)) AS average_income
FROM employees e
INNER JOIN sales s ON e.employee_id = s.sales_person_id
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY e.employee_id, e.first_name, e.last_name
HAVING AVG(s.quantity * p.price) < (
    SELECT AVG(sub.total_income)
    FROM (
        SELECT AVG(s2.quantity * p2.price) AS total_income
        FROM employees e2
        INNER JOIN sales s2 ON e2.employee_id = s2.sales_person_id
        INNER JOIN products p2 ON s2.product_id = p2.product_id
        GROUP BY e2.employee_id
    ) sub
)
ORDER BY average_income ASC;

--Отчет с данными по выручке по каждому продавцу и дню недели - day_of_the_week_income
SELECT
    e.first_name || ' ' || e.last_name AS seller,
    TO_CHAR(s.sale_date, 'day') AS day_of_week,
    FLOOR(SUM(s.quantity * p.price)) AS income
FROM employees e
INNER JOIN sales s ON e.employee_id = s.sales_person_id
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY e.employee_id, e.first_name, e.last_name,
         TO_CHAR(s.sale_date, 'day'),
         EXTRACT(ISODOW FROM s.sale_date)
ORDER BY EXTRACT(ISODOW FROM s.sale_date), seller;

-- количество покупателей в разных возрастных группах - age_groups
SELECT
    CASE
        WHEN c.age BETWEEN 16 AND 25 THEN '16-25'
        WHEN c.age BETWEEN 26 AND 40 THEN '26-40'
        ELSE '40+'
    END AS age_category,
    COUNT(c.customer_id) AS age_count
FROM customers c
GROUP BY age_category
ORDER BY age_category;

-- данные по количеству уникальных покупателей и выручке, которую они принесли-customers_by_month
SELECT
    TO_CHAR(s.sale_date, 'YYYY-MM') AS selling_month,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    FLOOR(SUM(s.quantity * p.price)) AS income
FROM sales s
INNER JOIN employees e ON e.employee_id = s.sales_person_id
INNER JOIN products p ON s.product_id = p.product_id
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY TO_CHAR(s.sale_date, 'YYYY-MM')
ORDER BY selling_month ASC;

-- с покупателями первая покупка которых пришлась на время проведения специальных акций - special_offer
WITH price_null AS (
    SELECT p.product_id
    FROM products p
    WHERE p.price = 0
),
first_null_sales AS (
    SELECT s.customer_id,
           MIN(s.sale_date) AS first_null_sale_date
    FROM sales s
    INNER JOIN price_null pn ON s.product_id = pn.product_id
    GROUP BY s.customer_id
)
SELECT
    c.first_name || ' ' || c.last_name AS customer,
    TO_CHAR(s.sale_date, 'YYYY-MM-DD') AS sale_date,
    e.first_name || ' ' || e.last_name AS seller
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN employees e ON s.sales_person_id = e.employee_id
INNER JOIN first_null_sales fs 
        ON s.customer_id = fs.customer_id 
       AND s.sale_date = fs.first_null_sale_date
ORDER BY customer;