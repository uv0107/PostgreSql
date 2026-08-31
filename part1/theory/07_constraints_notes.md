# 🛡️ PostgreSQL Constraints: Data Integrity & Rules (`07_constraints.sql`)

This document provides a comprehensive deep dive into **Database Constraints** in PostgreSQL. Constraints are rules enforced on data columns and tables to prevent invalid, inconsistent, or accidental data entry, ensuring high **data integrity**.

---

## 📑 Table of Contents
1. [Core Mental Model & Purpose](#-core-mental-model--purpose)
2. [Code Snippet & Execution Error Analysis](#-code-snippet--execution-error-analysis)
3. [The 6 Core PostgreSQL Constraints](#-the-6-core-postgresql-constraints)
   - [1. PRIMARY KEY](#1-primary-key)
   - [2. FOREIGN KEY (Referential Integrity)](#2-foreign-key-referential-integrity)
   - [3. NOT NULL](#3-not-null)
   - [4. UNIQUE](#4-unique)
   - [5. CHECK](#5-check)
   - [6. DEFAULT](#6-default)
4. [Column-Level vs Table-Level Constraints](#-column-level-vs-table-level-constraints)
5. [Naming Conventions & Best Practices](#-naming-conventions--best-practices)
6. [Managing Constraints with `ALTER TABLE`](#-managing-constraints-with-alter-table)
7. [📊 Comparison Matrix](#-comparison-matrix)
8. [💼 Top Interview Questions & Tricky Scenarios](#-top-interview-questions--tricky-scenarios)
9. [📌 Summary Cheatsheet](#-summary-cheatsheet)

---

## 🧠 Core Mental Model & Purpose

In a relational database, **constraints** act as automated gatekeepers. They guarantee that every piece of data stored adheres to business logic, data types, and relational rules.

```
                  ┌──────────────────────────────────────────┐
                  │              INCOMING INSERT             │
                  │   ('gopi', '', 20, 20)                   │
                  └────────────────────┬─────────────────────┘
                                       │
                                       ▼
                       ┌───────────────────────────────┐
                       │       CONSTRAINT CHECKS       │
                       ├───────────────────────────────┤
                       │  1. NOT NULL checks           │
                       │  2. Data Type checks          │ ──❌ Type mismatch: 20 != BOOLEAN
                       │  3. UNIQUE index checks       │
                       │  4. CHECK conditions (age>=18)│
                       │  5. FOREIGN KEY validations   │
                       └───────────────┬───────────────┘
                                       │
                     ┌─────────────────┴─────────────────┐
                     │                                   │
              [ Passed All ]                      [ Any Check Failed ]
                     │                                   │
                     ▼                                   ▼
          ✅ Committed to Table                 ❌ Transaction Aborted
                                               (Zero rows inserted)
```

---

## 📄 Code Snippet & Execution Error Analysis

### The SQL Script (`07_constraints.sql`)
```sql
DROP TABLE IF EXISTS basics.accounts;

CREATE TABLE basics.accounts (
    id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    is_active BOOLEAN DEFAULT TRUE,
    age INTEGER CHECK(age >= 18),
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO basics.accounts(full_name, email, is_active, age)
VALUES
('vamsi', 'uyyalavamsi37@gmail.com', true, 19),
('gopi', '', 20, 20),
('loki', 'lokiep420@gmail.com', true, 22);

SELECT * FROM basics.accounts;
```

---

### 🔍 Error Breakdown: Why Did the Script Fail?

When running the script, PostgreSQL returned the following error:

```text
psql:part1/07_constraints.sql:37: ERROR:  column "is_active" is of type boolean but expression is of type integer
LINE 4: ('gopi','',20,20),
                   ^
HINT:  You will need to rewrite or cast the expression.
```

#### 1. Why Did This Happen?
Look at the column list in the `INSERT` statement and the values provided for the second row:
* **Target Columns:** `(full_name, email, is_active, age)`
* **Values Row 2:** `('gopi', '', 20, 20)`
  * `full_name` $\rightarrow$ `'gopi'` (Valid text)
  * `email` $\rightarrow$ `''` (Valid text, empty string)
  * `is_active` $\rightarrow$ `20` ❌ (**ERROR**: Column is `BOOLEAN`, but value is integer `20`!)
  * `age` $\rightarrow$ `20` (Valid integer)

#### 2. Atomicity of Multi-Row Inserts:
Because PostgreSQL is ACID-compliant, an `INSERT` statement is **atomic**. Even though the 1st row (`'vamsi'`) and 3rd row (`'loki'`) were valid, the entire multi-row batch was rolled back. Result: **0 rows inserted**.

#### 3. How to Fix It:
Provide a valid boolean (`true` or `false`), or omit `is_active` to let it fall back to `DEFAULT TRUE`:

```sql
-- ✅ Fix 1: Correct the boolean value
INSERT INTO basics.accounts(full_name, email, is_active, age)
VALUES
('vamsi', 'uyyalavamsi37@gmail.com', true, 19),
('gopi', 'gopi@example.com', true, 20),
('loki', 'lokiep420@gmail.com', true, 22);

-- ✅ Fix 2: Omit columns that have DEFAULT values
INSERT INTO basics.accounts(full_name, email, age)
VALUES
('vamsi', 'uyyalavamsi37@gmail.com', 19),
('gopi', 'gopi@example.com', 20),
('loki', 'lokiep420@gmail.com', 22);
```

---

## 🛡️ The 6 Core PostgreSQL Constraints

### 1. `PRIMARY KEY`
A **Primary Key** uniquely identifies each record in a table.

* **Characteristics:**
  * Combines `UNIQUE` and `NOT NULL` automatically.
  * A table can have **only one** Primary Key.
  * Automatically creates a unique B-tree index under the hood.
  * Can consist of a single column or multiple columns (**Composite Primary Key**).

```sql
-- Single Column Primary Key
id SERIAL PRIMARY KEY

-- Composite Primary Key (Table-level)
PRIMARY KEY (order_id, product_id)
```

---

### 2. `FOREIGN KEY` (Referential Integrity)
A **Foreign Key** links a column (or set of columns) in one table to the `PRIMARY KEY` or `UNIQUE` key of another table.

* **Purpose:** Prevents orphaned records and ensures relational integrity.

```sql
CREATE TABLE basics.orders (
    order_id SERIAL PRIMARY KEY,
    account_id INTEGER REFERENCES basics.accounts(id) ON DELETE CASCADE,
    total_amount DECIMAL(10, 2) NOT NULL
);
```

#### Common `ON DELETE` / `ON UPDATE` Actions:
| Action | Behavior when referenced parent row is deleted |
| :--- | :--- |
| **`RESTRICT` / `NO ACTION`** *(Default)* | Rejects deleting the parent row if child records exist. |
| **`CASCADE`** | Automatically deletes all matching child rows when parent is deleted. |
| **`SET NULL`** | Sets foreign key column in child rows to `NULL`. |
| **`SET DEFAULT`** | Sets foreign key column in child rows to its default value. |

---

### 3. `NOT NULL`
Ensures that a column **cannot store `NULL`** (missing/unknown) values.

* **Usage:** Used for mandatory fields (e.g. `email`, `password_hash`, `created_at`).
* **Note:** An empty string `''` or `0` **is NOT NULL** and will be accepted unless restricted by a `CHECK` constraint!

```sql
full_name TEXT NOT NULL
```

---

### 4. `UNIQUE`
Ensures that all non-null values in a column (or combination of columns) are **distinct**.

* **PostgreSQL NULL Handling:** By default, PostgreSQL allows **multiple `NULL` values** in a `UNIQUE` column because `NULL != NULL` in standard SQL three-valued logic.
* In PostgreSQL 15+, you can use `UNIQUE NULLS NOT DISTINCT` to forbid multiple `NULL`s.

```sql
email TEXT NOT NULL UNIQUE
```

---

### 5. `CHECK`
Validates that values in a column satisfy a custom boolean expression before inserting or updating.

* The condition must evaluate to `TRUE` or `UNKNOWN` (`NULL`). If it evaluates to `FALSE`, the transaction errors out.

```sql
-- Simple comparison
age INTEGER CHECK(age >= 18)

-- Pattern matching / regex
email TEXT CHECK(email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')

-- Range & List inclusion
rating INTEGER CHECK(rating BETWEEN 1 AND 5)
status TEXT CHECK(status IN ('pending', 'approved', 'rejected'))
```

---

### 6. `DEFAULT`
Provides a fallback value whenever a new row is inserted without specifying that column's value.

* If an insert explicitly passes `NULL`, the `DEFAULT` is **not** used (unless overridden by identity columns).
* Defaults can be static values or dynamic function evaluations:

```sql
is_active BOOLEAN DEFAULT TRUE
created_at TIMESTAMP DEFAULT NOW()
id UUID DEFAULT gen_random_uuid()
```

---

## 📐 Column-Level vs Table-Level Constraints

Constraints can be declared either inline on a single column (**Column-Level**) or at the end of the table definition (**Table-Level**).

```sql
-- 1. COLUMN-LEVEL SYNTAX (Best for simple single-column rules)
CREATE TABLE basics.users (
    id SERIAL PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    age INT CHECK (age >= 18)
);

-- 2. TABLE-LEVEL SYNTAX (Required for multi-column rules & custom constraint names)
CREATE TABLE basics.enrollments (
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    grade CHAR(1),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,

    -- Composite Primary Key
    CONSTRAINT pk_enrollments PRIMARY KEY (student_id, course_id),

    -- Foreign Keys
    CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES basics.students(id) ON DELETE CASCADE,
    CONSTRAINT fk_course FOREIGN KEY (course_id) REFERENCES basics.courses(id) ON DELETE CASCADE,

    -- Multi-column CHECK constraint
    CONSTRAINT chk_valid_date_range CHECK (end_date >= start_date)
);
```

---

## 🏷️ Naming Conventions & Best Practices

If you do not specify a constraint name, PostgreSQL generates one automatically (e.g., `accounts_email_key` or `accounts_age_check`). In production schemas, explicitly naming constraints makes debugging and migrations significantly cleaner:

| Constraint Type | Recommended Prefix / Suffix Pattern | Example Name |
| :--- | :--- | :--- |
| **Primary Key** | `pk_<table>` | `pk_accounts` |
| **Foreign Key** | `fk_<table>_<ref_table>` | `fk_orders_accounts` |
| **Unique** | `uq_<table>_<column>` | `uq_accounts_email` |
| **Check** | `chk_<table>_<rule>` | `chk_accounts_age_adult` |
| **Default** | `df_<table>_<column>` | `df_accounts_is_active` |

---

## 🔧 Managing Constraints with `ALTER TABLE`

You can add, modify, or remove constraints on existing tables:

### 1. Adding Constraints:
```sql
-- Add a CHECK constraint
ALTER TABLE basics.accounts
ADD CONSTRAINT chk_age_limit CHECK (age >= 18);

-- Add a UNIQUE constraint
ALTER TABLE basics.accounts
ADD CONSTRAINT uq_accounts_email UNIQUE (email);

-- Add a NOT NULL constraint
ALTER TABLE basics.accounts
ALTER COLUMN full_name SET NOT NULL;
```

### 2. Dropping Constraints:
```sql
-- Drop a named constraint
ALTER TABLE basics.accounts
DROP CONSTRAINT chk_age_limit;

-- Remove NOT NULL
ALTER TABLE basics.accounts
ALTER COLUMN full_name DROP NOT NULL;
```

### 3. Adding Constraints to Large Production Tables (Safe Migrations):
On massive tables with millions of rows, adding a `CHECK` constraint can lock the table while scanning all rows. Use `NOT VALID` followed by `VALIDATE CONSTRAINT` to avoid downtime:

```sql
-- Step 1: Add constraint without blocking writes (validates only new/updated rows)
ALTER TABLE basics.accounts
ADD CONSTRAINT chk_age_limit CHECK (age >= 18) NOT VALID;

-- Step 2: Validate existing rows in background without exclusive table lock
ALTER TABLE basics.accounts
VALIDATE CONSTRAINT chk_age_limit;
```

---

## 📊 Comparison Matrix

| Constraint | Can Have Multiple per Table? | Allows `NULL`? | Auto-Creates Index? | Purpose |
| :--- | :---: | :---: | :---: | :--- |
| **`PRIMARY KEY`** | ❌ (Only 1) | ❌ No | ✅ Yes (Unique B-tree) | Uniquely identifies each row. |
| **`FOREIGN KEY`** | ✅ Yes | ✅ Yes (Unless `NOT NULL`) | ❌ No *(Index manually for join speed!)* | Enforces referential integrity between tables. |
| **`UNIQUE`** | ✅ Yes | ✅ Yes (Default allows multiple `NULL`s) | ✅ Yes (Unique B-tree) | Prevents duplicate non-null entries. |
| **`NOT NULL`** | ✅ Yes | ❌ No | ❌ No | Ensures mandatory data presence. |
| **`CHECK`** | ✅ Yes | ✅ Yes (Evaluation ignores `NULL`) | ❌ No | Validates business logic and values. |
| **`DEFAULT`** | ✅ Yes | ✅ Yes | ❌ No | Fills column when omitted from `INSERT`. |

---

## 💼 Top Interview Questions & Tricky Scenarios

### ❓ Q1: What is the difference between `PRIMARY KEY` and `UNIQUE` constraint?
* **Answer:**
  1. A table can have **only one** `PRIMARY KEY`, but **multiple** `UNIQUE` constraints.
  2. `PRIMARY KEY` automatically forbids `NULL` values. `UNIQUE` allows `NULL` values by default.
  3. Conceptually, `PRIMARY KEY` serves as the row identifier, while `UNIQUE` protects alternate unique attributes (e.g. email, phone number).

---

### ❓ Q2: Does a `FOREIGN KEY` automatically create an index in PostgreSQL?
* **Answer:** **No!** PostgreSQL automatically creates an index for `PRIMARY KEY` and `UNIQUE` constraints, but **NOT** for `FOREIGN KEY` columns.
* 💡 *Production Tip:* You should almost always manually create an index on foreign key columns (e.g. `CREATE INDEX idx_orders_account_id ON orders(account_id);`) to prevent slow `JOIN`s and table scans during parent row deletions/updates.

---

### ❓ Q3: How does a `CHECK` constraint treat `NULL` values?
* **Answer:** A `CHECK` constraint passes if the expression evaluates to `TRUE` **or `UNKNOWN` (`NULL`)**. It only fails if the expression evaluates strictly to **`FALSE`**.
* *Example:* If column `age` is `NULL`, `CHECK (age >= 18)` evaluates to `NULL` (unknown), so PostgreSQL **allows** the insert! If you want to reject `NULL`, you must combine it with `NOT NULL`: `age INTEGER NOT NULL CHECK (age >= 18)`.

---

### ❓ Q4: If an `INSERT` statement inserts 100 rows and the 99th row violates a constraint, what happens to the previous 98 rows?
* **Answer:** In PostgreSQL, the entire statement is executed inside an implicit transaction block. If any single row fails a constraint check, the entire statement is aborted, and **0 rows are inserted** (Atomicity principle of ACID).

---

### ❓ Q5: Can an empty string `''` violate a `NOT NULL` constraint?
* **Answer:** **No.** An empty string `''` is a valid string of length zero (not `NULL`). To prevent empty or whitespace-only strings, use a `CHECK` constraint:
  ```sql
  full_name TEXT NOT NULL CHECK (LENGTH(TRIM(full_name)) > 0)
  ```

---

## 📌 Summary Cheatsheet

```sql
-- Complete example with all 6 constraints applied
CREATE TABLE basics.accounts (
    id          SERIAL PRIMARY KEY,                              -- 1. PRIMARY KEY
    full_name   TEXT NOT NULL CHECK (LENGTH(TRIM(full_name)) > 0),-- 2. NOT NULL + 3. CHECK
    email       TEXT NOT NULL UNIQUE,                            -- 4. UNIQUE
    role_id     INTEGER REFERENCES basics.roles(id) ON DELETE SET NULL, -- 5. FOREIGN KEY
    is_active   BOOLEAN DEFAULT TRUE,                            -- 6. DEFAULT
    created_at  TIMESTAMP DEFAULT NOW()
);
```
