# ❓ Handling NULLs: IS NULL & IS NOT NULL (`09_NULL_NOT_NULL.sql`)

This guide explores the nature of `NULL` in SQL, the mechanics of **Three-Valued Logic (3VL)**, how to filter using `IS NULL` / `IS NOT NULL`, and essential null-handling functions in PostgreSQL.

---

## 📌 1. What is `NULL` in SQL?

`NULL` is **not a value**. It represents:
* Missing information
* Unknown data
* Inapplicable / unassigned state

> [!IMPORTANT]
> `NULL` is **never equal to anything** — not even another `NULL`!
> * `NULL != 0` (Zero is a known integer)
> * `NULL != ''` (Empty string is a known text value of length 0)
> * `NULL != FALSE` (False is a known boolean state)

---

## 🧠 2. Three-Valued Logic (3VL)

Traditional programming uses Two-Valued Logic (`TRUE` or `FALSE`). SQL uses **Three-Valued Logic (3VL)**:

$$\text{Logic States: } \{\ \text{TRUE},\ \text{FALSE},\ \text{UNKNOWN (NULL)}\ \}$$

### Why `WHERE col = NULL` Never Works:
```sql
-- ❌ WRONG: Always returns 0 rows!
SELECT * FROM products WHERE category = NULL;
```
* **Why it fails**: Evaluating `category = NULL` produces `UNKNOWN (NULL)`, **not** `TRUE`.
* Since the `WHERE` clause **only retains rows that evaluate strictly to `TRUE`**, all rows are discarded.

### ✅ The Correct Way: `IS NULL` & `IS NOT NULL`
```sql
-- Check for presence of missing data
SELECT name, price, category
FROM products
WHERE category IS NULL;

-- Check for presence of populated data
SELECT name, price, category
FROM products
WHERE category IS NOT NULL;
```

---

## 💻 3. Code Walkthrough (`09_NULL_NOT_NULL.sql`)

### Query 1: Filter Non-Null Categories
```sql
SELECT name, price, category
FROM products
WHERE category IS NOT NULL;
```
* **Result (16 rows)**: Returns all products where `category` has a populated value.

---

### Query 2: Filter Null Categories
```sql
SELECT name, price, category
FROM products
WHERE category IS NULL;
```
* **Result (0 rows)**: Returns empty because the table definition enforces `category TEXT NOT NULL`.

---

## 🛠️ 4. Essential NULL-Handling Functions

### 1. `COALESCE(v1, v2, ...)`
Returns the **first non-null value** in the list. Perfect for setting default fallback values in queries.
```sql
-- If description is NULL, display 'No description provided'
SELECT name, COALESCE(description, 'No description provided') AS display_description
FROM products;
```

---

### 2. `NULLIF(v1, v2)`
Returns **`NULL` if both arguments are equal**; otherwise returns `v1`.
```sql
-- Prevent "Division by Zero" errors:
-- If total_orders is 0, NULLIF makes it NULL, resulting in NULL instead of a crash!
SELECT total_sales / NULLIF(total_orders, 0) AS avg_order_value
FROM store_stats;
```

---

### 3. Null-Safe Equality: `IS NOT DISTINCT FROM`
PostgreSQL provides `IS NOT DISTINCT FROM` which treats two `NULL` values as equal:
```sql
-- Returns TRUE if both a and b are NULL, or if a = b
WHERE a IS NOT DISTINCT FROM b;

-- Inverse (Null-safe inequality):
WHERE a IS DISTINCT FROM b;
```

---

## 📊 5. Behavior of `NULL` in Aggregations & Sorting

| SQL Construct | Behavior with `NULL` | Example |
| :--- | :--- | :--- |
| **`COUNT(*)`** | Counts **all rows**, including those with `NULL`s | Returns total row count |
| **`COUNT(column)`** | Counts only rows where `column` is **NOT NULL** | Skips `NULL`s |
| **`SUM(col)`, `AVG(col)`** | **Ignores** `NULL` values | `SUM(10, NULL, 20)` = `30` |
| **`ORDER BY col ASC`** | PostgreSQL places `NULL`s **last** by default | Use `NULLS FIRST` to override |
| **`ORDER BY col DESC`** | PostgreSQL places `NULL`s **first** by default | Use `NULLS LAST` to override |

---

## 💼 6. Top Interview Questions

### ❓ Q1: What is the difference between `COUNT(*)`, `COUNT(1)`, and `COUNT(column_name)`?
* **Answer:**
  * **`COUNT(*)` and `COUNT(1)`**: Count the total number of rows in the result set, regardless of whether any or all column values are `NULL`. They perform identically in PostgreSQL.
  * **`COUNT(column_name)`**: Counts only rows where `column_name` contains a **non-null** value. If 5 out of 16 rows have a `NULL` description, `COUNT(description)` returns `11`, while `COUNT(*)` returns `16`.

---

### ❓ Q2: How does a `UNIQUE` constraint handle multiple `NULL` values in PostgreSQL?
* **Answer:**
  * By standard SQL rules and default PostgreSQL behavior, **multiple `NULL` values are allowed in a `UNIQUE` column**. Because `NULL != NULL`, two rows both having `NULL` do not violate uniqueness.
  * **PostgreSQL 15+ Feature**: If you want to forbid duplicate `NULL`s in a unique column, use the `NULLS NOT DISTINCT` clause:
    ```sql
    CREATE TABLE users (
        id SERIAL PRIMARY KEY,
        phone TEXT UNIQUE NULLS NOT DISTINCT
    );
    ```

---

### ❓ Q3: Can PostgreSQL B-Tree indexes index `NULL` values?
* **Answer:**
  * **Yes**. Unlike some older relational database engines (e.g., Oracle B-Trees that omit all-null rows), **PostgreSQL stores `NULL` values in standard B-Tree indexes**.
  * Therefore, queries with `WHERE col IS NULL` or `ORDER BY col NULLS FIRST` can fully utilize standard B-Tree Index Scans.

---

### ❓ Q4: What is the output of `SELECT NULL + 10;` and `SELECT NULL || 'Hello';`?
* **Answer:**
  * Both evaluate to **`NULL`**.
  * Any arithmetic operation (`+`, `-`, `*`, `/`) or string concatenation (`||`) involving `NULL` yields `NULL` because the unknown state propagates.
  * *Tip*: To concatenate strings safely without turning the whole result into `NULL`, use PostgreSQL's `CONCAT('Hello ', NULL, 'World')` which treats `NULL` as an empty string.
