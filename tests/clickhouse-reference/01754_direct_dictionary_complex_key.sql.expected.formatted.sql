-- Tags: no-parallel
DROP DATABASE IF EXISTS `01754_dictionary_db`;

CREATE DATABASE `01754_dictionary_db`;

CREATE TABLE `01754_dictionary_db`.complex_key_simple_attributes_source_table
(
    id UInt64,
    id_key String,
    value_first String,
    value_second String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO `01754_dictionary_db`.complex_key_simple_attributes_source_table;

INSERT INTO `01754_dictionary_db`.complex_key_simple_attributes_source_table;

INSERT INTO `01754_dictionary_db`.complex_key_simple_attributes_source_table;

CREATE DICTIONARY `01754_dictionary_db`.direct_dictionary_complex_key_simple_attributes
(
    id UInt64,
    id_key String DEFAULT 'test_default_id_key',
    value_first String DEFAULT 'value_first_default',
    value_second String DEFAULT 'value_second_default'
)
PRIMARY KEY id, id_key
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'complex_key_simple_attributes_source_table'))
LAYOUT(COMPLEX_KEY_DIRECT());

SELECT
    dictGet('01754_dictionary_db.direct_dictionary_complex_key_simple_attributes', 'value_first', (number, concat('id_key_', toString(number)))) AS value_first,
    dictGet('01754_dictionary_db.direct_dictionary_complex_key_simple_attributes', 'value_second', (number, concat('id_key_', toString(number)))) AS value_second
FROM `system`.numbers
LIMIT 3;

SELECT
    dictGet('01754_dictionary_db.direct_dictionary_complex_key_simple_attributes', 'value_first', (number, concat('id_key_', toString(number)))) AS value_first,
    dictGet('01754_dictionary_db.direct_dictionary_complex_key_simple_attributes', 'value_second', (number, concat('id_key_', toString(number)))) AS value_second
FROM `system`.numbers
LIMIT 4;

SELECT
    dictGetOrDefault('01754_dictionary_db.direct_dictionary_complex_key_simple_attributes', 'value_first', (number, concat('id_key_', toString(number))), toString('default')) AS value_first,
    dictGetOrDefault('01754_dictionary_db.direct_dictionary_complex_key_simple_attributes', 'value_second', (number, concat('id_key_', toString(number))), toString('default')) AS value_second
FROM `system`.numbers
LIMIT 3;

SELECT
    dictGetOrDefault('01754_dictionary_db.direct_dictionary_complex_key_simple_attributes', 'value_first', (number, concat('id_key_', toString(number))), toString('default')) AS value_first,
    dictGetOrDefault('01754_dictionary_db.direct_dictionary_complex_key_simple_attributes', 'value_second', (number, concat('id_key_', toString(number))), toString('default')) AS value_second
FROM `system`.numbers
LIMIT 4;

SELECT dictHas('01754_dictionary_db.direct_dictionary_complex_key_simple_attributes', (number, concat('id_key_', toString(number))))
FROM `system`.numbers
LIMIT 4;

SELECT *
FROM `01754_dictionary_db`.direct_dictionary_complex_key_simple_attributes
ORDER BY `ALL` ASC;

DROP DICTIONARY `01754_dictionary_db`.direct_dictionary_complex_key_simple_attributes;

DROP TABLE `01754_dictionary_db`.complex_key_simple_attributes_source_table;

CREATE TABLE `01754_dictionary_db`.complex_key_complex_attributes_source_table
(
    id UInt64,
    id_key String,
    value_first String,
    value_second Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO `01754_dictionary_db`.complex_key_complex_attributes_source_table;

INSERT INTO `01754_dictionary_db`.complex_key_complex_attributes_source_table;

INSERT INTO `01754_dictionary_db`.complex_key_complex_attributes_source_table;

CREATE DICTIONARY `01754_dictionary_db`.direct_dictionary_complex_key_complex_attributes
(
    id UInt64,
    id_key String,
    value_first String DEFAULT 'value_first_default',
    value_second Nullable(String) DEFAULT 'value_second_default'
)
PRIMARY KEY id, id_key
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'complex_key_complex_attributes_source_table'))
LAYOUT(COMPLEX_KEY_DIRECT());

SELECT
    dictGet('01754_dictionary_db.direct_dictionary_complex_key_complex_attributes', 'value_first', (number, concat('id_key_', toString(number)))) AS value_first,
    dictGet('01754_dictionary_db.direct_dictionary_complex_key_complex_attributes', 'value_second', (number, concat('id_key_', toString(number)))) AS value_second
FROM `system`.numbers
LIMIT 3;

SELECT
    dictGet('01754_dictionary_db.direct_dictionary_complex_key_complex_attributes', 'value_first', (number, concat('id_key_', toString(number)))) AS value_first,
    dictGet('01754_dictionary_db.direct_dictionary_complex_key_complex_attributes', 'value_second', (number, concat('id_key_', toString(number)))) AS value_second
FROM `system`.numbers
LIMIT 4;

SELECT
    dictGetOrDefault('01754_dictionary_db.direct_dictionary_complex_key_complex_attributes', 'value_first', (number, concat('id_key_', toString(number))), toString('default')) AS value_first,
    dictGetOrDefault('01754_dictionary_db.direct_dictionary_complex_key_complex_attributes', 'value_second', (number, concat('id_key_', toString(number))), toString('default')) AS value_second
FROM `system`.numbers
LIMIT 3;

SELECT
    dictGetOrDefault('01754_dictionary_db.direct_dictionary_complex_key_complex_attributes', 'value_first', (number, concat('id_key_', toString(number))), toString('default')) AS value_first,
    dictGetOrDefault('01754_dictionary_db.direct_dictionary_complex_key_complex_attributes', 'value_second', (number, concat('id_key_', toString(number))), toString('default')) AS value_second
FROM `system`.numbers
LIMIT 4;

SELECT dictHas('01754_dictionary_db.direct_dictionary_complex_key_complex_attributes', (number, concat('id_key_', toString(number))))
FROM `system`.numbers
LIMIT 4;

SELECT *
FROM `01754_dictionary_db`.direct_dictionary_complex_key_complex_attributes
ORDER BY `ALL` ASC;

DROP DICTIONARY `01754_dictionary_db`.direct_dictionary_complex_key_complex_attributes;

DROP TABLE `01754_dictionary_db`.complex_key_complex_attributes_source_table;

DROP DATABASE `01754_dictionary_db`;