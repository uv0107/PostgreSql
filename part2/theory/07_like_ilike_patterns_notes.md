# 🔍 Pattern Matching: LIKE, ILIKE & Wildcards (`07_like_ilike_patterns.sql`)

This guide covers string pattern matching in PostgreSQL using `LIKE`, `ILIKE`, `NOT LIKE`, and wildcard characters (`%`, `_`), along with index performance considerations.

---

## 📌 1. What is Pattern Matching?

Unlike the equality operator (`=`) which requires an exact, character-for-character match, **pattern matching** allows you to search for strings that fit a particular format, prefix, suffix, or substring.

```sql
-- Exact match: Returns rows where name is EXACTLY 'iPhone 15 Pro'
SELECT * FROM products WHERE name = 'iPhone 15 Pro';

-- Pattern match: Returns rows where name starts with 'iPhon' regardless of what follows
SELECT * FROM products WHERE name LIKE 'iPhon%';
```

---

## 🔑 2. Wildcard Characters Reference

PostgreSQL provides two fundamental wildcard characters for pattern matching:

| Wildcard | Meaning | Example Pattern | Matches | Does NOT Match |
| :---: | :--- | :--- | :--- | :--- |
| **`%`** | Matches **zero, one, or multiple** characters | `'iPhon%'` | `'iPhone'`, `'iPhone 15 Pro'`, `'iPhones'` | `'Apple iPhone'` |
| **`%`** | Substring match (contains) | `'%wear%'` | `'Footwear'`, `'Sportswear'`, `'wear'` | `'Cloth'` |
| **`_`** | Matches **exactly one single** character | `'H_M'` | `'H&M'`, `'H-M'`, `'H M'` | `'HM'`, `'H&&M'` |
| **`_` + `%`** | Exact prefix length + variable suffix | `'___-%'` | `'ACC-LOGI'`, `'AUD-SONY'` | `'AC-LOGI'` |

---

## ⚔️ 3. `LIKE` vs `ILIKE`: What is the Difference?

| Feature | `LIKE` | `ILIKE` |
| :--- | :--- | :--- |
| **Case Sensitivity** | **Case-Sensitive** (`'a' != 'A'`) | **Case-Insensitive** (`'a' == 'A'`) |
| **SQL Standard** | Standard ANSI SQL (supported by all RDBMS) | **PostgreSQL Extension** (not portable to MySQL/SQL Server) |
| **Standard SQL Alternative** | `LOWER(col) LIKE LOWER('pattern')` | N/A (Native to Postgres) |
| **Negation** | `NOT LIKE` | `NOT ILIKE` |

### Comparison Example:
```sql
-- Target string: 'iPhone 15 Pro'

WHERE name LIKE 'iphon%';   -- ❌ FALSE (lowercase 'i' vs capital 'I')
WHERE name LIKE 'iPhon%';   -- ✅ TRUE  (matches exact case)
WHERE name ILIKE 'iphon%';  -- ✅ TRUE  (case-insensitive match)
WHERE name ILIKE 'IPHONE%'; -- ✅ TRUE  (case-insensitive match)
```

---

## 💻 4. Code Walkthrough (`07_like_ilike_patterns.sql`)

### Query 1: Prefix Pattern Match (`LIKE`)
```sql
SELECT name, price 
FROM products
WHERE name LIKE 'iPhon%';
```
* **Explanation**: Matches any product name beginning with `iPhon` followed by any sequence of characters.
* **Matches**: `iPhone 15 Pro`

---

### Query 2: Case-Insensitive Substring Match (`ILIKE`)
```sql
SELECT name, price
FROM products
WHERE name ILIKE '%summer%';
```
* **Explanation**: Finds products where the word `summer` appears anywhere in the name, ignoring casing (`Summer`, `SUMMER`, `summer`).
* **Matches**: `Zara Floral Summer Dress`

---

### Query 3: Inverting Patterns (`NOT LIKE`)
```sql
SELECT name, price
FROM products
WHERE name NOT LIKE 'iPhon%';
```
* **Explanation**: Returns all products whose name does **not** start with `iPhon`.

---

### Query 4: Multi-Column Compound Pattern Matching (`OR`)
```sql
SELECT name, price 
FROM products
WHERE name LIKE '%wear%'
   OR description ILIKE '%A17%';
```
* **Explanation**: Returns rows where the product name contains the substring `'wear'` (case-sensitive) **OR** the description contains `'A17'` (case-insensitive).
* **Result Set**:
  1. `Nike Sportswear Club Fleece Hoodie` (matched by `name LIKE '%wear%'`)
  2. `iPhone 15 Pro` (matched by `description ILIKE '%A17%'`)

