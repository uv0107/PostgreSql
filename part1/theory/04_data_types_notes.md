# 📊 PostgreSQL Core Data Types (`04_data_types.sql`)

---

## 📌 1. Data Types Used in this Lesson

```sql
CREATE TABLE basics.product_basics (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    stock INTEGER DEFAULT 0,
    total_views BIGINT DEFAULT 0,
    price DECIMAL(10, 2),
    discount DECIMAL(10, 2) DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### 🔍 Breakdown Table:

| Column | Data Type | What It Stores | Size / Limit | Why Use It |
| :--- | :--- | :--- | :--- | :--- |
| **`id`** | `SERIAL` | Auto-incrementing numbers (1, 2, 3...) | 4 bytes (up to 2.14 billion) | Unique row identification (Primary Key). |
| **`name`** | `VARCHAR(100)` | Variable-length text with a maximum character limit | Max 100 characters | Enforce strict length limits (product names, usernames). |
| **`description`** | `TEXT` | Unlimited variable-length text | Up to 1 GB | Long descriptions, blog posts, comments. |
| **`stock`** | `INTEGER` | Whole numbers (positive/negative) | 4 bytes ($\pm 2.14$ billion) | Standard quantities, counts, inventory levels. |
| **`total_views`** | `BIGINT` | Huge whole numbers | 8 bytes ($\pm 9$ quintillion) | Large metrics (video views, analytics, big balances). |
| **`price` / `discount`** | `DECIMAL(10, 2)` | Exact fixed-point decimal numbers | 10 total digits, 2 after decimal | **Monetary values, currency, billing** (Zero rounding errors!). |
| **`is_active`** | `BOOLEAN` | True/False flags (`TRUE`, `FALSE`, `NULL`) | 1 byte | Status indicators (active/inactive, verified). |
| **`created_at` / `updated_at`** | `TIMESTAMP` | Date and Time (`YYYY-MM-DD HH:MM:SS`) | 8 bytes | Record creation and modification timestamps. |

---

## 📟 2. Why Did Terminal Show `...skipping...` and `~`?

When you ran `SELECT * FROM basics.product_basics;`, the output table was **wider than your terminal screen**.

* **The Cause:** `psql` automatically piped the wide table into a terminal pager (`less`).
* **The Symptoms:** Arrow keys scrolled the table, showing `...skipping...`, `~`, and repeated lines.
* **How to exit pager:** Press **`q`** on your keyboard.
* **How to disable pager permanently in psql:**
  ```sql
  \pset pager off
  ```
* **Best way to view wide tables in psql (`\x` Expanded Mode):**
  ```sql
  \x on
  ```
  *(Displays columns vertically, one line per column!)*

---

## 💼 3. Top Interview Questions & Answers

### ❓ Q1: What is the difference between `DECIMAL(10, 2)` and `FLOAT` in PostgreSQL?
* **Answer:**
  * **`DECIMAL` (or `NUMERIC`)** is an **exact** number type with fixed decimal places. It has zero rounding errors, making it mandatory for money and financial calculations.
  * **`FLOAT`** is an **approximate** floating-point number (IEEE 754) that can cause rounding inaccuracies (e.g., `0.1 + 0.2 = 0.30000000000000004`).

---

### ❓ Q2: Is there any performance difference between `VARCHAR(n)` and `TEXT` in PostgreSQL?
* **Answer:**
  * **No performance difference.** Both use the exact same underlying `varlena` storage engine in PostgreSQL.
  * `VARCHAR(n)` simply adds an extra validation step to check that length does not exceed $n$.

---

### ❓ Q3: When should you use `INTEGER` vs `BIGINT`?
* **Answer:**
  * Use **`INTEGER`** (4 bytes) when values will stay under 2.14 billion (e.g., product stock, user ages).
  * Use **`BIGINT`** (8 bytes) when values could exceed 2 billion (e.g., global transaction counts, social media views/likes, financial balances in cents/paise).

---

### ❓ Q4: What are the allowed values for a `BOOLEAN` column in PostgreSQL?
* **Answer:**
  * `TRUE` (or `'t'`, `'true'`, `'y'`, `'yes'`, `'1'`)
  * `FALSE` (or `'f'`, `'false'`, `'n'`, `'no'`, `'0'`)
  * `NULL` (unknown / not specified, unless marked `NOT NULL`)

---

### ❓ Q5: What is the difference between `NOW()` and `CURRENT_DATE`?
* **Answer:**
  * `NOW()` returns the full **date and time with microseconds** (`2026-08-27 23:20:03.058985`).
  * `CURRENT_DATE` returns only the **calendar date** (`2026-08-27`).
