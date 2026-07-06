-- Tags: no-parallel
DROP DATABASE IF EXISTS `01778_db`;

CREATE DATABASE `01778_db`;

CREATE TABLE `01778_db`.hierarchy_source_table
(
    id UInt64,
    parent_id UInt64
)
ENGINE = TinyLog();

INSERT INTO `01778_db`.hierarchy_source_table;

CREATE DICTIONARY `01778_db`.hierarchy_flat_dictionary
(
    id UInt64,
    parent_id UInt64 HIERARCHICAL
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'hierarchy_source_table' DB '01778_db'))
LIFETIME(MIN 1 MAX 1000)
LAYOUT(FLAT());

SELECT dictGetHierarchy('01778_db.hierarchy_flat_dictionary', number)
FROM `system`.numbers
LIMIT 6;

SELECT dictIsIn('01778_db.hierarchy_flat_dictionary', number, number)
FROM `system`.numbers
LIMIT 6;

SELECT dictGetChildren('01778_db.hierarchy_flat_dictionary', number)
FROM `system`.numbers
LIMIT 6;

SELECT dictGetDescendants('01778_db.hierarchy_flat_dictionary', number)
FROM `system`.numbers
LIMIT 6;

SELECT dictGetDescendants('01778_db.hierarchy_flat_dictionary', number, 1)
FROM `system`.numbers
LIMIT 6;

DROP DICTIONARY `01778_db`.hierarchy_flat_dictionary;

CREATE DICTIONARY `01778_db`.hierarchy_hashed_dictionary
(
    id UInt64,
    parent_id UInt64 HIERARCHICAL
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'hierarchy_source_table' DB '01778_db'))
LIFETIME(MIN 1 MAX 1000)
LAYOUT(HASHED());

SELECT dictGetHierarchy('01778_db.hierarchy_hashed_dictionary', number)
FROM `system`.numbers
LIMIT 6;

SELECT dictIsIn('01778_db.hierarchy_hashed_dictionary', number, number)
FROM `system`.numbers
LIMIT 6;

SELECT dictGetChildren('01778_db.hierarchy_hashed_dictionary', number)
FROM `system`.numbers
LIMIT 6;

SELECT dictGetDescendants('01778_db.hierarchy_hashed_dictionary', number)
FROM `system`.numbers
LIMIT 6;

SELECT dictGetDescendants('01778_db.hierarchy_hashed_dictionary', number, 1)
FROM `system`.numbers
LIMIT 6;

DROP DICTIONARY `01778_db`.hierarchy_hashed_dictionary;

CREATE DICTIONARY `01778_db`.hierarchy_cache_dictionary
(
    id UInt64,
    parent_id UInt64 HIERARCHICAL
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'hierarchy_source_table' DB '01778_db'))
LIFETIME(MIN 1 MAX 1000)
LAYOUT(CACHE(SIZE_IN_CELLS 10));

SELECT dictGetHierarchy('01778_db.hierarchy_cache_dictionary', number)
FROM `system`.numbers
LIMIT 6;

SELECT dictIsIn('01778_db.hierarchy_cache_dictionary', number, number)
FROM `system`.numbers
LIMIT 6;

DROP DICTIONARY `01778_db`.hierarchy_cache_dictionary;

CREATE DICTIONARY `01778_db`.hierarchy_direct_dictionary
(
    id UInt64,
    parent_id UInt64 HIERARCHICAL
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'hierarchy_source_table' DB '01778_db'))
LAYOUT(DIRECT());

SELECT dictGetHierarchy('01778_db.hierarchy_direct_dictionary', number)
FROM `system`.numbers
LIMIT 6;

SELECT dictIsIn('01778_db.hierarchy_direct_dictionary', number, number)
FROM `system`.numbers
LIMIT 6;

DROP DICTIONARY `01778_db`.hierarchy_direct_dictionary;

DROP TABLE `01778_db`.hierarchy_source_table;

DROP DATABASE `01778_db`;