# 📊 Complete Inserted Data Reference (`part2`)

This document aggregates and categorizes all the mock/sample dataset records inserted into the `products` table across `01_sql_concepts_basefile.sql`, `02.insert_single_row.sql`, and `03_insert_multiple_rows.sql`.

---

## 📋 Table Schema Overview

```sql
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

---

## 📦 1. Base Dataset (`01_sql_concepts_basefile.sql`)

Total: **9 Rows**

| # | Name | Category | Price ($) | Stock | Active | SKU | Description |
|---|------|----------|-----------|-------|--------|-----|-------------|
| 1 | **iPhone 15 Pro** | `Electronics` | 999.99 | 45 | `true` | `ELEC-IP15P-128` | Flagship smartphone with titanium design and A17 Pro chip |
| 2 | **Samsung Galaxy S24 Ultra** | `Electronics` | 1199.99 | 30 | `true` | `ELEC-SGS24U-256` | Premium Android smartphone with Galaxy AI and S-Pen |
| 3 | **Apple MacBook Air M3** | `Computers` | 1099.00 | 25 | `true` | `COMP-MBA-M3-13` | 13-inch lightweight laptop with M3 chip and Liquid Retina display |
| 4 | **Sony WH-1000XM5** | `Audio` | 349.99 | 60 | `true` | `AUD-SONY-XM5` | Industry-leading wireless noise-canceling over-ear headphones |
| 5 | **Logitech MX Master 3S** | `Accessories` | 99.99 | 0 | `false` | `ACC-LOGI-MXM3S` | Ergonomic performance wireless mouse (Out of Stock) |
| 6 | **Zara Floral Summer Dress** | `Clothing` | 59.90 | 40 | `true` | `CLOTH-ZARA-DRS01` | Lightweight sleeveless floral print midi dress |
| 7 | **Levi's 501 Original Fit Jeans** | `Clothing` | 79.50 | 85 | `true` | `CLOTH-LEVI-501` | Classic straight-leg dark indigo denim jeans |
| 8 | **Nike Sportswear Club Fleece Hoodie** | `Clothing` | 65.00 | 110 | `true` | `CLOTH-NIKE-HD01` | Soft brushed-back fleece pullover hoodie in black |
| 9 | **Nike Air Force 1 '07** | `Footwear` | 115.00 | 120 | `true` | `FOOT-NIKE-AF1` | Classic all-white leather low-top streetwear sneakers |

### SQL Insert Query:
```sql
INSERT INTO products (name, category, price, stock, is_active, sku, description)
VALUES
-- Mobiles & Electronics
('iPhone 15 Pro', 'Electronics', 999.99, 45, true, 'ELEC-IP15P-128', 'Flagship smartphone with titanium design and A17 Pro chip'),
('Samsung Galaxy S24 Ultra', 'Electronics', 1199.99, 30, true, 'ELEC-SGS24U-256', 'Premium Android smartphone with Galaxy AI and S-Pen'),
('Apple MacBook Air M3', 'Computers', 1099.00, 25, true, 'COMP-MBA-M3-13', '13-inch lightweight laptop with M3 chip and Liquid Retina display'),

-- Audio & Gadgets
('Sony WH-1000XM5', 'Audio', 349.99, 60, true, 'AUD-SONY-XM5', 'Industry-leading wireless noise-canceling over-ear headphones'),
('Logitech MX Master 3S', 'Accessories', 99.99, 0, false, 'ACC-LOGI-MXM3S', 'Ergonomic performance wireless mouse (Out of Stock)'),

-- Clothing & Fashion
('Zara Floral Summer Dress', 'Clothing', 59.90, 40, true, 'CLOTH-ZARA-DRS01', 'Lightweight sleeveless floral print midi dress'),
('Levi''s 501 Original Fit Jeans', 'Clothing', 79.50, 85, true, 'CLOTH-LEVI-501', 'Classic straight-leg dark indigo denim jeans'),
('Nike Sportswear Club Fleece Hoodie', 'Clothing', 65.00, 110, true, 'CLOTH-NIKE-HD01', 'Soft brushed-back fleece pullover hoodie in black'),

