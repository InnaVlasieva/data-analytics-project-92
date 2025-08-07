CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    manager_id INT 
);

INSERT INTO employees (name, manager_id) VALUES
    ('CEO', NULL),          
    ('Alice', 1),          
    ('Bob', 1),
    ('Carol', 2),           
    ('Dave', 2),
    ('Eve', 3),             
    ('Frank', 4);          

WITH RECURSIVE hierarchy AS (
    SELECT 
        id,
        name,
        manager_id,
        1 AS level,
        name::text AS path
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT 
        e.id,
        e.name,
        e.manager_id,
        h.level + 1,
        h.path || ' > ' || e.name
    FROM employees e
    JOIN hierarchy h ON e.manager_id = h.id
)

SELECT 
    id,
    name,
    manager_id,
    level,
    path
FROM hierarchy
ORDER BY level, manager_id, name;
