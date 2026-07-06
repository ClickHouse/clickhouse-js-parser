-- Tags: no-parallel
DROP DATABASE IF EXISTS db_01501;

CREATE DATABASE db_01501;

CREATE TABLE db_01501.table_cache_dict
(
    KeyField UInt64,
    UInt8_ UInt8,
    UInt16_ UInt16,
    UInt32_ UInt32,
    UInt64_ UInt64,
    Int8_ Int8,
    Int16_ Int16,
    Int32_ Int32,
    Int64_ Int64,
    UUID_ UUID,
    Date_ Date,
    DateTime_ DateTime,
    String_ String,
    Float32_ Float32,
    Float64_ Float64,
    Decimal32_ Decimal32(5),
    Decimal64_ Decimal64(15),
    Decimal128_ Decimal128(35),
    ParentKeyField UInt64
)
ENGINE = MergeTree()
ORDER BY KeyField;

CREATE DICTIONARY IF NOT EXISTS db_01501.cache_dict
(
    KeyField UInt64 DEFAULT 9999999,
    UInt8_ UInt8 DEFAULT 55,
    UInt16_ UInt16 DEFAULT 65535,
    UInt32_ UInt32 DEFAULT 4294967295,
    UInt64_ UInt64 DEFAULT 18446744073709551615,
    Int8_ Int8 DEFAULT -128,
    Int16_ Int16 DEFAULT -32768,
    Int32_ Int32 DEFAULT -2147483648,
    Int64_ Int64 DEFAULT -9223372036854775808,
    UUID_ UUID DEFAULT '550e8400-0000-0000-0000-000000000000',
    Date_ Date DEFAULT '2018-12-30',
    DateTime_ DateTime DEFAULT '2018-12-30 00:00:00',
    String_ String DEFAULT 'hi',
    Float32_ Float32 DEFAULT 111.11,
    Float64_ Float64 DEFAULT 222.11,
    Decimal32_ Decimal32(5) DEFAULT 333.11,
    Decimal64_ Decimal64(15) DEFAULT 444.11,
    Decimal128_ Decimal128(35) DEFAULT 555.11,
    ParentKeyField UInt64 DEFAULT 444
)
PRIMARY KEY KeyField
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'table_cache_dict' DB 'db_01501'))
LIFETIME(MIN 0 MAX 5)
LAYOUT(CACHE(SIZE_IN_CELLS 20));

INSERT INTO db_01501.table_cache_dict;

INSERT INTO db_01501.table_cache_dict;

INSERT INTO db_01501.table_cache_dict;

INSERT INTO db_01501.table_cache_dict;

INSERT INTO db_01501.table_cache_dict;

SELECT arrayDistinct(groupArray(dictGetUInt8('db_01501.cache_dict', 'UInt8_', toUInt64(number))))
FROM numbers(10);

SYSTEM RELOAD DICTIONARIES;

SELECT arrayDistinct(groupArray(dictGetUInt16('db_01501.cache_dict', 'UInt16_', toUInt64(number))))
FROM numbers(10);

SELECT arrayDistinct(groupArray(dictGetUInt32('db_01501.cache_dict', 'UInt32_', toUInt64(number))))
FROM numbers(10);

SELECT arrayDistinct(groupArray(dictGetUInt64('db_01501.cache_dict', 'UInt64_', toUInt64(number))))
FROM numbers(10);

SELECT arrayDistinct(groupArray(dictGetInt8('db_01501.cache_dict', 'Int8_', toUInt64(number))))
FROM numbers(10);

SELECT arrayDistinct(groupArray(dictGetInt16('db_01501.cache_dict', 'Int16_', toUInt64(number))))
FROM numbers(10);

SELECT arrayDistinct(groupArray(dictGetInt32('db_01501.cache_dict', 'Int32_', toUInt64(number))))
FROM numbers(10);

SELECT arrayDistinct(groupArray(dictGetInt64('db_01501.cache_dict', 'Int64_', toUInt64(number))))
FROM numbers(10);

SELECT arrayDistinct(groupArray(dictGetFloat32('db_01501.cache_dict', 'Float32_', toUInt64(number))))
FROM numbers(10);

SELECT arrayDistinct(groupArray(dictGetFloat64('db_01501.cache_dict', 'Float64_', toUInt64(number))))
FROM numbers(10);

SELECT arrayDistinct(groupArray(dictGet('db_01501.cache_dict', 'Decimal32_', toUInt64(number))))
FROM numbers(10);

SELECT arrayDistinct(groupArray(dictGet('db_01501.cache_dict', 'Decimal64_', toUInt64(number))))
FROM numbers(10);

SELECT arrayDistinct(groupArray(dictGet('db_01501.cache_dict', 'Decimal128_', toUInt64(number))))
FROM numbers(10);

SELECT arrayDistinct(groupArray(dictGetString('db_01501.cache_dict', 'String_', toUInt64(number))))
FROM numbers(10);

SELECT groupArray(dictHas('db_01501.cache_dict', toUInt64(number)))
FROM numbers(10);

DROP DICTIONARY db_01501.cache_dict;

DROP TABLE db_01501.table_cache_dict;