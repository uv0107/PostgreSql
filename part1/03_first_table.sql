-- Dont use this command on production just for the learning purpose only.

DROP TABLE IF EXISTS basics.students;

CREATE TABLE basics.students(
    -- Serial is used for auto incrementing values
    id SERIAL PRIMARY KEY,

    -- Text is used for storing text values NOT NULL means it will rejects the entry if name is missing.
    name TEXT NOT NULL,

    -- Email should be unique.
    email TEXT UNIQUE,

    -- Age should be greater than 18.
    age INTEGER CHECK(age > 18),

    -- Timestamp is used for storing date and time values.
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO basics.students(name,email,age)
VALUES
('UV','uyyalavamsi37@gmail.com',22),
('loki','lokiep420@gmail.com',22);


