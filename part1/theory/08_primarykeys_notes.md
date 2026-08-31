# 🔑 Primary Keys in PostgreSQL (`08_primarykeys.sql`)

A **Primary Key** is a constraint that uniquely identifies each row in a database table. It is the combination of **`UNIQUE`** and **`NOT NULL`**.

---

## 📌 1. Core Syntax & Table Definition

```sql
CREATE TABLE basics.user (
    id SERIAL,
    first_name TEXT,
    last_name TEXT,
    PRIMARY KEY (id)  -- Table-level Primary Key definition
);
```

* **Column-level vs Table-level**: `id SERIAL PRIMARY KEY` is identical in behavior to defining `id SERIAL` with `PRIMARY KEY (id)` at the table level. Table-level syntax is required when creating composite primary keys spanning multiple columns (e.g., `PRIMARY KEY (order_id, item_id)`).

---

## ⚠️ 2. Duplicate Key Violation Error

In [`08_primarykeys.sql`](file:///Users/atul/Desktop/PostgreSQL_full_course/part1/08_primarykeys.sql), inserting three initial records auto-generated IDs `1, 2, 3` via `SERIAL`.

When attempting to insert an explicit row with `id = 1`:
```sql
INSERT INTO basics.user(id, first_name, last_name)
VALUES (1, 'Kingvamsi', 'uv');
```

**PostgreSQL Error:**
```text
ERROR: duplicate key value violates unique constraint "user_pkey"
DETAIL: Key (id)=(1) already exists.
```

> 💡 **Why:** The Primary Key guarantees row identity and uniqueness. Any insert or update containing an existing key value is immediately rejected to prevent data corruption.

---

## 💼 3. Top Interview Questions on Primary Keys

### ❓ Q1: What is the difference between `PRIMARY KEY` and `UNIQUE` constraint?
* **`PRIMARY KEY`**: A table can have **only ONE** primary key. It strictly forbids `NULL` values.
* **`UNIQUE`**: A table can have **MULTIPLE** unique constraints. By default, `UNIQUE` allows `NULL` values (unless explicitly marked `NOT NULL`).

---

### ❓ Q2: What is the difference between a Natural Key and a Surrogate Key?
* **Surrogate Key**: An artificial, system-generated identifier with no business meaning (e.g., `SERIAL`, `BIGSERIAL`, or `UUID`).
* **Natural Key**: A unique real-world attribute that has business meaning (e.g., Email, PAN/SSN, Passport Number).
* *Best Practice:* Surrogate keys are preferred as primary keys because natural keys can change (e.g., a user updating their email).

---

### ❓ Q3: What is a Composite Primary Key?
* A primary key made of **two or more columns** together.
* *Example:* In an order-items join table:
  ```sql
  PRIMARY KEY (order_id, product_id)
  ```
  Neither column needs to be unique on its own, but the **combination** of `(order_id, product_id)` must always be unique.

---

### ❓ Q4: Does PostgreSQL automatically create an index for a Primary Key?
* **Yes.** PostgreSQL automatically generates a **Unique B-Tree Index** named `<table>_pkey` on the primary key column(s), enabling fast row lookups and enforcing uniqueness.
