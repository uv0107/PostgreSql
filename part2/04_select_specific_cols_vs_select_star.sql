-- 1. SELECT * (Retrieves ALL columns from the table)
-- Retrieves: id, name, category, price, stock, is_active, sku, description, created_at
SELECT * FROM products;


-- 2. SELECT Specific Columns (Retrieves ONLY the required columns)
-- Retrieves only the name, price, and stock for a catalog view
SELECT name, price, stock 
FROM products;


-- 3. SELECT with Column Aliases (AS)
SELECT 
    name AS product_title, 
    price AS retail_price, 
    stock AS units_available        
FROM products;


-- 4. SELECT with Computed / Expression Columns
SELECT 
    name, 
    price, 
    stock, 
    (price * stock) AS total_inventory_value
FROM products;
