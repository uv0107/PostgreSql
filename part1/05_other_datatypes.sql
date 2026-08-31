DROP TABLE IF EXISTS basics.app_events;

CREATE TABLE basics.app_events (
    -- it will generate a random uuid for the id column
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- it will store the type of the event as a string up to 50 characters
    event_type TEXT NOT NULL,

    -- it will store the metadata of the event as a jsonb
    metadata JSONB DEFAULT '{}'::jsonb,

    -- it will store the created_at timestamp up to 10 digits
    created_at TIMESTAMP DEFAULT NOW(),

    -- it will store the updated_at timestamp up to 10 digits
    updated_at TIMESTAMP DEFAULT NOW()
);

-- it will insert some values into the table
INSERT INTO basics.app_events(event_type, metadata, created_at, updated_at)
VALUES
('event1', '{"key1": "value1", "key2": "value2", "key3": "value3"}', NOW(), NOW()),
('event2', '{"key1": "value1", "key2": "value2", "key3": "value3"}', NOW(), NOW()),
('event3', '{"key1": "value1", "key2": "value2", "key3": "value3"}', NOW(), NOW());


SELECT event_type,
        metadata->>'key1' AS key1
        -- metadata->>'key2' AS key2,
        -- metadata->>'key3' AS key3
FROM basics.app_events
WHERE metadata ? 'key1';
-- output
--  event_type |  key1  
------------+--------
--  event1     | value1
--  event2     | value1
--  event3     | value1

-- atul@arvinds-MacBook-Pro PostgreSQL_full_course % psql -U postgres -d postgresql_part1 -f part1/05_other_datatypes.sql
-- DROP TABLE
-- CREATE TABLE
-- INSERT 0 3
--  event_type |  key1  |  key2  |  key3  
-- ------------+--------+--------+--------
--  event1     | value1 | value2 | value3
--  event2     | value1 | value2 | value3
--  event3     | value1 | value2 | value3
-- (3 rows)

    