# 📊 Table Creation, Constraints & Data Insertion (`03_first_table.sql`)

---

## 📌 1. Core Concepts & Syntax Breakdown

```sql
CREATE TABLE basics.students (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE,
    age INTEGER CHECK(age > 18),
    created_at TIMESTAMP DEFAULT NOW()
);
```

| Clause / Constraint | What It Does | Why & When to Use |
| :--- | :--- | :--- |
| **`SERIAL PRIMARY KEY`** | Auto-incrementing integer (1, 2, 3...) that uniquely identifies each row. | Every table should have a Primary Key for fast row lookups. |
| **`NOT NULL`** | Rejects inserting any row where this column is empty/missing (`NULL`). | For required fields like user names, password hashes, or titles. |
| **`UNIQUE`** | Ensures no two rows can have the same value in this column. | For emails, usernames, social security numbers, or slugs. |
| **`CHECK(age > 18)`** | Custom rule that validates data before saving (must evaluate to `TRUE`). | Business logic rules (e.g., `price > 0`, `discount <= 100`, `age >= 18`). |
| **`DEFAULT NOW()`** | Automatically inserts the current date and time if no value is provided. | Audit columns (e.g., `created_at`, `updated_at`). |

---

## 🔑 2. Golden Rule: Quotes in PostgreSQL

* **Single Quotes (`'text'`)** $\rightarrow$ For **Text / String Values** (`'UV'`, `'admin@test.com'`).
* **Double Quotes (`"column"`)** $\rightarrow$ For **Table & Column Names / Identifiers** (`"first_name"`, `"students"`).

---

## 💼 3. Top Interview Questions & Answers

### ❓ Q1: What is the difference between `PRIMARY KEY` and `UNIQUE` constraint?
* **Answer:**
  * A table can have **only ONE `PRIMARY KEY`**, and it **never allows `NULL`** values.
  * A table can have **MULTIPLE `UNIQUE` constraints**, and `UNIQUE` columns **can allow `NULL`** values (unless explicitly marked `NOT NULL`).

---

### ❓ Q2: How does `SERIAL` work behind the scenes in PostgreSQL?
* **Answer:**
  * `SERIAL` is not a true data type; it is a shortcut.
  * Behind the scenes, PostgreSQL creates an independent **`SEQUENCE`** object, sets the column type to `INTEGER`, and assigns its default value to `nextval('sequence_name')`.

---

### ❓ Q3: What happens when an `INSERT` violates a `CHECK` constraint?
* **Answer:**
  * PostgreSQL immediately aborts the query and throws an error: `ERROR: new row for relation "students" violates check constraint`.
  * **No data is inserted**, protecting database integrity.

---

### ❓ Q4: Why did `INSERT INTO ... VALUES ("UV", ...)` fail with `column "UV" does not exist`?
* **Answer:**
  * In ANSI SQL and PostgreSQL, double quotes (`" "`) represent **identifiers** (column/table names). PostgreSQL looked for a column named `UV` instead of reading it as literal text. Text data must always use single quotes (`'UV'`).

---

### ❓ Q5: What is the difference between `TIMESTAMP` and `TIMESTAMPTZ`?
* **Answer:**
  * `TIMESTAMP` (without timezone) stores the raw date and time without timezone context.
  * `TIMESTAMPTZ` (with timezone) converts input times to UTC for storage and converts them back to the client's local timezone when queried. *(Best practice in production is always `TIMESTAMPTZ`)*.
