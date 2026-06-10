-- Tags: no-ordinary-database, no-parallel
-- Tag no-ordinary-database: Requires Atomic database
DROP DATABASE IF EXISTS `01914_db`;

CREATE DATABASE `01914_db`
ENGINE = Atomic();

DROP TABLE IF EXISTS `01914_db`.table_1;

CREATE TABLE `01914_db`.table_1
(
    id UInt64,
    value String
)
ENGINE = TinyLog();

DROP TABLE IF EXISTS `01914_db`.table_2;

CREATE TABLE `01914_db`.table_2
(
    id UInt64,
    value String
)
ENGINE = TinyLog();

INSERT INTO `01914_db`.table_1;

INSERT INTO `01914_db`.table_2;

DROP DICTIONARY IF EXISTS `01914_db`.dictionary_1;

CREATE DICTIONARY `01914_db`.dictionary_1
(
    id UInt64,
    value String
)
PRIMARY KEY id
SOURCE(clickhouse(DB '01914_db' TABLE 'table_1'))
LAYOUT(DIRECT());

DROP DICTIONARY IF EXISTS `01914_db`.dictionary_2;

CREATE DICTIONARY `01914_db`.dictionary_2
(
    id UInt64,
    value String
)
PRIMARY KEY id
SOURCE(clickhouse(DB '01914_db' TABLE 'table_2'))
LAYOUT(DIRECT());

SELECT *
FROM `01914_db`.dictionary_1;

SELECT *
FROM `01914_db`.dictionary_2;

EXCHANGE DICTIONARY `01914_db`.dictionary_1 AND `01914_db`.dictionary_2;

DROP DICTIONARY `01914_db`.dictionary_1;

DROP DICTIONARY `01914_db`.dictionary_2;

DROP TABLE `01914_db`.table_1;

DROP TABLE `01914_db`.table_2;

DROP DATABASE `01914_db`;