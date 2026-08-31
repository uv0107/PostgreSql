# 🧩 NULL vs Empty String (`''`) vs Zero (`0`) (`06_null_empty_string_zero.sql`)

This document provides an in-depth breakdown of one of the most important concepts in SQL: the difference between **`NULL`**, **Empty String (`''`)**, and **Zero (`0`)**, along with Three-Valued Logic (3VL), aggregation traps, and interview questions.

---

## 📑 Table of Contents
1. [Core Mental Model & Definitions](#-core-mental-model--definitions)
2. [🏢 The Classic Real-World Analogy](#-the-classic-real-world-analogy)
3. [📊 Comparison Matrix](#-comparison-matrix)
4. [⚠️ The `NULL` Comparison Trap: Why `= NULL` Fails](#️-the-null-comparison-trap-why--null-fails)
5. [🔍 Step-by-Step Query Breakdown](#-step-by-step-query-breakdown)
6. [🧮 How Aggregate Functions (`COUNT`, `SUM`, `AVG`) Treat `NULL`](#-how-aggregate-functions-count-sum-avg-treat-null)
7. [🛠️ Essential SQL Functions for Handling NULLs](#-essential-sql-functions-for-handling-nulls)
8. [💼 Top Interview Questions & Tricky Scenarios](#-top-interview-questions--tricky-scenarios)
9. [📌 Summary Cheatsheet](#-summary-cheatsheet)

---

## 🧠 Core Mental Model & Definitions

```
┌─────────────────┬──────────────────┬──────────────────────────────────────┐
│ Concept         │ Is it a value?   │ Meaning / Representation             │
├─────────────────┼──────────────────┼──────────────────────────────────────┤
│ 0 (Zero)        │ ✅ YES           │ Known numeric quantity equal to zero │
│ '' (Empty Str)  │ ✅ YES           │ Known text string of length 0        │
│ NULL            │ ❌ NO            │ Unknown, Missing, or Not Applicable  │
└─────────────────┴──────────────────┴──────────────────────────────────────┘
```

* **`0`**: A student took the test and scored **0 points**. (Known score).
* **`''`**: A user explicitly submitted a form leaving a text box completely empty. (Known text of length 0).
* **`NULL`**: A student was **absent** from the exam. We do *not* know their score. (Unknown / missing data).

---

## 🏢 The Classic Real-World Analogy

```
   [ 🧻 Full Roll ]            [ 🧻 Empty Roll ]           [ 🚫 Empty Holder ]
   Value = "Hello"              Value = "" (Empty)             Value = NULL
  (Has paper inside)        (Cardboard tube is there,      (No roll exists at all;
                                but it is empty)              completely absent)
```

---

## 📊 Comparison Matrix

| Property | `0` (Zero) | `''` (Empty String) | `NULL` |
| :--- | :--- | :--- | :--- |
| **Data Type** | Numeric (`INTEGER`, `DECIMAL`) | Text (`TEXT`, `VARCHAR`) | Untyped / State of absence |
| **Storage** | Occupies regular integer bytes | Occupies header bytes | Bit in the row's null bitmap |
| **Equality Check** | `col = 0` | `col = ''` | `col IS NULL` *(Never `= NULL`)* |
| **Inequality Check** | `col != 0` | `col != ''` | `col IS NOT NULL` |
| **String Length** | N/A | `LENGTH('')` $\rightarrow$ `0` | `LENGTH(NULL)` $\rightarrow$ `NULL` |
| **Mathematical Sum** | `10 + 0 = 10` | N/A | `10 + NULL = NULL` |

---

## ⚠️ The `NULL` Comparison Trap: Why `= NULL` Fails

In SQL, comparisons follow **Three-Valued Logic (3VL)**:
* `TRUE`
* `FALSE`
* `UNKNOWN`

When you compare anything with `NULL` using `=`, SQL does not know the value, so it returns `UNKNOWN` (which evaluates to `FALSE` in a `WHERE` clause):

```sql
-- ❌ WRONG: Always returns 0 rows!
SELECT * FROM basics.value_examples WHERE name = NULL;

-- ❌ WRONG: Also returns 0 rows!
SELECT * FROM basics.value_examples WHERE name != NULL;

-- ✅ CORRECT: Uses SQL's dedicated NULL operators
SELECT * FROM basics.value_examples WHERE name IS NULL;
SELECT * FROM basics.value_examples WHERE name IS NOT NULL;
```

---

## 🔍 Step-by-Step Query Breakdown

Given the sample table data:
```text
 id | name   | nickname | score 
----+--------+----------+-------
  1 | NULL   | uv       |    10
  2 | ''     | loki     |     0
  3 | gana   | NULL     |  NULL
  4 | ''     | NULL     |    20
  5 | NULL   | NULL     |  NULL
  6 | gana   | ''       |     0
```

### 1. `WHERE name IS NULL;`
* **Matches:** Rows where `name` is completely missing.
* **Returned IDs:** `1`, `5` (2 rows).

### 2. `WHERE name IS NOT NULL;`
* **Matches:** Rows where `name` has *any* value (including empty string `''`!).
* **Returned IDs:** `2`, `3`, `4`, `6` (4 rows).
* 💡 *Notice:* Empty strings `''` **are NOT NULL**, so rows `2` and `4` are included!

### 3. `WHERE name = '';`
* **Matches:** Only rows where `name` is explicitly an empty string.
* **Returned IDs:** `2`, `4` (2 rows).

### 4. `WHERE score = 0;`
* **Matches:** Only rows where `score` is numerically equal to 0.
* **Returned IDs:** `2`, `6` (2 rows). *(Row 3 and 5 with `NULL` score are ignored)*.

---

## 🧮 How Aggregate Functions (`COUNT`, `SUM`, `AVG`) Treat `NULL`

This is a classic trap in database reporting:

```sql
SELECT 
    COUNT(*) AS total_rows,        -- Counts ALL rows (even if all columns are NULL)
    COUNT(score) AS score_count,   -- Counts only NON-NULL scores
    SUM(score) AS total_score,     -- Sums non-null values (10 + 0 + 20 + 0 = 30)
    AVG(score) AS average_score    -- 30 / 4 non-null rows = 7.5 (NOT 30 / 6!)
FROM basics.value_examples;
```

### 📊 Aggregate Output:
| `total_rows` | `score_count` | `total_score` | `average_score` |
| :--- | :--- | :--- | :--- |
| **`6`** | **`4`** | **`30`** | **`7.5`** |

> ⚠️ **Key Takeaway:** `AVG(column)` divides by the count of **non-NULL rows** (4), **not** the total number of table rows (6)! If you want absent scores to count as 0 in an average, you must use `COALESCE(score, 0)`.

---

## 🛠️ Essential SQL Functions for Handling NULLs

### 1. `COALESCE(val1, val2, ...)` — *Fallback / Default Value*
Returns the **first non-null** value from the arguments list:
```sql
SELECT name, COALESCE(nickname, 'No Nickname') AS display_name
FROM basics.value_examples;
```

### 2. `NULLIF(val1, val2)` — *Prevent Division by Zero*
Returns `NULL` if `val1 = val2`; otherwise returns `val1`.
```sql
-- Prevents "division by zero" error:
SELECT total_revenue / NULLIF(total_orders, 0) AS avg_order_val;
```

### 3. `CONCAT()` vs `||` (String Concatenation)
* **Using `||` operator:** `'Hello ' || NULL` $\rightarrow$ `NULL` (Any string concatenated with NULL becomes NULL).
* **Using `CONCAT()` function:** `CONCAT('Hello ', NULL)` $\rightarrow$ `'Hello '` (Treats NULL as an empty string).

---

## 💼 Top Interview Questions & Tricky Scenarios

### ❓ Q1: What does `SELECT NULL = NULL;` return?
* **Answer:** It returns **`NULL`** (Unknown), not `TRUE` or `FALSE`. Because two unknown values cannot be proven equal.
* *Exception:* In `DISTINCT` or `GROUP BY` operations, PostgreSQL treats `NULL`s as equal for grouping purposes.

---

### ❓ Q2: Can a `UNIQUE` column in PostgreSQL contain multiple `NULL` values?
* **Answer:** **Yes!** By default in SQL and PostgreSQL, multiple rows can have `NULL` in a `UNIQUE` column because each `NULL` is considered distinct/unknown from every other `NULL`.
* *(Note: In PostgreSQL 15+, you can optionally enforce `UNIQUE NULLS NOT DISTINCT` if you want only one NULL allowed).*

---

### ❓ Q3: What is the difference between `COUNT(*)` and `COUNT(column_name)`?
* **Answer:**
  * `COUNT(*)` counts the total number of rows in the table/result set regardless of column values.
  * `COUNT(column_name)` ignores `NULL` values and only counts rows where that specific column is `NOT NULL`.

---

### ❓ Q4: What happens when you do `10 + NULL` in SQL?
* **Answer:** It returns **`NULL`**. Any arithmetic operation involving `NULL` results in `NULL`.

---

### ❓ Q5: How do you check for both `NULL` and empty string `''` in a single condition?
* **Answer:**
  ```sql
  -- Method 1: Explicit OR
  WHERE name IS NULL OR name = ''
  
  -- Method 2: Using NULLIF with IS NULL
  WHERE NULLIF(TRIM(name), '') IS NULL
  
  -- Method 3: Using COALESCE
  WHERE COALESCE(TRIM(name), '') = ''
  ```

---

## 📌 Summary Cheatsheet

| Scenario | Condition | Explanation |
| :--- | :--- | :--- |
| Check if missing | `col IS NULL` | Matches only `NULL` entries. |
| Check if present | `col IS NOT NULL` | Matches anything that is not `NULL` (including `''` and `0`). |
| Check if blank string | `col = ''` | Matches only zero-length strings. |
| Check if zero | `col = 0` | Matches numeric 0. |
| Provide fallback | `COALESCE(col, 'default')` | Replaces `NULL` with `'default'`. |
| Safe division | `a / NULLIF(b, 0)` | Turns `0` denominator into `NULL` to avoid division error. |
