# 🏗️ Base Schema Setup (`01_sql_concepts_basefile.sql`)

This script establishes the core `products` table schema used throughout Part 2, implementing real-world constraints, defaults, and data types.

---

## 📌 1. Core Syntax & Architecture

```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;

DROP TABLE IF EXISTS products;

CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    price NUMERIC(10,2) NOT NULL CHECK (price > 0),
    stock INTEGER DEFAULT 0 CHECK (stock >= 0),
    is_active BOOLEAN DEFAULT TRUE,
    sku TEXT UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
```

* **`UUID PRIMARY KEY`**: Distributed, secure, collision-proof primary key generated via `gen_random_uuid()`.
* **`NUMERIC(10,2)`**: Exact decimal precision for financial amounts (prevents floating-point rounding errors).
* **`CHECK (price > 0)` & `CHECK (stock >= 0)`**: Enforces business rules at the database engine level.
* **`sku TEXT UNIQUE`**: Enforces distinct Stock Keeping Units across all products.

---

## 💼 2. Top Interview Questions

### ❓ Q1: Why use `NUMERIC(10, 2)` instead of `FLOAT` or `DOUBLE PRECISION` for money?
* **Answer:** `FLOAT` and `DOUBLE` use binary floating-point representation, which introduces rounding inaccuracies (e.g., `0.1 + 0.2 = 0.30000000000000004`). `NUMERIC` / `DECIMAL` stores exact decimal digits, which is critical for financial and e-commerce calculations.

---

### ❓ Q2: What is the purpose of `CREATE EXTENSION IF NOT EXISTS pgcrypto`?
* **Answer:** In PostgreSQL 12 and older, `gen_random_uuid()` required the `pgcrypto` extension. In PostgreSQL 13+, `gen_random_uuid()` is built-in natively, but using `IF NOT EXISTS` ensures backward compatibility across older environments.

---

### ❓ Q3: Why enforce constraints like `CHECK (stock >= 0)` in SQL if the backend application already validates it?
* **Answer:** **Defense-in-depth**. Application logic can have bugs, race conditions (e.g., concurrent purchases), or direct database updates by DBAs. Database constraints guarantee data integrity regardless of how the data is written.
