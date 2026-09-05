-- SELECT name,price 
-- FROM products
-- WHERE name LIKE 'iPhon%';

-- SELECT name,price
-- FROM products
-- WHERE name ILIKE '%summer%';

-- SELECT name,price
-- FROM products
-- WHERE name NOT LIKE 'iPhon%';

SELECT name,price 
FROM products
WHERE name LIKE '%wear%'
OR description ILIKE '%A17%';


