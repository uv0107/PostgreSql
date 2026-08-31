# 🛠️ Part 1: Setup & Core SQL

Welcome to **Part 1** of the PostgreSQL Full Course! In this module, we build the foundation by setting up databases, creating tables, defining constraints, and performing core SQL CRUD queries.

---

## 📂 Lesson Files & Notes Index

| # | SQL Script File | Notes & Summary File | Topics Covered | Status |
| :- | :--- | :--- | :--- | :--- |
| **01** | **[`01_first_database.sql`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/01_first_database.sql)** | **[`theory/01_first_database_notes.md`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/theory/01_first_database_notes.md)** | `CREATE DATABASE`, `DROP DATABASE IF EXISTS`, SQL comments, session inspection (`current_database`, `current_user`, `version`), prompt continuation (`postgres-#`), `\l`, `\dt`. | ✅ Complete |
| **02** | **[`02_first_schema.sql`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/02_first_schema.sql)** | **[`theory/02_first_schema_notes.md`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/theory/02_first_schema_notes.md)** | `CREATE SCHEMA`, `public` vs custom schemas, extensions (`pgcrypto`), `information_schema.schemata`. | ✅ Complete |
| **03** | **[`03_first_table.sql`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/03_first_table.sql)** | **[`theory/03_first_table_notes.md`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/theory/03_first_table_notes.md)** | `CREATE TABLE`, Constraints (`SERIAL PRIMARY KEY`, `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT NOW()`), `INSERT INTO`, Single vs Double Quotes. | ✅ Complete |
| **04** | **[`04_data_types.sql`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/04_data_types.sql)** | **[`theory/04_data_types_notes.md`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/theory/04_data_types_notes.md)** | Complete PostgreSQL Data Types (`UUID`, `VARCHAR`, `TEXT`, `DECIMAL`, `BIGINT`, `JSONB`, `TEXT[]`, `TIMESTAMPTZ`), Float vs Decimal, JSON vs JSONB. | ✅ Complete |
| **05** | **[`05_other_datatypes.sql`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/05_other_datatypes.sql)** | **[`theory/05_other_datatypes_notes.md`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/theory/05_other_datatypes_notes.md)** | Advanced data types: `UUID` (`gen_random_uuid()`), `JSON` vs `JSONB`, JSON operators (`->`, `->>`, `?`), GIN indexing. | ✅ Complete |
| **06** | **[`06_null_empty_string_zero.sql`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/06_null_empty_string_zero.sql)** | **[`theory/06_null_empty_string_zero_notes.md`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/theory/06_null_empty_string_zero_notes.md)** | `NULL` vs `''` vs `0`, Three-Valued Logic (3VL), `IS NULL`, `COALESCE`, `NULLIF`, aggregate treatment (`COUNT`, `SUM`, `AVG`). | ✅ Complete |
| **07** | **[`07_constraints.sql`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/07_constraints.sql)** | **[`theory/07_constraints_notes.md`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/theory/07_constraints_notes.md)** | The 6 core constraints (`PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`), column vs table level, `ALTER TABLE`, error analysis. | ✅ Complete |
| **08** | **[`08_primarykeys.sql`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/08_primarykeys.sql)** | **[`theory/08_primarykeys_notes.md`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/theory/08_primarykeys_notes.md)** | Primary Keys (`PRIMARY KEY (id)`), Duplicate Key violation errors, Natural vs Surrogate vs Composite keys. | ✅ Complete |

---

## 🎯 How to Use This Folder
1. Follow along and write queries in the `.sql` files.
2. Refer to the corresponding `*_notes.md` file for line-by-line explanations, best practices, and deep dives.
3. Run the scripts using `psql` or your preferred GUI tool (pgAdmin / DBeaver).
