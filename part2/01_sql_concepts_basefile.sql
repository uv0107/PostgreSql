CREATE EXTENSION IF NOT EXISTS pgcrypto;

DROP TABLE IF EXISTS products;

CREATE TABLE products(
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


INSERT INTO products (name, category, price, stock, is_active, sku, description)
VALUES
--  Mobiles & Electronics
('iPhone 15 Pro', 'Electronics', 999.99, 45, true, 'ELEC-IP15P-128', 'Flagship smartphone with titanium design and A17 Pro chip'),
('Samsung Galaxy S24 Ultra', 'Electronics', 1199.99, 30, true, 'ELEC-SGS24U-256', 'Premium Android smartphone with Galaxy AI and S-Pen'),
('Apple MacBook Air M3', 'Computers', 1099.00, 25, true, 'COMP-MBA-M3-13', '13-inch lightweight laptop with M3 chip and Liquid Retina display'),

--  Audio & Gadgets
('Sony WH-1000XM5', 'Audio', 349.99, 60, true, 'AUD-SONY-XM5', 'Industry-leading wireless noise-canceling over-ear headphones'),
('Logitech MX Master 3S', 'Accessories', 99.99, 0, false, 'ACC-LOGI-MXM3S', 'Ergonomic performance wireless mouse (Out of Stock)'),

--  Clothing & Fashion
('Zara Floral Summer Dress', 'Clothing', 59.90, 40, true, 'CLOTH-ZARA-DRS01', 'Lightweight sleeveless floral print midi dress'),
('Levi''s 501 Original Fit Jeans', 'Clothing', 79.50, 85, true, 'CLOTH-LEVI-501', 'Classic straight-leg dark indigo denim jeans'),
('Nike Sportswear Club Fleece Hoodie', 'Clothing', 65.00, 110, true, 'CLOTH-NIKE-HD01', 'Soft brushed-back fleece pullover hoodie in black'),

--  Footwear
('Nike Air Force 1 ''07', 'Footwear', 115.00, 120, true, 'FOOT-NIKE-AF1', 'Classic all-white leather low-top streetwear sneakers');

SELECT * FROM products;