-- Primary keys
DROP TABLE IF EXISTS basics.user;

CREATE TABLE basics.user(
    id SERIAL,
    first_name TEXT,
    last_name TEXT,
    PRIMARY KEY (id)
);

INSERT INTO basics.user(first_name,last_name)
VALUES
('vamsi','uv'),
('loki','ep420'),
('gopi','');

-- SELECT * FROM basics.user;


-- DROP TABLE
-- CREATE TABLE
-- INSERT 0 3
--  id | first_name | last_name 
-- ----+------------+-----------
--   1 | vamsi      | uv        
--   2 | loki       | ep420     
--   3 | gopi       |           
-- (3 rows)

-- SELECT * FROM basics.user WHERE id = 1;


--  id | first_name | last_name 
-- ----+------------+-----------
--   1 | vamsi      | uv        
-- (1 row)
INSERT INTO basics.user(id,first_name,last_name)
VALUES
(1,'Kingvamsi','uv');

SELECT * FROM basics.user;


-- atul@arvinds-MacBook-Pro PostgreSQL_full_course % psql -U postgres -d postgresql_part1 -f part1/08_primarykeys.sql
-- psql:part1/08_primarykeys.sql:2: NOTICE:  table "user" does not exist, skipping
-- DROP TABLE
-- CREATE TABLE
-- INSERT 0 3
-- psql:part1/08_primarykeys.sql:39: ERROR:  INSERT has more expressions than target columns
-- LINE 3: (1,'Kingvamsi','uv');
--                        ^
--  id | first_name | last_name 
-- ----+------------+-----------
--   1 | vamsi      | uv
--   2 | loki       | ep420
--   3 | gopi       | 
-- (3 rows)





