-- Tags: no-fasttest
SET send_logs_level = 'fatal';

SET check_table_dependencies = '0';

CREATE TABLE CLICKHOUSE_DATABASE.table_for_dict
(
    key_column UInt64,
    second_column UInt8,
    third_column String,
    fourth_column Float64
)
ENGINE = MergeTree()
ORDER BY key_column;

INSERT INTO CLICKHOUSE_DATABASE.table_for_dict SELECT
    number,
    number % 17,
    toString(number * number),
    number / 2.
FROM numbers(100);

CREATE DICTIONARY CLICKHOUSE_DATABASE.dict1
(
    key_column UInt64 DEFAULT 0,
    second_column UInt8 DEFAULT 1,
    third_column String DEFAULT 'qqq',
    fourth_column Float64 DEFAULT 42.
)
PRIMARY KEY key_column
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'table_for_dict' PASSWORD '' DB currentDatabase()))
LIFETIME(MIN 1 MAX 10)
LAYOUT(FLAT());

SELECT dictGetUInt8('placeholder' || '.dict1', 'second_column', toUInt64(11));

SELECT second_column
FROM CLICKHOUSE_DATABASE.dict1
WHERE key_column = 11;

SELECT dictGetString('placeholder' || '.dict1', 'third_column', toUInt64(12));

SELECT third_column
FROM CLICKHOUSE_DATABASE.dict1
WHERE key_column = 12;

SELECT dictGetFloat64('placeholder' || '.dict1', 'fourth_column', toUInt64(14));

SELECT fourth_column
FROM CLICKHOUSE_DATABASE.dict1
WHERE key_column = 14;

SELECT countDistinct(dictGetUInt8('placeholder' || '.dict1', 'second_column', toUInt64(number)))
FROM numbers(100);

DETACH DICTIONARY CLICKHOUSE_DATABASE.dict1;

ATTACH DICTIONARY CLICKHOUSE_DATABASE.dict1;

DROP DICTIONARY CLICKHOUSE_DATABASE.dict1;

-- SOURCE(CLICKHOUSE(...)) uses default params if not specified
DROP DICTIONARY IF EXISTS CLICKHOUSE_DATABASE.dict1;

CREATE DICTIONARY CLICKHOUSE_DATABASE.dict1
(
    key_column UInt64 DEFAULT 0,
    second_column UInt8 DEFAULT 1,
    third_column String DEFAULT 'qqq',
    fourth_column Float64 DEFAULT 42.
)
PRIMARY KEY key_column
SOURCE(clickhouse(TABLE 'table_for_dict' DB currentDatabase()))
LIFETIME(MIN 1 MAX 10)
LAYOUT(FLAT());

CREATE DICTIONARY CLICKHOUSE_DATABASE.dict1
(
    key_column UInt64 DEFAULT 0,
    second_column UInt8 DEFAULT 1,
    third_column String DEFAULT 'qqq',
    fourth_column Float64 DEFAULT 42.
)
PRIMARY KEY key_column, third_column
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'table_for_dict' DB currentDatabase()))
LIFETIME(MIN 1 MAX 10)
LAYOUT(COMPLEX_KEY_CACHE(SIZE_IN_CELLS 1));

SELECT dictGetUInt8('placeholder' || '.dict1', 'second_column', tuple(toUInt64(11), '121'));

SELECT dictGetFloat64('placeholder' || '.dict1', 'fourth_column', tuple(toUInt64(14), '196'));

CREATE DICTIONARY CLICKHOUSE_DATABASE.dict2
(
    key_column UInt64 DEFAULT 0,
    some_column String EXPRESSION toString(fourth_column),
    fourth_column Float64 DEFAULT 42.
)
PRIMARY KEY key_column
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'table_for_dict' DB currentDatabase()))
LIFETIME(MIN 1 MAX 10)
LAYOUT(HASHED());

SELECT dictGetString('placeholder' || '.dict2', 'some_column', toUInt64(12));

-- NOTE: database = currentDatabase() is not mandatory
SELECT
    name,
    engine
FROM `system`.tables
WHERE database = 'placeholder'
ORDER BY name ASC;

SELECT
    database,
    name,
    type
FROM `system`.dictionaries
WHERE database = 'placeholder'
ORDER BY name ASC;

-- check dictionary will not update
CREATE DICTIONARY CLICKHOUSE_DATABASE.dict3
(
    key_column UInt64 DEFAULT 0,
    some_column String EXPRESSION toString(fourth_column),
    fourth_column Float64 DEFAULT 42.
)
PRIMARY KEY key_column
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'table_for_dict' DB currentDatabase()))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SELECT dictGetString('placeholder' || '.dict3', 'some_column', toUInt64(12));

-- dictGet with table name
USE CLICKHOUSE_DATABASE;

SELECT dictGetString(dict3, 'some_column', toUInt64(12));

SELECT dictGetString(CLICKHOUSE_DATABASE.dict3, 'some_column', toUInt64(12));

SELECT dictGetString(default.dict3, 'some_column', toUInt64(12)); -- {serverError BAD_ARGUMENTS}

SELECT dictGet(dict3, 'some_column', toUInt64(12));

SELECT dictGet(CLICKHOUSE_DATABASE.dict3, 'some_column', toUInt64(12));

SELECT dictGet(default.dict3, 'some_column', toUInt64(12)); -- {serverError BAD_ARGUMENTS}

USE default;

-- alias should be handled correctly
SELECT
    'placeholder' || '.dict3' AS n,
    dictGet(n, 'some_column', toUInt64(12));

DROP TABLE CLICKHOUSE_DATABASE.table_for_dict;

SYSTEM RELOAD DICTIONARY CLICKHOUSE_DATABASE.dict3; -- {serverError UNKNOWN_TABLE}