---

## 🛡️ 5. Escaping Literal Wildcards (`%` and `_`)

If you want to search for an actual percent sign (`%`) or underscore (`_`) in your data, use the **`ESCAPE`** clause or default backslash escape:

```sql
-- Search for discount values containing a literal '%' sign:
SELECT * FROM promotions WHERE discount_code LIKE '%\%%' ESCAPE '\';

-- Search for SKU patterns containing a literal underscore '_':
SELECT * FROM products WHERE sku LIKE 'FOOT\_%' ESCAPE '\';
```

---

## 💼 6. Top Interview Questions

### ❓ Q1: What is the difference between `LIKE` and `ILIKE` in PostgreSQL, and how do you write case-insensitive pattern matching in database-agnostic standard SQL?
* **Answer:**
  * **`LIKE`** is the ANSI SQL standard case-sensitive pattern matching operator.
  * **`ILIKE`** is a PostgreSQL-specific operator for case-insensitive pattern matching.
  * In standard SQL (or other databases like Oracle/MySQL/SQL Server), `ILIKE` does not exist. To achieve portable case-insensitive matching across any database, use the `LOWER()` or `UPPER()` function:
    ```sql
    -- ANSI SQL standard portable equivalent of ILIKE
    SELECT name, price 
    FROM products 
    WHERE LOWER(name) LIKE LOWER('%summer%');
    ```

---

### ❓ Q2: What is SARGability, and why does `LIKE 'iPhone%'` perform well while `LIKE '%wear%'` causes performance bottlenecks?
* **Answer:**
  * **SARGable (Search Argument Able)** queries can leverage traditional **B-Tree indexes**.
  * **Prefix Search (`LIKE 'iPhone%'`) is SARGable**: A B-Tree index stores strings in sorted alphabetical order. Looking for strings starting with `'iPhone'` allows the engine to jump directly to the `'iPhone'` range (Index Range Scan) in $O(\log N)$ time.
  * **Leading Wildcard (`LIKE '%wear%'`) is NOT SARGable**: Because the string can start with any character, the database cannot use a standard B-Tree index and is forced to perform a **Full Table Scan (Sequential Scan)** across every row on disk.

> [!TIP]
> To enable standard B-Tree index support on text columns using `LIKE 'Prefix%'`, use the `text_pattern_ops` operator class in PostgreSQL:
> ```sql
> CREATE INDEX idx_products_name_prefix ON products (name text_pattern_ops);
> ```

---

### ❓ Q3: How do you optimize leading wildcard searches (`LIKE '%keyword%'` or `ILIKE '%keyword%'`) in PostgreSQL for large datasets?
* **Answer:**
  For fast substring and case-insensitive searches across millions of rows, use **Trigram (`pg_trgm`)** indexes:
  ```sql
  -- 1. Enable the pg_trgm extension
  CREATE EXTENSION IF NOT EXISTS pg_trgm;

  -- 2. Create a GIN (Generalized Inverted Index) Trigram Index
  CREATE INDEX idx_products_name_trgm ON products USING gin (name gin_trgm_ops);

  -- 3. Query now performs a fast Bitmap Index Scan instead of a Seq Scan
  SELECT name, price FROM products WHERE name ILIKE '%wear%';
  ```
  Trigram indexes break text into 3-character slices (e.g., `'wear'` $\rightarrow$ `[' w', 'wea', 'ear', 'ar ']`), enabling blazing-fast substring search.

---

### ❓ Q4: What is the difference between `LIKE` / `ILIKE`, Regular Expressions (`~` / `~*`), and Full-Text Search (`tsvector`)?

| Feature | `LIKE` / `ILIKE` | Regular Expressions (`~` / `~*`) | Full-Text Search (`tsvector`) |
| :--- | :--- | :--- | :--- |
| **Complexity** | Simple wildcards (`%`, `_`) | Complex regex patterns (`^[A-Z]{3}-[0-9]+$`) | Natural language search (stemming, stopwords, ranking) |
| **Use Case** | Prefix / substring matching | Strict format validation | Article search, document search |
| **Index Support** | B-Tree (prefix), GIN / GiST Trigram | GIN / GiST Trigram | GIN Index on `tsvector` |
| **Performance** | Fast for prefixes | Slower execution per row | Extremely fast for linguistic text searches |