-- Footwear
('Nike Air Force 1 ''07', 'Footwear', 115.00, 120, true, 'FOOT-NIKE-AF1', 'Classic all-white leather low-top streetwear sneakers');
```

---

## 📥 2. Single-Row Insert (`02.insert_single_row.sql`)

Total: **1 Row** (Demonstration of single-record insertion)

| # | Name | Category | Price ($) | Stock | Active | SKU | Description |
|---|------|----------|-----------|-------|--------|-----|-------------|
| 1 | **Sony WH-1000XM5** | `Audio` | 349.99 | 60 | `true` | `AUD-SONY-XM5` | Industry-leading wireless noise-canceling over-ear headphones |

### SQL Insert Query:
```sql
INSERT INTO products (name, category, price, stock, is_active, sku, description)
VALUES
('Sony WH-1000XM5', 'Audio', 349.99, 60, true, 'AUD-SONY-XM5', 'Industry-leading wireless noise-canceling over-ear headphones');
```

---

## 📚 3. Multi-Row Additional Insert (`03_insert_multiple_rows.sql`)

Total: **7 Rows**

| # | Name | Category | Price ($) | Stock | Active | SKU | Description |
|---|------|----------|-----------|-------|--------|-----|-------------|
| 1 | **Apple Watch Series 9** | `Electronics` | 399.00 | 50 | `true` | `ELEC-APL-WAT9` | Smartwatch with advanced health sensors and Always-On display |
| 2 | **PlayStation 5 Slim** | `Gaming` | 499.99 | 20 | `true` | `GAME-SONY-PS5S` | Next-gen gaming console with 1TB SSD storage |
| 3 | **Adidas Ultraboost Light** | `Footwear` | 189.99 | 75 | `true` | `FOOT-ADI-UB-LT` | High-performance running shoes with responsive boost midsole |
| 4 | **H&M Slim Fit Cotton Shirt** | `Clothing` | 29.99 | 150 | `true` | `CLOTH-HM-SHT-WHT` | Breathable slim-fit casual white cotton shirt |
| 5 | **iPad Air 11-inch M2** | `Computers` | 599.00 | 35 | `true` | `COMP-IPAD-AIR-M2` | Powerful tablet with M2 chip and Liquid Retina display |
| 6 | **Bose QuietComfort Ultra** | `Audio` | 429.00 | 40 | `true` | `AUD-BOSE-QCU` | Spatial audio wireless noise-cancelling earbuds |
| 7 | **Dyson V15 Detect Vacuum** | `Home Appliances` | 749.99 | 12 | `true` | `APPL-DYS-V15` | Cordless vacuum cleaner with laser dust detection |

### SQL Insert Query:
```sql
INSERT INTO products (name, category, price, stock, is_active, sku, description)
VALUES
-- Smartwatch & Gaming
('Apple Watch Series 9', 'Electronics', 399.00, 50, true, 'ELEC-APL-WAT9', 'Smartwatch with advanced health sensors and Always-On display'),
('PlayStation 5 Slim', 'Gaming', 499.99, 20, true, 'GAME-SONY-PS5S', 'Next-gen gaming console with 1TB SSD storage'),

-- Footwear & Apparel
('Adidas Ultraboost Light', 'Footwear', 189.99, 75, true, 'FOOT-ADI-UB-LT', 'High-performance running shoes with responsive boost midsole'),
('H&M Slim Fit Cotton Shirt', 'Clothing', 29.99, 150, true, 'CLOTH-HM-SHT-WHT', 'Breathable slim-fit casual white cotton shirt'),

