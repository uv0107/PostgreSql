# ⚡ Logical Operators: AND, OR, NOT (`06_and_or_not_filters.sql`)

This script explores compound filtering conditions in PostgreSQL using boolean logical operators (`AND`, `OR`, `NOT`) and operator precedence rules.

---

## 📌 1. Core Syntax & Code Walkthrough

```sql
-- 1. AND: ALL conditions must be TRUE
SELECT * FROM products
WHERE category = 'Electronics' AND price > 500;

-- 2. OR: AT LEAST ONE condition must be TRUE
SELECT * FROM products
WHERE category = 'Electronics' OR price > 500;

-- 3. NOT: Reverses / inverts the boolean condition
SELECT * FROM products
WHERE NOT category = 'Electronics';

-- 4. Parentheses: Explicit grouping for complex business logic
SELECT name, category, stock FROM products
WHERE (category = 'Electronics' AND stock < 50) OR price > 1000;
```

---

## 📊 2. Truth Tables & Boolean Logic

| Condition A | Condition B | `A AND B` | `A OR B` | `NOT A` |
| :--- | :--- | :--- | :--- | :--- |
| `TRUE` | `TRUE` | **`TRUE`** | **`TRUE`** | `FALSE` |
| `TRUE` | `FALSE` | **`FALSE`** | **`TRUE`** | `FALSE` |
| `FALSE` | `TRUE` | **`FALSE`** | **`TRUE`** | `TRUE` |
| `FALSE` | `FALSE` | **`FALSE`** | **`FALSE`** | `TRUE` |
| `TRUE` | `NULL` | `NULL` | `TRUE` | `FALSE` |
| `FALSE` | `NULL` | `FALSE` | `NULL` | `TRUE` |

---

## 🎯 3. Operator Precedence & Parentheses

SQL evaluates logical operators in the following strict order of precedence:

1. **Parentheses `()`** (Highest — evaluated first)
2. **Comparison operators** (`=`, `>`, `<`, etc.)
3. **`NOT`**
4. **`AND`**
5. **`OR`** (Lowest — evaluated last)

> [!WARNING]
> Because `AND` has higher precedence than `OR`, writing `A OR B AND C` is evaluated by the database engine as `A OR (B AND C)`.
> Always use explicit **parentheses `()`** to prevent logic bugs and keep queries readable.

### Breakdown of Example 4:
```sql
WHERE (category = 'Electronics' AND stock < 50) OR price > 1000;
```
* **Group 1**: Matches any product that is in `'Electronics'` **AND** has low stock (`< 50`).
* **Group 2**: Matches any product where the price exceeds `$1000`, regardless of category or stock.

---

## 💼 4. Top Interview Questions

### ❓ Q1: How does Operator Precedence cause hidden bugs in multi-condition queries?
* **Answer:** Missing parentheses when mixing `AND` and `OR` often produces incorrect results. For example:
  ```sql
  -- Intended: Active products that are either Electronics or Audio
  -- Actual execution: All active Electronics + ANY Audio (active or inactive)
  SELECT * FROM products
  WHERE is_active = true AND category = 'Electronics' OR category = 'Audio';

  -- ✅ FIX: Explicit grouping
  SELECT * FROM products
  WHERE is_active = true AND (category = 'Electronics' OR category = 'Audio');
  ```

---

### ❓ Q2: What happens when `NOT` is applied to a condition involving `NULL`?
* **Answer:** In SQL Three-Valued Logic (3VL), evaluating `category = 'Electronics'` against a row where `category` is `NULL` results in `NULL` (UNKNOWN). Applying `NOT (UNKNOWN)` still yields `NULL` (UNKNOWN).
  * As a result, `WHERE NOT (category = 'Electronics')` **will not return rows where `category` is `NULL`**.
  * To include `NULL` rows, write: `WHERE category != 'Electronics' OR category IS NULL`.

---

### ❓ Q3: How do `AND` vs `OR` filters impact indexing and query execution?
* **Answer:**
  * **`AND` queries** can efficiently utilize **Composite Multi-Column Indexes** (e.g., `CREATE INDEX ON products(category, price)`), filtering both conditions in a single index lookup.
  * **`OR` queries** cannot be satisfied by a single multi-column index. PostgreSQL will either perform a **BitmapOr** scan across two separate single-column indexes or fall back to a full **Sequential Scan** if indexes cannot be combined efficiently.
