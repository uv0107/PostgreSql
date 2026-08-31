# 📦 Part 2: SQL Querying & Data Manipulation (CRUD)

Welcome to **Part 2** of the PostgreSQL Full Course! In this module, we focus on real-world querying, single and batch row insertion, filtering, column projection, and data manipulation techniques on e-commerce datasets.

---

## 📂 Lesson Files & Notes Index

| # | SQL Script File | Notes & Summary File | Topics Covered | Status |
| :- | :--- | :--- | :--- | :--- |
| **01** | **[`01_sql_concepts_basefile.sql`](file:///Users/atul/Desktop/PostgreSQL_full_course/part2/01_sql_concepts_basefile.sql)** | **[`theory/01_sql_concepts_basefile_notes.md`](file:///Users/atul/Desktop/PostgreSQL_full_course/part2/theory/01_sql_concepts_basefile_notes.md)** | Base `products` schema, `UUID` primary keys (`gen_random_uuid()`), `NUMERIC` vs `FLOAT`, `CHECK` constraints. | ✅ Complete |
| **02** | **[`02.insert_single_row.sql`](file:///Users/atul/Desktop/PostgreSQL_full_course/part2/02.insert_single_row.sql)** | **[`theory/02_insert_single_row_notes.md`](file:///Users/atul/Desktop/PostgreSQL_full_course/part2/theory/02_insert_single_row_notes.md)** | Single row `INSERT`, column positioning, `RETURNING` clause, `ON CONFLICT` (Upsert). | ✅ Complete |
| **03** | **[`03_insert_multiple_rows.sql`](file:///Users/atul/Desktop/PostgreSQL_full_course/part2/03_insert_multiple_rows.sql)** | **[`theory/03_insert_multiple_rows_notes.md`](file:///Users/atul/Desktop/PostgreSQL_full_course/part2/theory/03_insert_multiple_rows_notes.md)** | Multi-row batch insertion, atomicity, network roundtrips comparison, bulk loading via `COPY`. | ✅ Complete |
| **04** | **[`04_select_specific_cols_vs_select_star.sql`](file:///Users/atul/Desktop/PostgreSQL_full_course/part2/04_select_specific_cols_vs_select_star.sql)** | **[`theory/04_select_specific_cols_vs_select_star_notes.md`](file:///Users/atul/Desktop/PostgreSQL_full_course/part2/theory/04_select_specific_cols_vs_select_star_notes.md)** | `SELECT *` vs column projection, I/O performance, Covering Indexes (Index-Only Scans), column aliases. | ✅ Complete |
