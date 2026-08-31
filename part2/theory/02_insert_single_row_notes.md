# 📥 Single-Row INSERT (`02.insert_single_row.sql`)

This script demonstrates inserting a single record into a table with explicit column specifications.

---

## 📌 1. Core Syntax & Best Practice

```sql
INSERT INTO products (name, category, price, stock, is_active, sku, description)
VALUES
('Sony WH-1000XM5', 'Audio', 349.99, 60, true, 'AUD-SONY-XM5', 'Industry-leading wireless noise-canceling over-ear headphones');
```

* **Explicit Column List**: Always list column names explicitly `(name, category, ...)`. Avoid `INSERT INTO products VALUES (...)` without column names, because changing the table schema (adding/reordering columns) will break positional inserts.
* **Omitted Columns**: Columns with defaults (`id`, `created_at`) are omitted from the column list, letting PostgreSQL generate values automatically.

---

## 💼 2. Top Interview Questions

### ❓ Q1: How can you retrieve the auto-generated `id` or other columns immediately upon inserting a row?
* **Answer:** Use the **`RETURNING`** clause:
  ```sql
  INSERT INTO products (name, category, price, sku)
  VALUES ('Sony Headphones', 'Audio', 349.99, 'AUD-SONY-01')
  RETURNING id, created_at;
  ```
  This eliminates the need to perform a second `SELECT` query.

---

### ❓ Q2: What happens if an `INSERT` omits a column that is `NOT NULL` and has no `DEFAULT`?
* **Answer:** PostgreSQL throws an error (`ERROR: null value in column "..." of relation "..." violates not-null constraint`) and the transaction fails.

---

### ❓ Q3: How do you handle "Insert or Update" (Upsert) on conflict?
* **Answer:** Use `ON CONFLICT`:
  ```sql
  INSERT INTO products (name, category, price, sku)
  VALUES ('Sony WH-1000XM5', 'Audio', 349.99, 'AUD-SONY-XM5')
  ON CONFLICT (sku) 
  DO UPDATE SET price = EXCLUDED.price, stock = products.stock + 1;
  ```
