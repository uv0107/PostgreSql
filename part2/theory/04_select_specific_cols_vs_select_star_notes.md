# 🎯 SELECT Specific Columns vs SELECT * (`04_select_specific_cols_vs_select_star.sql`)

This document explores why specifying explicit column names is considered an essential best practice over using `SELECT *` in production databases.

---

## 📌 1. Syntax Comparison

```sql
-- ❌ SELECT * : Returns every column in the table
SELECT * FROM products;

-- ✅ SELECT Specific Columns : Returns only requested columns
SELECT name, price, stock FROM products;
```

---

## ⚡ 2. Why `SELECT *` is an Anti-Pattern in Production

1. **Network & I/O Overhead**: Tables often have heavy columns (`TEXT` descriptions, `JSONB` payloads, binary data). Pulling unused columns wastes network bandwidth and database memory buffers.
2. **Breaks "Index-Only Scans"**: If a query asks only for columns already in an index (e.g., `SELECT name FROM products`), PostgreSQL reads data directly from RAM index blocks without touching the disk table pages. `SELECT *` forces slow full table page reads.
3. **Application Fragility**: If a developer adds or drops a column in the table, API contracts, ORM mappings, or positional unpacking in code can unexpectedly break.

---

## 💼 3. Top Interview Questions

### ❓ Q1: What is a "Covering Index" (Index-Only Scan), and how does `SELECT *` prevent it?
* **Answer:** An **Index-Only Scan** occurs when all columns requested by a `SELECT` query exist within the B-Tree index itself. PostgreSQL can satisfy the query entirely from index memory without reading table disk pages (heaps). `SELECT *` requests columns not in the index, preventing this major optimization.

---

### ❓ Q2: When is `SELECT *` acceptable?
* **Answer:**
  1. During interactive ad-hoc debugging in `psql` or database GUI clients.
  2. Inside `EXISTS` subqueries (e.g., `WHERE EXISTS (SELECT 1 ...)` or `(SELECT * ...)`), because the database engine optimizes it to check only row existence and does not fetch actual data.

---

### ❓ Q3: How do column aliases (`AS`) affect performance?
* **Answer:** Aliases have **zero impact on query performance**. They are resolved at the SQL parse stage simply to rename the output headers in the returned result set.
