-- Tags: no-parallel
DROP DATABASE IF EXISTS `01765_db`;

CREATE DATABASE `01765_db`;

CREATE TABLE `01765_db`.simple_key_simple_attributes_source_table
(
    id UInt64,
    value_first String,
    value_second String
)
ENGINE = TinyLog();

INSERT INTO `01765_db`.simple_key_simple_attributes_source_table;

INSERT INTO `01765_db`.simple_key_simple_attributes_source_table;

INSERT INTO `01765_db`.simple_key_simple_attributes_source_table;

CREATE DICTIONARY `01765_db`.hashed_dictionary_simple_key_simple_attributes
(
    id UInt64,
    value_first String DEFAULT 'value_first_default',
    value_second String DEFAULT 'value_second_default'
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'simple_key_simple_attributes_source_table'))
LIFETIME(MIN 1 MAX 1000)
LAYOUT(HASHED())
SETTINGS(dictionary_use_async_executor = '1', max_threads = '8');

SELECT
    dictGet('01765_db.hashed_dictionary_simple_key_simple_attributes', 'value_first', number) AS value_first,
    dictGet('01765_db.hashed_dictionary_simple_key_simple_attributes', 'value_second', number) AS value_second
FROM `system`.numbers
LIMIT 3;

SELECT
    dictGet('01765_db.hashed_dictionary_simple_key_simple_attributes', 'value_first', number) AS value_first,
    dictGet('01765_db.hashed_dictionary_simple_key_simple_attributes', 'value_second', number) AS value_second
FROM `system`.numbers
LIMIT 4;

SELECT
    dictGetOrDefault('01765_db.hashed_dictionary_simple_key_simple_attributes', 'value_first', number, toString('default')) AS value_first,
    dictGetOrDefault('01765_db.hashed_dictionary_simple_key_simple_attributes', 'value_second', number, toString('default')) AS value_second
FROM `system`.numbers
LIMIT 3;

SELECT
    dictGetOrDefault('01765_db.hashed_dictionary_simple_key_simple_attributes', 'value_first', number, toString('default')) AS value_first,
    dictGetOrDefault('01765_db.hashed_dictionary_simple_key_simple_attributes', 'value_second', number, toString('default')) AS value_second
FROM `system`.numbers
LIMIT 4;

SELECT dictHas('01765_db.hashed_dictionary_simple_key_simple_attributes', number)
FROM `system`.numbers
LIMIT 4;

SELECT *
FROM `01765_db`.hashed_dictionary_simple_key_simple_attributes
ORDER BY id ASC;

DROP DICTIONARY `01765_db`.hashed_dictionary_simple_key_simple_attributes;

CREATE DICTIONARY `01765_db`.sparse_hashed_dictionary_simple_key_simple_attributes
(
    id UInt64,
    value_first String DEFAULT 'value_first_default',
    value_second String DEFAULT 'value_second_default'
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'simple_key_simple_attributes_source_table'))
LIFETIME(MIN 1 MAX 1000)
LAYOUT(SPARSE_HASHED());

SELECT
    dictGet('01765_db.sparse_hashed_dictionary_simple_key_simple_attributes', 'value_first', number) AS value_first,
    dictGet('01765_db.sparse_hashed_dictionary_simple_key_simple_attributes', 'value_second', number) AS value_second
FROM `system`.numbers
LIMIT 3;

SELECT
    dictGet('01765_db.sparse_hashed_dictionary_simple_key_simple_attributes', 'value_first', number) AS value_first,
    dictGet('01765_db.sparse_hashed_dictionary_simple_key_simple_attributes', 'value_second', number) AS value_second
FROM `system`.numbers
LIMIT 4;

SELECT
    dictGetOrDefault('01765_db.sparse_hashed_dictionary_simple_key_simple_attributes', 'value_first', number, toString('default')) AS value_first,
    dictGetOrDefault('01765_db.sparse_hashed_dictionary_simple_key_simple_attributes', 'value_second', number, toString('default')) AS value_second
