select
    count(c.customer_id) as customers_count
from customers c;
-- считает общее количество покупателей из таблицы customers

--  отчет с продавцами у которых наибольшая выручка - top_10_total_income.csv 
select
    e.first_name || ' ' || e.last_name as seller,
    count(s.sales_id) as operations,
    floor(sum(s.quantity * p.price)) as income
from employees e
inner join sales s
    on e.employee_id = s.sales_person_id
inner join products p
    on s.product_id = p.product_id
group by seller
order by income desc
limit 10;
--отчет с продавцами, чья выручка ниже средней выручки всех продавцов - lowest_average_income
select
    e.first_name || ' ' || e.last_name as seller,
    count(s.sales_id) as operations,
    floor(sum(s.quantity * p.price)) as income
from employees e
inner join sales s
    on e.employee_id = s.sales_person_id
inner join products p
    on s.product_id = p.product_id
group by seller
order by income desc
limit 10;

--Отчет с данными по выручке по каждому продавцу и дню недели - day_of_the_week_income
select
    e.first_name || ' ' || e.last_name as seller,
    to_char(s.sale_date, 'day') as day_of_week,
    floor(sum(s.quantity * p.price)) as income
from employees e
inner join sales s
    on e.employee_id = s.sales_person_id
inner join products p
    on s.product_id = p.product_id
group by
    seller,
    to_char(s.sale_date, 'day'),
    extract(isodow from s.sale_date)
order by
    extract(isodow from s.sale_date),
    seller;

-- количество покупателей в разных возрастных группах - age_groups
select
    case
        when c.age between 16 and 25 then '16-25'
        when c.age between 26 and 40 then '26-40'
        else '40+'
    end as age_category,
    count(c.customer_id) as age_count
from customers c
group by age_category
order by age_category;

-- данные по количеству уникальных покупателей и выручке, которую они принесли-customers_by_month
select
    to_char(s.sale_date, 'YYYY-MM') as selling_month,
    count(distinct c.customer_id) as total_customers,
    floor(sum(s.quantity * p.price)) as income
from sales s
inner join employees e
    on e.employee_id = s.sales_person_id
inner join products p
    on s.product_id = p.product_id
inner join customers c
    on s.customer_id = c.customer_id
group by selling_month
order by selling_month asc;

-- с покупателями первая покупка которых пришлась на время проведения специальных акций - special_offer
with price_null as (
    select
        p.product_id
    from products p
    where p.price = 0
),
first_null_sales as (
    select
        s.customer_id,
        min(s.sale_date) as first_null_sale_date
    from sales s
    inner join price_null pn
        on s.product_id = pn.product_id
    group by s.customer_id
)
select
    c.first_name || ' ' || c.last_name as customer,
    to_char(s.sale_date, 'YYYY-MM-DD') as sale_date,
    e.first_name || ' ' || e.last_name as seller
from sales s
inner join products p
    on s.product_id = p.product_id
inner join customers c
    on s.customer_id = c.customer_id
inner join employees e
    on s.sales_person_id = e.employee_id
inner join first_null_sales fs
    on s.customer_id = fs.customer_id
    and s.sale_date = fs.first_null_sale_date
order by customer;