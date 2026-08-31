DROP TABLE IF EXISTS basics.product_basics;

CREATE TABLE basics.product_basics(

    id SERIAL PRIMARY KEY,

    -- it will allow values to store in the name column up to 100 characters
    name VARCHAR(100) NOT NULL,

    -- it will allow values to store in the description column up to 100 characters
    description TEXT,

    -- it will allow values to store in the stock column up to 10 digits
    stock INTEGER DEFAULT 0,

    -- it will allow values up to 10 digits
    total_views BIGINT DEFAULT 0,

    -- it will allow values up to 10 digits and 2 decimal places
    price DECIMAL(10,2),    

    -- it will allow values up to 10 digits and 2 decimal places
    discount DECIMAL(10,2) DEFAULT 0,

    -- it will allow values to store in the is_active column up to 1 digit
    is_active BOOLEAN DEFAULT TRUE,

    -- it will allow values to store in the created_at column up to 10 digits
    created_at TIMESTAMP DEFAULT NOW(),

    -- it will allow values to store in the updated_at column up to 10 digits
    updated_at TIMESTAMP DEFAULT NOW()
);


-- Values inserting

INSERT INTO basics.product_basics(name, description, stock, total_views, price, discount, is_active, created_at, updated_at)
VALUES
('Product 1', 'Description 1', 10, 100, 10.99, 0.99, TRUE, NOW(), NOW()),
('Product 2', 'Description 2', 20, 200, 20.99, 1.99, TRUE, NOW(), NOW()),
('Product 3', 'Description 3', 30, 300, 30.99, 2.99, FALSE, NOW(), NOW());

-- now select the data from the table

SELECT * FROM basics.product_basics;
