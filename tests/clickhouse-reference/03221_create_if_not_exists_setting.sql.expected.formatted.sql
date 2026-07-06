-- Tags: no-parallel
SET create_if_not_exists = '0'; -- Default

DROP TABLE IF EXISTS example_table;

CREATE TABLE example_table
(
    id UInt32
)
ENGINE = MergeTree()
ORDER BY id;

DROP DATABASE IF EXISTS example_database;

CREATE DATABASE example_database;

SET create_if_not_exists = '1';