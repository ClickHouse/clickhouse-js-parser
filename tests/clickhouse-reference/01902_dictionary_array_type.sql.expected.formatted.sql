-- Tags: no-parallel
DROP TABLE IF EXISTS dictionary_array_source_table;

CREATE TABLE dictionary_array_source_table
(
    id UInt64,
    array_value Array(Int64)
)
ENGINE = TinyLog();

INSERT INTO dictionary_array_source_table;

DROP DICTIONARY IF EXISTS flat_dictionary;

CREATE DICTIONARY flat_dictionary
(
    id UInt64,
    array_value Array(Int64) DEFAULT [1, 2, 3]
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() TABLE 'dictionary_array_source_table'))
LIFETIME(MIN 1 MAX 1000)
LAYOUT(FLAT());

SELECT dictGet('flat_dictionary', 'array_value', toUInt64(0));

SELECT dictGet('flat_dictionary', 'array_value', toUInt64(1));

SELECT dictGetOrDefault('flat_dictionary', 'array_value', toUInt64(1), [2, 3, 4]);

DROP DICTIONARY flat_dictionary;

DROP DICTIONARY IF EXISTS hashed_dictionary;

CREATE DICTIONARY hashed_dictionary
(
    id UInt64,
    array_value Array(Int64) DEFAULT [1, 2, 3]
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() TABLE 'dictionary_array_source_table'))
LIFETIME(MIN 1 MAX 1000)
LAYOUT(HASHED());

SELECT dictGet('hashed_dictionary', 'array_value', toUInt64(0));

SELECT dictGet('hashed_dictionary', 'array_value', toUInt64(1));

SELECT dictGetOrDefault('hashed_dictionary', 'array_value', toUInt64(1), [2, 3, 4]);

DROP DICTIONARY hashed_dictionary;

DROP DICTIONARY IF EXISTS cache_dictionary;

CREATE DICTIONARY cache_dictionary
(
    id UInt64,
    array_value Array(Int64) DEFAULT [1, 2, 3]
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() TABLE 'dictionary_array_source_table'))
LIFETIME(MIN 1 MAX 1000)
LAYOUT(CACHE(SIZE_IN_CELLS 10));

SELECT dictGet('cache_dictionary', 'array_value', toUInt64(0));

SELECT dictGet('cache_dictionary', 'array_value', toUInt64(1));

SELECT dictGetOrDefault('cache_dictionary', 'array_value', toUInt64(1), [2, 3, 4]);

DROP DICTIONARY cache_dictionary;

DROP DICTIONARY IF EXISTS direct_dictionary;

CREATE DICTIONARY direct_dictionary
(
    id UInt64,
    array_value Array(Int64) DEFAULT [1, 2, 3]
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() TABLE 'dictionary_array_source_table'))
LAYOUT(DIRECT());

SELECT dictGet('direct_dictionary', 'array_value', toUInt64(0));

SELECT dictGet('direct_dictionary', 'array_value', toUInt64(1));

SELECT dictGetOrDefault('direct_dictionary', 'array_value', toUInt64(1), [2, 3, 4]);

DROP DICTIONARY direct_dictionary;

DROP TABLE IF EXISTS ip_trie_dictionary_array_source_table;

CREATE TABLE ip_trie_dictionary_array_source_table
(
    prefix String,
    array_value Array(Int64)
)
ENGINE = TinyLog();

DROP TABLE dictionary_array_source_table;

DROP DICTIONARY IF EXISTS ip_trie_dictionary;

CREATE DICTIONARY ip_trie_dictionary
(
    prefix String,
    array_value Array(Int64) DEFAULT [1, 2, 3]
)
PRIMARY KEY prefix
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() TABLE 'ip_trie_dictionary_array_source_table'))
LIFETIME(MIN 10 MAX 1000)
LAYOUT(IP_TRIE());

INSERT INTO ip_trie_dictionary_array_source_table;

SELECT dictGet('ip_trie_dictionary', 'array_value', tuple(IPv4StringToNum('127.0.0.0')));

SELECT dictGet('ip_trie_dictionary', 'array_value', tuple(IPv4StringToNum('128.0.0.0')));

SELECT dictGetOrDefault('ip_trie_dictionary', 'array_value', tuple(IPv4StringToNum('128.0.0.0')), [2, 3, 4]);

DROP DICTIONARY ip_trie_dictionary;

DROP TABLE ip_trie_dictionary_array_source_table;

DROP TABLE IF EXISTS polygon_dictionary_array_source_table;

CREATE TABLE polygon_dictionary_array_source_table
(
    key Array(Array(Array(Tuple(Float64, Float64)))),
    array_value Array(Int64)
)
ENGINE = TinyLog();

INSERT INTO polygon_dictionary_array_source_table;

DROP DICTIONARY IF EXISTS polygon_dictionary;

CREATE DICTIONARY polygon_dictionary
(
    key Array(Array(Array(Tuple(Float64, Float64)))),
    array_value Array(Int64) DEFAULT [1, 2, 3]
)
PRIMARY KEY key
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() TABLE 'polygon_dictionary_array_source_table'))
LIFETIME(MIN 0 MAX 1000)
LAYOUT(POLYGON());

SELECT dictGet('polygon_dictionary', 'array_value', tuple(0.5, 0.5));

SELECT dictGet('polygon_dictionary', 'array_value', tuple(1.5, 1.5));

SELECT dictGetOrDefault('polygon_dictionary', 'array_value', tuple(1.5, 1.5), [2, 3, 4]);

DROP DICTIONARY polygon_dictionary;

DROP TABLE polygon_dictionary_array_source_table;

DROP TABLE IF EXISTS range_dictionary_array_source_table;

CREATE TABLE range_dictionary_array_source_table
(
    key UInt64,
    start_date Date,
    end_date Date,
    array_value Array(Int64)
)
ENGINE = TinyLog();

INSERT INTO range_dictionary_array_source_table;

CREATE DICTIONARY range_dictionary
(
    key UInt64,
    start_date Date,
    end_date Date,
    array_value Array(Int64) DEFAULT [1, 2, 3]
)
PRIMARY KEY key
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() TABLE 'range_dictionary_array_source_table'))
LIFETIME(MIN 1 MAX 1000)
RANGE(MIN start_date MAX end_date)
LAYOUT(RANGE_HASHED());

SELECT dictGet('range_dictionary', 'array_value', toUInt64(1), toDate('2019-05-15'));

SELECT dictGet('range_dictionary', 'array_value', toUInt64(1), toDate('2019-05-21'));

SELECT dictGetOrDefault('range_dictionary', 'array_value', toUInt64(1), toDate('2019-05-21'), [2, 3, 4]);

DROP DICTIONARY range_dictionary;

DROP TABLE range_dictionary_array_source_table;