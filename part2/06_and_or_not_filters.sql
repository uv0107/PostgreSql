-- AND every condition must be true
-- OR one condition must be true
-- NOT reverse the result

SELECT * FROM products
WHERE category = 'Electronics' AND price > 500;

SELECT * FROM products
WHERE category = 'Electronics' OR price > 500;

SELECT * FROM products
WHERE NOT category = 'Electronics';

-- parenthesis

SELECT name,category,stock FROM products
WHERE (category = 'Electronics' AND stock < 50) OR price > 1000;
