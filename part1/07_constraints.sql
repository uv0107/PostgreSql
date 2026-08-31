-- Database constraints are rules applied to columns/tables to control what data can be stored.

-- DB constraints are :
-- 1. Primary Key
-- 2. Foreign Key
-- 3. Default
-- 4. Not Null
-- 5. Check
-- 6. Unique


-- 1. Primary Key
-- It is a constraint that ensures that the column(s) it is applied to contain unique and non-null values. It is used to uniquely identify each row in a table.

DROP TABLE IF EXISTS basics.accounts;

CREATE TABLE basics.accounts(

    id SERIAL PRIMARY KEY,

    full_name TEXT NOT NULL,

    email TEXT NOT NULL UNIQUE,

    is_active BOOLEAN DEFAULT TRUE,

    age INTEGER CHECK(age>=18),

    created_at TIMESTAMP DEFAULT NOW()

);

INSERT INTO basics.accounts(full_name,email,is_active,age)
VALUES
('vamsi','uyyalavamsi37@gmail.com',true,19),
('gopi','',20,20),
('loki','lokiep420@gmail.com',true,22);


SELECT * FROM basics.accounts;

-- atul@arvinds-MacBook-Pro PostgreSQL_full_course % psql -U postgres -d postgresql_part1 -f part1/07_constraints.sql
-- Password for user postgres: 
-- DROP TABLE
-- CREATE TABLE
-- psql:part1/07_constraints.sql:37: ERROR:  column "is_active" is of type boolean but expression is of type integer
-- LINE 4: ('gopi','',20,20),
--                    ^
-- HINT:  You will need to rewrite or cast the expression.
--  id | full_name | email | is_active | age | created_at 
-- ----+-----------+-------+-----------+-----+------------
-- (0 rows)











