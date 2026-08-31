# 📦 Multi-Row Bulk INSERT (`03_insert_multiple_rows.sql`)

This script demonstrates inserting multiple rows in a single SQL query.

---

## 📌 1. Core Syntax & Mental Model

```sql
INSERT INTO products (name, category, price, stock, is_active, sku, description)
VALUES
('Apple Watch Series 9', 'Electronics', 399.00, 50, true, 'ELEC-APL-WAT9', 'Smartwatch with advanced health sensors'),
('PlayStation 5 Slim', 'Gaming', 499.99, 20, true, 'GAME-SONY-PS5S', 'Next-gen gaming console with 1TB SSD'),
('Adidas Ultraboost Light', 'Footwear', 189.99, 75, true, 'FOOT-ADI-UB-LT', 'High-performance running shoes');
```

* **Multi-Value Syntax**: Comma-separated tuples `(...), (...), (...)` under a single `VALUES` keyword.
* **Atomicity**: The entire multi-row batch is treated as a single transaction. If any individual row violates a constraint, the **entire batch is rolled back** (0 rows inserted).

---

## ⚡ 2. Why Multi-Row INSERTs are Much Faster

| Approach | Network Roundtrips | Transaction Commits | Performance |
| :--- | :--- | :--- | :--- |
| **1000 Single `INSERT`s** | 1,000 roundtrips | 1,000 disk syncs / WAL writes | 🐌 Very Slow (Seconds) |
| **1 Multi-Row `INSERT`** | 1 roundtrip | 1 disk sync / WAL write | ⚡ Extremely Fast (Milliseconds) |

---

## 💼 3. Top Interview Questions

### ❓ Q1: What are the best ways to bulk load massive amounts of data (millions of rows) in PostgreSQL?
* **Answer:**
  1. **`COPY` command** (e.g., `COPY products FROM '/path/to/file.csv' WITH CSV HEADER;`) — Fastest method in PostgreSQL.
  2. **Multi-row `INSERT`** in chunked batches (e.g., 1,000–5,000 rows per batch).
  3. Temporarily dropping unneeded indexes/foreign keys during bulk load, then recreating them afterward.

---

### ❓ Q2: If 1 out of 10 rows in a multi-row `INSERT` violates a `UNIQUE` constraint, can you insert the remaining 9 rows?
* **Answer:** Yes, by appending **`ON CONFLICT DO NOTHING`**:
  ```sql
  INSERT INTO products (name, category, price, sku)
  VALUES (...)
  ON CONFLICT (sku) DO NOTHING;
  ```
  This skips conflicting rows while successfully inserting all valid ones.
