# 📁 Schema & Extensions in PostgreSQL

## 1. What is a Schema?
A **Schema** is a logical container (like a folder or namespace) inside a database used to organize tables, views, and functions.

> **Hierarchy:** `Database ➔ Schema ➔ Tables ➔ Rows & Columns`

---

## 2. What is an Extension?
An **Extension** is an add-on package/plugin that extends PostgreSQL by adding new functions, data types, or tools (e.g., `pgcrypto` for encryption/hashing, `uuid-ossp` for UUIDs).

```sql
-- Enable an extension
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```

---

## 3. Query to List All Schemas
```sql
SELECT schema_name 
FROM information_schema.schemata
ORDER BY schema_name;
```
* **Explanation:** Queries standard SQL metadata to retrieve and list all schema names in the current database in alphabetical order.

---

## 4. Understanding the Schemas Output

```text
    schema_name     
--------------------
 basics
 information_schema
 pg_catalog
 pg_toast
 public
(5 rows)
```
<!-- important to know -->
* **`basics`**: Your custom user-defined schema.
* **`public`**: The default schema where tables are created if no schema name is specified.
* **`pg_catalog`**: PostgreSQL's internal schema containing built-in system tables, types, and functions.
* **`information_schema`**: Standard views that hold information and metadata about all database objects.
* **`pg_toast`**: Internal system schema used to store large/oversized data (like massive text or JSON) out-of-line.
<!-- important to know -->
