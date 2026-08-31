-- Insert multiple products in a single statement
INSERT INTO products (name, category, price, stock, is_active, sku, description)
VALUES
--  Smartwatch & Gaming
('Apple Watch Series 9', 'Electronics', 399.00, 50, true, 'ELEC-APL-WAT9', 'Smartwatch with advanced health sensors and Always-On display'),
('PlayStation 5 Slim', 'Gaming', 499.99, 20, true, 'GAME-SONY-PS5S', 'Next-gen gaming console with 1TB SSD storage'),

--  Footwear & Apparel
('Adidas Ultraboost Light', 'Footwear', 189.99, 75, true, 'FOOT-ADI-UB-LT', 'High-performance running shoes with responsive boost midsole'),
('H&M Slim Fit Cotton Shirt', 'Clothing', 29.99, 150, true, 'CLOTH-HM-SHT-WHT', 'Breathable slim-fit casual white cotton shirt'),

--  Tablets & Audio
('iPad Air 11-inch M2', 'Computers', 599.00, 35, true, 'COMP-IPAD-AIR-M2', 'Powerful tablet with M2 chip and Liquid Retina display'),
('Bose QuietComfort Ultra', 'Audio', 429.00, 40, true, 'AUD-BOSE-QCU', 'Spatial audio wireless noise-cancelling earbuds'),

--  Home Appliances
('Dyson V15 Detect Vacuum', 'Home Appliances', 749.99, 12, true, 'APPL-DYS-V15', 'Cordless vacuum cleaner with laser dust detection');

-- View all inserted rows
SELECT id,name 
FROM products
WHERE sku IN ('ELEC-IP15P-128','ELEC-SGS24U-256','COMP-MBA-M3-13') ORDER BY created_at;


