CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(200),
    second_name VARCHAR(200),
    date_of_birth DATE,
    passport_number INT
);

INSERT INTO documents (first_name, second_name, date_of_birth,passport_number)
VALUES 
    ('Bars', 'Vlasjev', TO_DATE('24/04/2019', 'DD/MM/YYYY'), 12),
    ('Amira', 'Popova', TO_DATE('10/08/2020', 'DD/MM/YYYY'), 25),
    ('List', 'Zakur', null, 4538),
    ('Zanna', 'Steel', TO_DATE('15/03/2020', 'DD/MM/YYYY'), 569),
    ('Skarlet', 'Home', TO_DATE('08/05/2021', 'DD/MM/YYYY'), 12456);

WITH RECURSIVE data AS (
    SELECT first_name AS dogs, second_name AS surname
    FROM documents
    WHERE date_of_birth IS NOT NULL

    UNION

    SELECT first_name, second_name AS surname
    FROM documents
    WHERE passport_number < 200
)

SELECT * FROM data;

