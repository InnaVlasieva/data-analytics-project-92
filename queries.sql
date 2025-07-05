select COUNT (customer_id) as customers_count
from customers c;
-- считает общее количество покупателей из таблицы customers

--  отчет с продавцами у которых наибольшая выручка - top_10_total_income.csv 
select e.first_name || ' ' || e.last_name AS seller,
     COUNT(s.sales_id) AS operations,
     FLOOR (SUM(s.quantity * p.price)) AS income
from employees e 
inner join sales s on e.employee_id = s.sales_person_id
inner join products p  on s.product_id = p.product_id
group by e.first_name || ' ' || e.last_name
order by income desc limit 10;