FROM `system`.numbers
LIMIT 3;

SELECT
    dictGetOrDefault('01765_db.sparse_hashed_dictionary_simple_key_simple_attributes', 'value_first', number, toString('default')) AS value_first,
    dictGetOrDefault('01765_db.sparse_hashed_dictionary_simple_key_simple_attributes', 'value_second', number, toString('default')) AS value_second
FROM `system`.numbers
LIMIT 4;

SELECT dictHas('01765_db.sparse_hashed_dictionary_simple_key_simple_attributes', number)
FROM `system`.numbers
LIMIT 4;

SELECT *
FROM `01765_db`.sparse_hashed_dictionary_simple_key_simple_attributes
ORDER BY id ASC;

DROP DICTIONARY `01765_db`.sparse_hashed_dictionary_simple_key_simple_attributes;

DROP TABLE `01765_db`.simple_key_simple_attributes_source_table;

CREATE TABLE `01765_db`.simple_key_complex_attributes_source_table
(
    id UInt64,
    value_first String,
    value_second Nullable(String)
)
ENGINE = TinyLog();

INSERT INTO `01765_db`.simple_key_complex_attributes_source_table;

INSERT INTO `01765_db`.simple_key_complex_attributes_source_table;

INSERT INTO `01765_db`.simple_key_complex_attributes_source_table;

CREATE DICTIONARY `01765_db`.hashed_dictionary_simple_key_complex_attributes
(
    id UInt64,
    value_first String DEFAULT 'value_first_default',
    value_second Nullable(String) DEFAULT 'value_second_default'
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'simple_key_complex_attributes_source_table'))
LIFETIME(MIN 1 MAX 1000)
LAYOUT(HASHED());

SELECT
    dictGet('01765_db.hashed_dictionary_simple_key_complex_attributes', 'value_first', number) AS value_first,
    dictGet('01765_db.hashed_dictionary_simple_key_complex_attributes', 'value_second', number) AS value_second
FROM `system`.numbers
LIMIT 3;

SELECT
    dictGet('01765_db.hashed_dictionary_simple_key_complex_attributes', 'value_first', number) AS value_first,
    dictGet('01765_db.hashed_dictionary_simple_key_complex_attributes', 'value_second', number) AS value_second
FROM `system`.numbers
LIMIT 4;

SELECT
    dictGetOrDefault('01765_db.hashed_dictionary_simple_key_complex_attributes', 'value_first', number, toString('default')) AS value_first,
    dictGetOrDefault('01765_db.hashed_dictionary_simple_key_complex_attributes', 'value_second', number, toString('default')) AS value_second
FROM `system`.numbers
LIMIT 3;

SELECT
    dictGetOrDefault('01765_db.hashed_dictionary_simple_key_complex_attributes', 'value_first', number, toString('default')) AS value_first,
    dictGetOrDefault('01765_db.hashed_dictionary_simple_key_complex_attributes', 'value_second', number, toString('default')) AS value_second
FROM `system`.numbers
LIMIT 4;

SELECT dictHas('01765_db.hashed_dictionary_simple_key_complex_attributes', number)
FROM `system`.numbers
LIMIT 4;

SELECT *
FROM `01765_db`.hashed_dictionary_simple_key_complex_attributes
ORDER BY id ASC;

DROP DICTIONARY `01765_db`.hashed_dictionary_simple_key_complex_attributes;

CREATE DICTIONARY `01765_db`.sparse_hashed_dictionary_simple_key_complex_attributes
(
    id UInt64,
    value_first String DEFAULT 'value_first_default',
    value_second Nullable(String) DEFAULT 'value_second_default'
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'simple_key_complex_attributes_source_table'))
LIFETIME(MIN 1 MAX 1000)
LAYOUT(HASHED());

