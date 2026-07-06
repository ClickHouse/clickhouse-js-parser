-- Tags: no-parallel
DROP DATABASE IF EXISTS `01720_dictionary_db`;

CREATE DATABASE `01720_dictionary_db`;

CREATE TABLE `01720_dictionary_db`.dictionary_source_table
(
    key UInt8,
    value String
)
ENGINE = TinyLog();

INSERT INTO `01720_dictionary_db`.dictionary_source_table;

CREATE DICTIONARY `01720_dictionary_db`.dictionary
(
    key UInt64,
    value String
)
PRIMARY KEY key
SOURCE(clickhouse(DB '01720_dictionary_db' TABLE 'dictionary_source_table' HOST hostName() PORT tcpPort()))
LIFETIME(MIN 0 MAX 0)
LAYOUT(FLAT());

SELECT *
FROM `01720_dictionary_db`.dictionary;

DROP DICTIONARY `01720_dictionary_db`.dictionary;

DROP TABLE `01720_dictionary_db`.dictionary_source_table;

DROP DATABASE `01720_dictionary_db`;