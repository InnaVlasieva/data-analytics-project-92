select count(customer_id) as customers_count
from customers;
-- считает общее количество покупателей из таблицы customers

--  отчет с продавцами у которых наибольшая выручка - top_10_total_income.csv 
select
    e.first_name || ' ' || e.last_name as seller,
    count(s.sales_id) as operations,
    floor(sum(s.quantity * p.price)) as income
from employees as e
inner join sales as s on e.employee_id = s.sales_person_id
inner join products as p on s.product_id = p.product_id
group by e.first_name || ' ' || e.last_name
order by income desc limit 10;

--отчет с продавцами, чья выручка ниже средней выручки всех продавцов - lowest_average_income
select
    e.first_name || ' ' || e.last_name as seller,
    floor(avg(s.quantity * p.price)) as average_income
from employees as e
inner join sales as s on e.employee_id = s.sales_person_id
inner join products as p on s.product_id = p.product_id
group by e.first_name, e.last_name
having
    avg(s.quantity * p.price) < (
        select avg(sub.total_income)
        from (
            select avg(s2.quantity * p2.price) as total_income
            from employees as e2
            inner join sales as s2 on e2.employee_id = s2.sales_person_id
            inner join products as p2 on s2.product_id = p2.product_id
            group by e2.employee_id
        ) as sub
    )
order by average_income asc;

--Отчет с данными по выручке по каждому продавцу и дню недели - day_of_the_week_income
select
    e.first_name || ' ' || e.last_name as seller,
    to_char(s.sale_date, 'day') as day_of_week,
    floor(sum(s.quantity * p.price)) as income
from employees as e
inner join sales Aas s on e.employee_id = s.sales_person_id
inner join products as p on s.product_id = p.product_id
group by 
    e.first_name || ' ' || e.last_name,
    to_char(s.sale_date, 'day'), extract(ISODOW from s.sale_date)
order by extract(ISODOW from s.sale_date), e.first_name || ' ' || e.last_name;

-- количество покупателей в разных возрастных группах - age_groups
select
    case
        when age between 16 and 25 then '16-25'
        when age between 26 and 40 then'26-40'
        ELSE '40+'
    end as age_category,
    count(customer_id) as age_count
from customers
group by  age_category
order by age_category;

-- данные по количеству уникальных покупателей и выручке, которую они принесли-customers_by_month
select
    to_char(s.sale_date, 'YYYY-MM') as selling_month,
    count(distinct c.customer_id) as total_customers,
    floor(sum(s.quantity * p.price)) as income
from employees as e
inner join sales as s on e.employee_id = s.sales_person_id
inner join products as p on s.product_id = p.product_id
inner join customers as c on s.customer_id = c.customer_id
group by to_char(s.sale_date, 'YYYY-MM')
order by selling_month ASC;

-- с покупателями первая покупка которых пришлась на время проведения специальных акций - special_offer
with price_null as (
    select product_id
    from products
    where price = 0
),
first_null_sales as (
    select
        s.customer_id,
        min(s.sale_date) as first_null_sale_date
    from sales s
    inner joinprice_null pn on s.product_id = pn.product_id
    group by s.customer_id
)
select
    c.first_name || ' ' || c.last_name as customer,
    to_char(s.sale_date, 'YYYY-MM-DD') as sale_date,
    e.first_name || ' ' || e.last_name as seller
from sales s
inner join products p on s.product_id = p.product_id
inner join customers c on s.customer_id = c.customer_id
inner join employees e on s.sales_person_id = e.employee_id
inner join first_null_sales fs on s.customer_id = fs.customer_id and  s.sale_date = fs.first_null_sale_date
group by s.sale_date, c.first_name || ' ' || c.last_name, e.first_name || ' ' || e.last_name
order by customer;
