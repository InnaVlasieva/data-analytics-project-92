-- Общее количество покупателей
SELECT COUNT(c.customer_id) AS customers_count
FROM customers AS c;

-- Отчет: 10 продавцов с наибольшей выручкой
SELECT
    e.first_name || ' ' || e.last_name AS seller,
    COUNT(s.sales_id) AS operations,
    FLOOR(SUM(s.quantity * p.price)) AS income
FROM employees AS e
INNER JOIN sales AS s
    ON e.employee_id = s.sales_person_id
INNER JOIN products AS p
    ON s.product_id = p.product_id
GROUP BY seller
ORDER BY income DESC
LIMIT 10;

-- Отчет: продавцы с выручкой ниже средней
SELECT
    e.first_name || ' ' || e.last_name AS seller,
    FLOOR(AVG(s.quantity * p.price)) AS average_income
FROM employees AS e
INNER JOIN sales AS s
    ON e.employee_id = s.sales_person_id
INNER JOIN products AS p
    ON s.product_id = p.product_id
GROUP BY e.first_name, e.last_name
HAVING AVG(s.quantity * p.price) < (
    SELECT AVG(sub.total_income)
    FROM (
        SELECT AVG(s2.quantity * p2.price) AS total_income
        FROM employees AS e2
        INNER JOIN sales AS s2
            ON e2.employee_id = s2.sales_person_id
        INNER JOIN products AS p2
            ON s2.product_id = p2.product_id
        GROUP BY e2.employee_id
    ) AS sub
)
ORDER BY average_income ASC;

-- Отчет: выручка по каждому продавцу и дню недели
SELECT
    e.first_name || ' ' || e.last_name AS seller,
    TO_CHAR(s.sale_date, 'day') AS day_of_week,
    FLOOR(SUM(s.quantity * p.price)) AS income
FROM employees AS e
INNER JOIN sales AS s
    ON e.employee_id = s.sales_person_id
INNER JOIN products AS p
    ON s.product_id = p.product_id
GROUP BY
    seller,
    TO_CHAR(s.sale_date, 'day'),
    EXTRACT(ISODOW FROM s.sale_date)
ORDER BY
    EXTRACT(ISODOW FROM s.sale_date),
    seller;

-- Отчет: количество покупателей по возрастным группам
SELECT
    CASE
        WHEN age BETWEEN 16 AND 25 THEN '16-25'
        WHEN age BETWEEN 26 AND 40 THEN '26-40'
        ELSE '40+'
    END AS age_category,
    COUNT(customer_id) AS age_count
FROM customers AS c
GROUP BY age_category
ORDER BY age_category;

-- Отчет: уникальные покупатели и их выручка по месяцам
SELECT
    TO_CHAR(s.sale_date, 'YYYY-MM') AS selling_month,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    FLOOR(SUM(s.quantity * p.price)) AS income
FROM sales AS s
INNER JOIN employees AS e
    ON e.employee_id = s.sales_person_id
INNER JOIN products AS p
    ON s.product_id = p.product_id
INNER JOIN customers AS c
    ON s.customer_id = c.customer_id
GROUP BY selling_month
ORDER BY selling_month ASC;

-- Отчет: покупатели, первая покупка которых была со специальной акцией
WITH price_null AS (
    SELECT product_id
    FROM products AS p
    WHERE p.price = 0
),

first_null_sales AS (
    SELECT
        s.customer_id,
        MIN(s.sale_date) AS first_null_sale_date
    FROM sales AS s
    INNER JOIN price_null AS pn
        ON s.product_id = pn.product_id
    GROUP BY s.customer_id
)

SELECT
    c.first_name || ' ' || c.last_name AS customer,
    TO_CHAR(s.sale_date, 'YYYY-MM-DD') AS sale_date,
    e.first_name || ' ' || e.last_name AS seller
FROM sales AS s
INNER JOIN products AS p
    ON s.product_id = p.product_id
INNER JOIN customers AS c
    ON s.customer_id = c.customer_id
INNER JOIN employees AS e
    ON s.sales_person_id = e.employee_id
INNER JOIN first_null_sales AS fs
    ON s.customer_id = fs.customer_id
    AND s.sale_date = fs.first_null_sale_date
ORDER BY customer;