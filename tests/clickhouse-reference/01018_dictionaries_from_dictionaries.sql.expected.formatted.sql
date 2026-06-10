-- Tags: no-parallel
SET send_logs_level = 'fatal';

DROP DATABASE IF EXISTS database_for_dict;

CREATE DATABASE database_for_dict;

CREATE TABLE database_for_dict.table_for_dict
(
    key_column UInt64,
    second_column UInt8,
    third_column String,
    fourth_column Float64
)
ENGINE = MergeTree()
ORDER BY key_column;

INSERT INTO database_for_dict.table_for_dict SELECT
    number,
    number % 17,
    toString(number * number),
    number / 2.
FROM numbers(100);

CREATE DICTIONARY database_for_dict.dict1
(
    key_column UInt64 DEFAULT 0,
    second_column UInt8 DEFAULT 1,
    third_column String DEFAULT 'qqq',
    fourth_column Float64 DEFAULT 42.
)
PRIMARY KEY key_column
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'table_for_dict' DB 'database_for_dict'))
LIFETIME(MIN 1 MAX 10)
LAYOUT(FLAT());

SELECT count(*)
FROM database_for_dict.dict1;

CREATE DICTIONARY database_for_dict.dict2
(
    key_column UInt64 DEFAULT 0,
    second_column UInt8 DEFAULT 1,
    third_column String DEFAULT 'qqq',
    fourth_column Float64 DEFAULT 42.
)
PRIMARY KEY key_column
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'dict1' DB 'database_for_dict'))
LIFETIME(MIN 1 MAX 10)
LAYOUT(HASHED());

SELECT count(*)
FROM database_for_dict.dict2;

INSERT INTO database_for_dict.table_for_dict SELECT
    number,
    number % 17,
    toString(number * number),
    number / 2.
FROM numbers(100, 100);

SYSTEM RELOAD DICTIONARIES;

CREATE DICTIONARY database_for_dict.dict3
(
    key_column UInt64 DEFAULT 0,
    second_column UInt8 DEFAULT 1,
    third_column String DEFAULT 'qqq',
    fourth_column Float64 DEFAULT 42.
)
PRIMARY KEY key_column
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'dict2' DB 'database_for_dict'))
LIFETIME(MIN 1 MAX 10)
LAYOUT(HASHED());

SELECT count(*)
FROM database_for_dict.dict3;

INSERT INTO database_for_dict.table_for_dict SELECT
    number,
    number % 17,
    toString(number * number),
    number / 2.
FROM numbers(200, 100);

CREATE DICTIONARY database_for_dict.dict4
(
    key_column UInt64 DEFAULT 0,
    second_column UInt8 DEFAULT 1,
    third_column String DEFAULT 'qqq',
    fourth_column Float64 DEFAULT 42.
)
PRIMARY KEY key_column
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'non_existing_table' DB 'database_for_dict'))
LIFETIME(MIN 1 MAX 10)
LAYOUT(HASHED());

SELECT count(*)
FROM database_for_dict.dict4; -- {serverError UNKNOWN_TABLE}

SELECT name
FROM `system`.tables
WHERE database = 'database_for_dict'
ORDER BY name ASC;

SELECT name
FROM `system`.dictionaries
WHERE database = 'database_for_dict'
ORDER BY name ASC;