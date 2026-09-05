# 🎯 Range & List Filtering: IN, NOT IN, BETWEEN (`08_in_not_in_between.sql`)

This guide explains how to filter data across discrete lists of values and continuous ranges in PostgreSQL using `IN`, `NOT IN`, `BETWEEN`, and `NOT BETWEEN`.

---

## 📌 1. What are `IN` and `BETWEEN`?

| Operator | Purpose | Equivalent Logic | Boundary / Behavior |
| :--- | :--- | :--- | :--- |
| **`IN (...)`** | Tests if a value matches **any** item in a specified list | `col = 'A' OR col = 'B'` | Matches exact items |
| **`NOT IN (...)`** | Tests if a value matches **none** of the items in a list | `col != 'A' AND col != 'B'` | Excludes list items |
| **`BETWEEN min AND max`** | Tests if a value falls within a continuous range | `col >= min AND col <= max` | **Inclusive** of both endpoints |
| **`NOT BETWEEN min AND max`**| Tests if a value falls strictly outside a range | `col < min OR col > max` | Excludes both endpoints & range |

---

## 💻 2. Code Walkthrough (`08_in_not_in_between.sql`)

### Query 1: Filtering by List of Values (`IN`)
```sql
SELECT name, price, category
FROM products
WHERE category IN ('Electronics', 'Computers');
```
* **How it works**: Compares `category` against `'Electronics'` and `'Computers'`.
* **Equivalent to**: `WHERE category = 'Electronics' OR category = 'Computers'`.
* **Output (5 rows)**:
  * `iPhone 15 Pro` ($999.99 - Electronics)
  * `Samsung Galaxy S24 Ultra` ($1199.99 - Electronics)
  * `Apple MacBook Air M3` ($1099.00 - Computers)
  * `Apple Watch Series 9` ($399.00 - Electronics)
  * `iPad Air 11-inch M2` ($599.00 - Computers)

---

### Query 2: Excluding a List of Values (`NOT IN`)
```sql
SELECT name, price, category
FROM products
WHERE category NOT IN ('Electronics', 'Computers');
```
* **How it works**: Returns all products belonging to any category **other than** `Electronics` or `Computers`.
* **Output (11 rows)**: Audio, Accessories, Clothing, Footwear, Gaming, and Home Appliances.

---

### Query 3: Range Filtering (`BETWEEN`)
```sql
SELECT name, price
FROM products
WHERE price BETWEEN 100 AND 500;
```
* **How it works**: Returns products whose price is **between \$100.00 and \$500.00 inclusive** (`price >= 100 AND price <= 500`).
* **Output (6 rows)**:
  * `Sony WH-1000XM5` ($349.99)
  * `Nike Air Force 1 '07` ($115.00)
  * `Apple Watch Series 9` ($399.00)
  * `PlayStation 5 Slim` ($499.99)
  * `Adidas Ultraboost Light` ($189.99)
  * `Bose QuietComfort Ultra` ($429.00)

---

### Query 4: Excluding a Range (`NOT BETWEEN`)
```sql
SELECT name, price
FROM products
WHERE price NOT BETWEEN 100 AND 500;
```
* **How it works**: Matches products cheaper than \$100 **OR** strictly more expensive than \$500 (`price < 100 OR price > 500`).
* **Output (10 rows)**: Budget items (< $100) and premium/flagship items (> $500).

---

### Query 5: Combining `IN` and `BETWEEN` with `AND`
```sql
SELECT name, price, category
FROM products
WHERE category IN ('Electronics') 
  AND price BETWEEN 100 AND 500;
```
* **How it works**: Evaluates both predicates simultaneously:
  1. Product must be in `'Electronics'`.
  2. Price must be in range `[$100, $500]`.
* **Output (1 row)**:
  * `Apple Watch Series 9` ($399.00 - Electronics)

---

## ⚠️ 3. Critical Edge Cases & Gotchas

### 🚨 Gotcha 1: The `NOT IN` with `NULL` Trap
If a list or subquery contains even a single `NULL` value, `NOT IN` will return **0 rows (empty result)**!

```sql
-- Suppose category contains: ('Electronics', 'Clothing', NULL)
SELECT * FROM products 
WHERE category NOT IN ('Electronics', NULL); 
-- Returns 0 rows!
```
* **Why?** In SQL Three-Valued Logic:
  `category != 'Electronics' AND category != NULL`
  $\rightarrow$ `TRUE AND NULL` $\rightarrow$ **`NULL` (UNKNOWN)**.
  Since the `WHERE` clause requires `TRUE`, all rows are discarded!

> [!CAUTION]
> In production and subqueries, use **`NOT EXISTS`** or explicitly filter out `NULL`s (`WHERE col NOT IN (SELECT col FROM tbl WHERE col IS NOT NULL)`) to avoid silent failure.

---

### 🚨 Gotcha 2: `BETWEEN` with Dates and Timestamps
When filtering date ranges, `BETWEEN` can accidentally exclude data on the end date because date strings default to `00:00:00`.

```sql
-- ❌ MISTAKE: Ignores rows created on 2026-01-31 at 14:30:00!
WHERE created_at BETWEEN '2026-01-01' AND '2026-01-31';

-- ✅ BEST PRACTICE: Half-open interval [start, end)
WHERE created_at >= '2026-01-01' AND created_at < '2026-02-01';
```

---

## 💼 4. Top Interview Questions

### ❓ Q1: How does PostgreSQL internally optimize `WHERE column IN ('A', 'B', 'C')`?
* **Answer:**
  * In PostgreSQL, `column IN ('A', 'B', 'C')` is internally rewritten by the query planner into **`column = ANY(ARRAY['A', 'B', 'C'])`** or an **Index Scan with Scalar Array Op**.
  * If a B-Tree index exists on `column`, PostgreSQL performs direct index lookups for each discrete value in the array rather than scanning the whole table.
  * For very large lists (e.g., thousands of items), joining against an `UNNEST(ARRAY[...])` or a temporary table is often faster than a massive `IN (...)` clause.

---

### ❓ Q2: Is `BETWEEN` strictly inclusive or exclusive? What happens if you reverse the arguments like `BETWEEN 500 AND 100`?
* **Answer:**
  * `BETWEEN` is **strictly inclusive**: `BETWEEN a AND b` translates to `value >= a AND value <= b`.
  * If you write `BETWEEN 500 AND 100`, PostgreSQL evaluates `value >= 500 AND value <= 100`, which is mathematically impossible for a single number. The query will return **0 rows** without raising an error.
  * *PostgreSQL Extension*: PostgreSQL supports `BETWEEN SYMMETRIC a AND b`, which automatically sorts the boundaries so `BETWEEN SYMMETRIC 500 AND 100` works as `BETWEEN 100 AND 500`.

---

### ❓ Q3: `NOT IN` vs `NOT EXISTS`: Which one is better in subqueries and why?
* **Answer:** **`NOT EXISTS` is strongly preferred** in subqueries for two reasons:
  1. **Safety with `NULL`s**: If the subquery returns a `NULL`, `NOT IN` breaks and yields zero rows. `NOT EXISTS` handles `NULL` values correctly because it checks only for the existence of rows matching the correlation condition.
  2. **Performance**: The PostgreSQL query planner can optimize `NOT EXISTS` into an **Anti-Join (Hash Anti-Join or Merge Anti-Join)**, stopping as soon as the first matching row is encountered.
