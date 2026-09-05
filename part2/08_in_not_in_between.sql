-- IN operator -- : Matches any value in the list 

-- NOT IN operator : Matches any value NOT in the list 

-- BETWEEN operator : Matches values within a range (inclusive)


-- SELECT name,price,category
-- FROM products
-- Where category IN ('Electronics','Computers');

-- SELECT name,price,category
-- FROM products
-- WHERE category NOT IN ('Electronics','Computers');

-- SELECT name,price
-- FROM products
-- WHERE price BETWEEN 100 AND 500;

-- SELECT name,price
-- FROM products
-- WHERE price NOT BETWEEN 100 AND 500;

SELECT name,price,category
FROM products
WHERE category IN ('Electronics') 
AND price BETWEEN 100 AND 500;