-- Tablets & Audio
('iPad Air 11-inch M2', 'Computers', 599.00, 35, true, 'COMP-IPAD-AIR-M2', 'Powerful tablet with M2 chip and Liquid Retina display'),
('Bose QuietComfort Ultra', 'Audio', 429.00, 40, true, 'AUD-BOSE-QCU', 'Spatial audio wireless noise-cancelling earbuds'),

-- Home Appliances
('Dyson V15 Detect Vacuum', 'Home Appliances', 749.99, 12, true, 'APPL-DYS-V15', 'Cordless vacuum cleaner with laser dust detection');
```

---

## 🌟 Combined Master Dataset (All Unique Products - 16 Items)

| # | Name | Category | Price ($) | Stock | Active | SKU | Description |
|---|------|----------|-----------|-------|--------|-----|-------------|
| 1 | **iPhone 15 Pro** | `Electronics` | 999.99 | 45 | `true` | `ELEC-IP15P-128` | Flagship smartphone with titanium design and A17 Pro chip |
| 2 | **Samsung Galaxy S24 Ultra** | `Electronics` | 1199.99 | 30 | `true` | `ELEC-SGS24U-256` | Premium Android smartphone with Galaxy AI and S-Pen |
| 3 | **Apple Watch Series 9** | `Electronics` | 399.00 | 50 | `true` | `ELEC-APL-WAT9` | Smartwatch with advanced health sensors and Always-On display |
| 4 | **Apple MacBook Air M3** | `Computers` | 1099.00 | 25 | `true` | `COMP-MBA-M3-13` | 13-inch lightweight laptop with M3 chip and Liquid Retina display |
| 5 | **iPad Air 11-inch M2** | `Computers` | 599.00 | 35 | `true` | `COMP-IPAD-AIR-M2` | Powerful tablet with M2 chip and Liquid Retina display |
| 6 | **PlayStation 5 Slim** | `Gaming` | 499.99 | 20 | `true` | `GAME-SONY-PS5S` | Next-gen gaming console with 1TB SSD storage |
| 7 | **Sony WH-1000XM5** | `Audio` | 349.99 | 60 | `true` | `AUD-SONY-XM5` | Industry-leading wireless noise-canceling over-ear headphones |
| 8 | **Bose QuietComfort Ultra** | `Audio` | 429.00 | 40 | `true` | `AUD-BOSE-QCU` | Spatial audio wireless noise-cancelling earbuds |
| 9 | **Logitech MX Master 3S** | `Accessories` | 99.99 | 0 | `false` | `ACC-LOGI-MXM3S` | Ergonomic performance wireless mouse (Out of Stock) |
| 10 | **Zara Floral Summer Dress** | `Clothing` | 59.90 | 40 | `true` | `CLOTH-ZARA-DRS01` | Lightweight sleeveless floral print midi dress |
| 11 | **Levi's 501 Original Fit Jeans** | `Clothing` | 79.50 | 85 | `true` | `CLOTH-LEVI-501` | Classic straight-leg dark indigo denim jeans |
| 12 | **Nike Sportswear Club Fleece Hoodie** | `Clothing` | 65.00 | 110 | `true` | `CLOTH-NIKE-HD01` | Soft brushed-back fleece pullover hoodie in black |
| 13 | **H&M Slim Fit Cotton Shirt** | `Clothing` | 29.99 | 150 | `true` | `CLOTH-HM-SHT-WHT` | Breathable slim-fit casual white cotton shirt |
| 14 | **Nike Air Force 1 '07** | `Footwear` | 115.00 | 120 | `true` | `FOOT-NIKE-AF1` | Classic all-white leather low-top streetwear sneakers |
| 15 | **Adidas Ultraboost Light** | `Footwear` | 189.99 | 75 | `true` | `FOOT-ADI-UB-LT` | High-performance running shoes with responsive boost midsole |
| 16 | **Dyson V15 Detect Vacuum** | `Home Appliances` | 749.99 | 12 | `true` | `APPL-DYS-V15` | Cordless vacuum cleaner with laser dust detection |
