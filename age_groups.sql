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