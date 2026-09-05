SELECT name,price,category
FROM products
WHERE category IS NOT NULL;


SELECT name,price,category
FROM products
WHERE category IS NULL;