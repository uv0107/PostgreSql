-- null - unknown 
-- empty string "" -  known , empty value 
-- zero "0" - known , value is zero

-- 0 is valid value 
-- "" is valid value  
-- NULL is not a value  

DROP TABLE IF EXISTS basics.value_examples;

CREATE TABLE basics.value_examples(

    id SERIAL PRIMARY KEY,
    name TEXT,
    nickname TEXT,
    score INTEGER
);

INSERT INTO basics.value_examples(name,nickname,score)
VALUES 
(null,'uv',10),
('','loki',0),
('gana',null,null),
('',null,20),
(null,null,null),
('gana','',0);

-- SELECT * FROM basics.value_examples;

-- DROP TABLE
-- CREATE TABLE
-- INSERT 0 6
--  id | name | nickname | score 
-- ----+------+----------+-------
--   1 |      | uv       |    10
--   2 |      | loki     |     0
--   3 | gana |          |      
--   4 |      |          |    20
--   5 |      |          |      
--   6 | gana |          |     0
-- (6 rows)

-- SELECT * FROM basics.value_examples WHERE name IS NULL;  
-- DROP TABLE
-- CREATE TABLE
-- INSERT 0 6
--  id | name | nickname | score 
-- ----+------+----------+-------
--   1 |      | uv       |    10
--   5 |      |          |      
-- (2 rows)
-- SELECT * FROM basics.value_examples WHERE name IS NOT NULL;  
-- DROP TABLE
-- CREATE TABLE
-- INSERT 0 6
--  id | name | nickname | score 
-- ----+------+----------+-------
--   3 | gana |          |      
--   6 | gana |          |     0
-- (2 rows)

SELECT * FROM basics.value_examples WHERE name = '';
-- DROP TABLE
-- CREATE TABLE
-- INSERT 0 6
--  id | name | nickname | score 
-- ----+------+----------+-------
--   2 |      | loki     |     0
--   4 |      |          |    20
-- (2 rows)