SELECT
    dictGet('01765_db.sparse_hashed_dictionary_simple_key_complex_attributes', 'value_first', number) AS value_first,
    dictGet('01765_db.sparse_hashed_dictionary_simple_key_complex_attributes', 'value_second', number) AS value_second
FROM `system`.numbers
LIMIT 3;

SELECT
    dictGet('01765_db.sparse_hashed_dictionary_simple_key_complex_attributes', 'value_first', number) AS value_first,
    dictGet('01765_db.sparse_hashed_dictionary_simple_key_complex_attributes', 'value_second', number) AS value_second
FROM `system`.numbers
LIMIT 4;

SELECT
    dictGetOrDefault('01765_db.sparse_hashed_dictionary_simple_key_complex_attributes', 'value_first', number, toString('default')) AS value_first,
    dictGetOrDefault('01765_db.sparse_hashed_dictionary_simple_key_complex_attributes', 'value_second', number, toString('default')) AS value_second
FROM `system`.numbers
LIMIT 3;

SELECT
    dictGetOrDefault('01765_db.sparse_hashed_dictionary_simple_key_complex_attributes', 'value_first', number, toString('default')) AS value_first,
    dictGetOrDefault('01765_db.sparse_hashed_dictionary_simple_key_complex_attributes', 'value_second', number, toString('default')) AS value_second
FROM `system`.numbers
LIMIT 4;

SELECT dictHas('01765_db.sparse_hashed_dictionary_simple_key_complex_attributes', number)
FROM `system`.numbers
LIMIT 4;

SELECT *
FROM `01765_db`.sparse_hashed_dictionary_simple_key_complex_attributes
ORDER BY id ASC;

DROP DICTIONARY `01765_db`.sparse_hashed_dictionary_simple_key_complex_attributes;

DROP TABLE `01765_db`.simple_key_complex_attributes_source_table;

CREATE TABLE `01765_db`.simple_key_hierarchy_table
(
    id UInt64,
    parent_id UInt64
)
ENGINE = TinyLog();

INSERT INTO `01765_db`.simple_key_hierarchy_table;

INSERT INTO `01765_db`.simple_key_hierarchy_table;

INSERT INTO `01765_db`.simple_key_hierarchy_table;

INSERT INTO `01765_db`.simple_key_hierarchy_table;

CREATE DICTIONARY `01765_db`.hashed_dictionary_simple_key_hierarchy
(
    id UInt64,
    parent_id UInt64 HIERARCHICAL
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'simple_key_hierarchy_table'))
LIFETIME(MIN 1 MAX 1000)
LAYOUT(HASHED());

SELECT dictGet('01765_db.hashed_dictionary_simple_key_hierarchy', 'parent_id', number)
FROM `system`.numbers
LIMIT 5;

SELECT dictGetHierarchy('01765_db.hashed_dictionary_simple_key_hierarchy', toUInt64(1));

SELECT dictGetHierarchy('01765_db.hashed_dictionary_simple_key_hierarchy', toUInt64(4));

DROP DICTIONARY `01765_db`.hashed_dictionary_simple_key_hierarchy;

CREATE DICTIONARY `01765_db`.sparse_hashed_dictionary_simple_key_hierarchy
(
    id UInt64,
    parent_id UInt64 HIERARCHICAL
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'simple_key_hierarchy_table'))
LIFETIME(MIN 1 MAX 1000)
LAYOUT(HASHED());

SELECT dictGet('01765_db.sparse_hashed_dictionary_simple_key_hierarchy', 'parent_id', number)
FROM `system`.numbers
LIMIT 5;

SELECT dictGetHierarchy('01765_db.sparse_hashed_dictionary_simple_key_hierarchy', toUInt64(1));

SELECT dictGetHierarchy('01765_db.sparse_hashed_dictionary_simple_key_hierarchy', toUInt64(4));

DROP DICTIONARY `01765_db`.sparse_hashed_dictionary_simple_key_hierarchy;

DROP TABLE `01765_db`.simple_key_hierarchy_table;

DROP DATABASE `01765_db`;