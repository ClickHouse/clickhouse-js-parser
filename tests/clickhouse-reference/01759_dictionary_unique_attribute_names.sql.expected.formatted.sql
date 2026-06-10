-- Tags: no-parallel
DROP DATABASE IF EXISTS `01759_db`;

CREATE DATABASE `01759_db`;

CREATE TABLE `01759_db`.dictionary_source_table
(
    key UInt64,
    value1 UInt64,
    value2 UInt64
)
ENGINE = TinyLog();

INSERT INTO `01759_db`.dictionary_source_table;

CREATE DICTIONARY `01759_db`.test_dictionary
(
    key UInt64,
    value1 UInt64,
    value1 UInt64
)
PRIMARY KEY key
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'dictionary_source_table' DB '01759_db'))
LAYOUT(COMPLEX_KEY_DIRECT()); -- {serverError BAD_ARGUMENTS}

CREATE DICTIONARY `01759_db`.test_dictionary
(
    key UInt64,
    value1 UInt64,
    value2 UInt64
)
PRIMARY KEY key
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'dictionary_source_table' DB '01759_db'))
LAYOUT(COMPLEX_KEY_DIRECT());

SELECT
    number,
    dictGet('01759_db.test_dictionary', 'value1', tuple(number)) AS value1,
    dictGet('01759_db.test_dictionary', 'value2', tuple(number)) AS value2
FROM `system`.numbers
LIMIT 3;

DROP DATABASE `01759_db`;