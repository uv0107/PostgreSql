-- here is the query to drop the existing database but never use this in the production
DROP DATABASE IF EXISTS postgresql_part1;

CREATE DATABASE postgresql_part1;

-- ================================================================
-- Verification & Inspection Queries
-- (Run these after connecting to the new DB: \c postgresql_part1)
-- ================================================================

-- 1. Check which database you are currently connected to
SELECT current_database();

-- 2. Check which user role you are currently logged in as
SELECT current_user;

-- 3. Check the exact PostgreSQL version and server build
SELECT version();