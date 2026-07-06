-- Tags: no-parallel
DROP TABLE IF EXISTS dictionary_source_table;

CREATE TABLE dictionary_source_table
(
    id UInt64,
    v1 String,
    v2 Nullable(String),
    v3 Nullable(UInt64)
)
ENGINE = TinyLog();

INSERT INTO dictionary_source_table;

DROP DICTIONARY IF EXISTS flat_dictionary;

CREATE DICTIONARY flat_dictionary
(
    id UInt64,
    v1 String,
    v2 Nullable(String) DEFAULT NULL,
    v3 Nullable(UInt64)
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(FLAT());

SELECT dictGetOrDefault('flat_dictionary', ('v1', 'v2'), 0, (intDiv(1, id), intDiv(1, id)))
FROM dictionary_source_table;

SELECT dictGetOrDefault('flat_dictionary', 'v2', id + 1, intDiv(NULL, id))
FROM dictionary_source_table;

SELECT dictGetOrDefault('flat_dictionary', 'v3', id + 1, intDiv(NULL, id))
FROM dictionary_source_table;

DROP DICTIONARY flat_dictionary;

DROP DICTIONARY IF EXISTS hashed_dictionary;

CREATE DICTIONARY hashed_dictionary
(
    id UInt64,
    v1 String,
    v2 Nullable(String) DEFAULT NULL,
    v3 Nullable(UInt64)
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SELECT dictGetOrDefault('hashed_dictionary', ('v1', 'v2'), 0, (intDiv(1, id), intDiv(1, id)))
FROM dictionary_source_table;

SELECT dictGetOrDefault('hashed_dictionary', 'v2', id + 1, intDiv(NULL, id))
FROM dictionary_source_table;

SELECT dictGetOrDefault('hashed_dictionary', 'v3', id + 1, intDiv(NULL, id))
FROM dictionary_source_table;

SELECT dictGetOrDefault('hashed_dictionary', 'v2', 1, intDiv(1, id))
FROM dictionary_source_table;

DROP DICTIONARY hashed_dictionary;

DROP DICTIONARY IF EXISTS hashed_array_dictionary;

CREATE DICTIONARY hashed_array_dictionary
(
    id UInt64,
    v1 String,
    v2 Nullable(String) DEFAULT NULL,
    v3 Nullable(UInt64)
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED_ARRAY());

SELECT dictGetOrDefault('hashed_array_dictionary', ('v1', 'v2'), 0, (intDiv(1, id), intDiv(1, id)))
FROM dictionary_source_table;

SELECT dictGetOrDefault('hashed_array_dictionary', 'v2', id + 1, intDiv(NULL, id))
FROM dictionary_source_table;

SELECT dictGetOrDefault('hashed_array_dictionary', 'v3', id + 1, intDiv(NULL, id))
FROM dictionary_source_table;

-- Fuzzer
SELECT dictGetOrDefault('hashed_array_dictionary', ('v1', 'v2'), toUInt128(0), (materialize(toNullable(NULL)), intDiv(1, id), intDiv(1, id)))
FROM dictionary_source_table; -- { serverError TYPE_MISMATCH }

SELECT
    materialize(materialize(toLowCardinality(15))),
    dictGetOrDefault('hashed_array_dictionary', ('v1', 'v2'), 0, (intDiv(materialize(NULL), id), intDiv(1, id), intDiv(1, id)))
FROM dictionary_source_table; -- { serverError TYPE_MISMATCH }

SELECT dictGetOrDefault('hashed_array_dictionary', ('v1', 'v2'), 0, (toNullable(NULL), intDiv(1, id), intDiv(1, id)))
FROM dictionary_source_table; -- { serverError TYPE_MISMATCH }

DROP DICTIONARY hashed_array_dictionary;

DROP TABLE IF EXISTS range_dictionary_source_table;

CREATE TABLE range_dictionary_source_table
(
    id UInt64,
    start Date,
    `end` Nullable(Date),
    val Nullable(UInt64)
)
ENGINE = TinyLog();

INSERT INTO range_dictionary_source_table;

DROP DICTIONARY IF EXISTS range_hashed_dictionary;

CREATE DICTIONARY range_hashed_dictionary
(
    id UInt64,
    start Date,
    `end` Nullable(Date),
    val Nullable(UInt64)
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'range_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
RANGE(MIN start MAX `end`)
LAYOUT(RANGE_HASHED());

SELECT dictGetOrDefault('range_hashed_dictionary', 'val', id, toDate('2023-01-02'), intDiv(NULL, id))
FROM range_dictionary_source_table;

DROP DICTIONARY range_hashed_dictionary;

DROP TABLE range_dictionary_source_table;

DROP DICTIONARY IF EXISTS cache_dictionary;

CREATE DICTIONARY cache_dictionary
(
    id UInt64,
    v1 String,
    v2 Nullable(String) DEFAULT NULL,
    v3 Nullable(UInt64)
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(CACHE(SIZE_IN_CELLS 10));

SELECT dictGetOrDefault('cache_dictionary', ('v1', 'v2'), 0, (intDiv(1, id), intDiv(1, id)))
FROM dictionary_source_table;

SELECT dictGetOrDefault('cache_dictionary', 'v2', id + 1, intDiv(NULL, id))
FROM dictionary_source_table;

SELECT dictGetOrDefault('cache_dictionary', 'v3', id + 1, intDiv(NULL, id))
FROM dictionary_source_table;

DROP DICTIONARY cache_dictionary;

DROP DICTIONARY IF EXISTS direct_dictionary;

CREATE DICTIONARY direct_dictionary
(
    id UInt64,
    v1 String,
    v2 Nullable(String) DEFAULT NULL,
    v3 Nullable(UInt64)
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'dictionary_source_table'))
LAYOUT(DIRECT());

SELECT dictGetOrDefault('direct_dictionary', ('v1', 'v2'), 0, (intDiv(1, id), intDiv(1, id)))
FROM dictionary_source_table;

SELECT dictGetOrDefault('direct_dictionary', 'v2', id + 1, intDiv(NULL, id))
FROM dictionary_source_table;

SELECT dictGetOrDefault('direct_dictionary', 'v3', id + 1, intDiv(NULL, id))
FROM dictionary_source_table;

DROP DICTIONARY direct_dictionary;

DROP TABLE dictionary_source_table;

DROP TABLE IF EXISTS ip_dictionary_source_table;

CREATE TABLE ip_dictionary_source_table
(
    id UInt64,
    prefix String,
    asn UInt32,
    cca2 String
)
ENGINE = TinyLog();

INSERT INTO ip_dictionary_source_table;

DROP DICTIONARY IF EXISTS ip_dictionary;

CREATE DICTIONARY ip_dictionary
(
    id UInt64,
    prefix String,
    asn UInt32,
    cca2 String
)
PRIMARY KEY prefix
SOURCE(clickhouse(TABLE 'ip_dictionary_source_table'))
LIFETIME(MIN 0 MAX 3600)
LAYOUT(IP_TRIE());

SELECT dictGetOrDefault('ip_dictionary', 'cca2', toIPv4('202.79.32.10'), intDiv(0, id))
FROM ip_dictionary_source_table;

SELECT dictGetOrDefault('ip_dictionary', ('asn', 'cca2'), IPv6StringToNum('2a02:6b8:1::1'), (intDiv(1, id), intDiv(1, id)))
FROM ip_dictionary_source_table;

DROP DICTIONARY ip_dictionary;

DROP TABLE IF EXISTS polygon_dictionary_source_table;

CREATE TABLE polygon_dictionary_source_table
(
    key Array(Array(Array(Tuple(Float64, Float64)))),
    name Nullable(String)
)
ENGINE = TinyLog();

INSERT INTO polygon_dictionary_source_table;

DROP DICTIONARY IF EXISTS polygon_dictionary;

CREATE DICTIONARY polygon_dictionary
(
    key Array(Array(Array(Tuple(Float64, Float64)))),
    name Nullable(String)
)
PRIMARY KEY key
SOURCE(clickhouse(TABLE 'polygon_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(POLYGON());

DROP TABLE IF EXISTS points;

CREATE TABLE points
(
    x Float64,
    y Float64
)
ENGINE = TinyLog();

INSERT INTO points;

SELECT
    tuple(x, y) AS key,
    dictGetOrDefault('polygon_dictionary', 'name', key, intDiv(1, y))
FROM points;

DROP TABLE points;

DROP DICTIONARY polygon_dictionary;

DROP TABLE polygon_dictionary_source_table;

DROP TABLE IF EXISTS regexp_dictionary_source_table;

CREATE TABLE regexp_dictionary_source_table
(
    id UInt64,
    parent_id UInt64,
    regexp String,
    keys Array(String),
    values Array(String)
)
ENGINE = TinyLog();

INSERT INTO regexp_dictionary_source_table;

INSERT INTO regexp_dictionary_source_table;

INSERT INTO regexp_dictionary_source_table;

INSERT INTO regexp_dictionary_source_table;

INSERT INTO regexp_dictionary_source_table;

INSERT INTO regexp_dictionary_source_table;

DROP DICTIONARY IF EXISTS regexp_dict;

CREATE DICTIONARY regexp_dict
(
    regexp String,
    name String,
    version Nullable(UInt64),
    comment String DEFAULT 'nothing'
)
PRIMARY KEY regexp
SOURCE(clickhouse(TABLE 'regexp_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(REGEXP_TREE());

SELECT dictGetOrDefault('regexp_dict', 'name', concat(toString(number), '/tclwebkit', toString(number)), intDiv(1, number))
FROM numbers(2);

-- Fuzzer
SELECT dictGetOrDefault('regexp_dict', 'name', concat('/tclwebkit', toString(number)), intDiv(1, number))
FROM numbers(2); -- { serverError ILLEGAL_DIVISION }

DROP DICTIONARY regexp_dict;

DROP TABLE regexp_dictionary_source_table;