-- Tags: long, no-parallel
-- originally intended to check found rate, as it is not deterministic, so check query_count instead
--
-- Simple key
--
DROP TABLE IF EXISTS simple_key_source_table_01862;

CREATE TABLE simple_key_source_table_01862
(
    id UInt64,
    value String
)
ENGINE = Memory();

INSERT INTO simple_key_source_table_01862;

-- simple flat
DROP DICTIONARY IF EXISTS simple_key_flat_dictionary_01862;

CREATE DICTIONARY simple_key_flat_dictionary_01862
(
    id UInt64,
    value String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'simple_key_source_table_01862'))
LIFETIME(MIN 1000 MAX 1000)
LAYOUT(FLAT());

SELECT *
FROM simple_key_flat_dictionary_01862
FORMAT Null;

SELECT
    name,
    query_count,
    status,
    last_exception
FROM `system`.dictionaries
WHERE database = currentDatabase()
    AND name = 'simple_key_flat_dictionary_01862';

SELECT *
FROM simple_key_flat_dictionary_01862
WHERE id = 0
FORMAT Null;

SELECT dictGet('simple_key_flat_dictionary_01862', 'value', toUInt64(2))
FORMAT Null;

DROP DICTIONARY simple_key_flat_dictionary_01862;

-- simple direct
DROP DICTIONARY IF EXISTS simple_key_direct_dictionary_01862;

CREATE DICTIONARY simple_key_direct_dictionary_01862
(
    id UInt64,
    value String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'simple_key_source_table_01862'))
LAYOUT(DIRECT());

-- check that found_rate is 0, not nan
SELECT
    name,
    query_count,
    status,
    last_exception
FROM `system`.dictionaries
WHERE database = currentDatabase()
    AND name = 'simple_key_direct_dictionary_01862';

SELECT *
FROM simple_key_direct_dictionary_01862
FORMAT Null;

SELECT dictGet('simple_key_direct_dictionary_01862', 'value', toUInt64(1))
FORMAT Null;

SELECT dictGet('simple_key_direct_dictionary_01862', 'value', toUInt64(2))
FORMAT Null;

DROP DICTIONARY simple_key_direct_dictionary_01862;

-- simple hashed
DROP DICTIONARY IF EXISTS simple_key_hashed_dictionary_01862;

CREATE DICTIONARY simple_key_hashed_dictionary_01862
(
    id UInt64,
    value String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'simple_key_source_table_01862'))
LIFETIME(MIN 1000 MAX 1000)
LAYOUT(HASHED());

SELECT
    name,
    query_count,
    status,
    last_exception
FROM `system`.dictionaries
WHERE database = currentDatabase()
    AND name = 'simple_key_hashed_dictionary_01862';

SELECT dictGet('simple_key_hashed_dictionary_01862', 'value', toUInt64(1))
FORMAT Null;

SELECT dictGet('simple_key_hashed_dictionary_01862', 'value', toUInt64(2))
FORMAT Null;

DROP DICTIONARY simple_key_hashed_dictionary_01862;

-- simple sparse_hashed
DROP DICTIONARY IF EXISTS simple_key_sparse_hashed_dictionary_01862;

CREATE DICTIONARY simple_key_sparse_hashed_dictionary_01862
(
    id UInt64,
    value String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'simple_key_source_table_01862'))
LIFETIME(MIN 1000 MAX 1000)
LAYOUT(SPARSE_HASHED());

SELECT
    name,
    query_count,
    status,
    last_exception
FROM `system`.dictionaries
WHERE database = currentDatabase()
    AND name = 'simple_key_sparse_hashed_dictionary_01862';

SELECT dictGet('simple_key_sparse_hashed_dictionary_01862', 'value', toUInt64(1))
FORMAT Null;

SELECT dictGet('simple_key_sparse_hashed_dictionary_01862', 'value', toUInt64(2))
FORMAT Null;

DROP DICTIONARY simple_key_sparse_hashed_dictionary_01862;

-- simple cache
DROP DICTIONARY IF EXISTS simple_key_cache_dictionary_01862;

CREATE DICTIONARY simple_key_cache_dictionary_01862
(
    id UInt64,
    value String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'simple_key_source_table_01862'))
LIFETIME(MIN 1000 MAX 1000)
LAYOUT(CACHE(SIZE_IN_CELLS 100000));

SELECT
    name,
    query_count,
    status,
    last_exception
FROM `system`.dictionaries
WHERE database = currentDatabase()
    AND name = 'simple_key_cache_dictionary_01862';

SELECT
    toUInt64(1) AS key,
    dictGet('simple_key_cache_dictionary_01862', 'value', key)
FORMAT Null;

SELECT
    toUInt64(2) AS key,
    dictGet('simple_key_cache_dictionary_01862', 'value', key)
FORMAT Null;

DROP DICTIONARY simple_key_cache_dictionary_01862;

DROP TABLE simple_key_source_table_01862;

--
-- Complex key
--
DROP TABLE IF EXISTS complex_key_source_table_01862;

CREATE TABLE complex_key_source_table_01862
(
    id UInt64,
    id_key String,
    value String
)
ENGINE = Memory();

INSERT INTO complex_key_source_table_01862;

-- complex hashed
DROP DICTIONARY IF EXISTS complex_key_hashed_dictionary_01862;

CREATE DICTIONARY complex_key_hashed_dictionary_01862
(
    id UInt64,
    id_key String,
    value String
)
PRIMARY KEY id, id_key
SOURCE(clickhouse(TABLE 'complex_key_source_table_01862'))
LIFETIME(MIN 1000 MAX 1000)
LAYOUT(COMPLEX_KEY_HASHED());

SELECT
    name,
    query_count,
    status,
    last_exception
FROM `system`.dictionaries
WHERE database = currentDatabase()
    AND name = 'complex_key_hashed_dictionary_01862';

SELECT dictGet('complex_key_hashed_dictionary_01862', 'value', (toUInt64(1), 'FirstKey'))
FORMAT Null;

SELECT dictGet('complex_key_hashed_dictionary_01862', 'value', (toUInt64(2), 'FirstKey'))
FORMAT Null;

DROP DICTIONARY complex_key_hashed_dictionary_01862;

-- complex direct
DROP DICTIONARY IF EXISTS complex_key_direct_dictionary_01862;

CREATE DICTIONARY complex_key_direct_dictionary_01862
(
    id UInt64,
    id_key String,
    value String
)
PRIMARY KEY id, id_key
SOURCE(clickhouse(TABLE 'complex_key_source_table_01862'))
LAYOUT(COMPLEX_KEY_DIRECT());

SELECT
    name,
    query_count,
    status,
    last_exception
FROM `system`.dictionaries
WHERE database = currentDatabase()
    AND name = 'complex_key_direct_dictionary_01862';

SELECT dictGet('complex_key_direct_dictionary_01862', 'value', (toUInt64(1), 'FirstKey'))
FORMAT Null;

SELECT dictGet('complex_key_direct_dictionary_01862', 'value', (toUInt64(2), 'FirstKey'))
FORMAT Null;

DROP DICTIONARY complex_key_direct_dictionary_01862;

-- complex cache
DROP DICTIONARY IF EXISTS complex_key_cache_dictionary_01862;

CREATE DICTIONARY complex_key_cache_dictionary_01862
(
    id UInt64,
    id_key String,
    value String
)
PRIMARY KEY id, id_key
SOURCE(clickhouse(TABLE 'complex_key_source_table_01862'))
LIFETIME(MIN 1000 MAX 1000)
LAYOUT(COMPLEX_KEY_CACHE(SIZE_IN_CELLS 100000));

SELECT
    name,
    query_count,
    status,
    last_exception
FROM `system`.dictionaries
WHERE database = currentDatabase()
    AND name = 'complex_key_cache_dictionary_01862';

SELECT dictGet('complex_key_cache_dictionary_01862', 'value', (toUInt64(1), 'FirstKey'))
FORMAT Null;

SELECT dictGet('complex_key_cache_dictionary_01862', 'value', (toUInt64(2), 'FirstKey'))
FORMAT Null;

DROP DICTIONARY complex_key_cache_dictionary_01862;

DROP TABLE complex_key_source_table_01862;

--
-- Range
--
DROP TABLE IF EXISTS range_key_source_table_01862;

CREATE TABLE range_key_source_table_01862
(
    id UInt64,
    value String,
    `first` Date,
    `last` Date
)
ENGINE = Memory();

INSERT INTO range_key_source_table_01862;

-- simple range_hashed
DROP DICTIONARY IF EXISTS simple_key_range_hashed_dictionary_01862;

CREATE DICTIONARY simple_key_range_hashed_dictionary_01862
(
    id UInt64,
    value String,
    `first` Date,
    `last` Date
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'range_key_source_table_01862'))
LIFETIME(MIN 1000 MAX 1000)
RANGE(MIN `first` MAX `last`)
LAYOUT(RANGE_HASHED());

SELECT
    name,
    query_count,
    status,
    last_exception
FROM `system`.dictionaries
WHERE database = currentDatabase()
    AND name = 'simple_key_range_hashed_dictionary_01862';

SELECT dictGet('simple_key_range_hashed_dictionary_01862', 'value', toUInt64(1), today())
FORMAT Null;

SELECT dictGet('simple_key_range_hashed_dictionary_01862', 'value', toUInt64(2), today())
FORMAT Null;

DROP DICTIONARY simple_key_range_hashed_dictionary_01862;

DROP TABLE range_key_source_table_01862;

--
-- IP Trie
--
DROP TABLE IF EXISTS ip_trie_source_table_01862;

CREATE TABLE ip_trie_source_table_01862
(
    prefix String,
    value String
)
ENGINE = Memory();

INSERT INTO ip_trie_source_table_01862;

-- ip_trie
DROP DICTIONARY IF EXISTS ip_trie_dictionary_01862;

CREATE DICTIONARY ip_trie_dictionary_01862
(
    prefix String,
    value String
)
PRIMARY KEY prefix
SOURCE(clickhouse(TABLE 'ip_trie_source_table_01862'))
LIFETIME(MIN 1000 MAX 1000)
LAYOUT(IP_TRIE());

-- found_rate = 0, because we didn't make any searches.
SELECT
    name,
    query_count,
    status,
    last_exception
FROM `system`.dictionaries
WHERE database = currentDatabase()
    AND name = 'ip_trie_dictionary_01862';

-- found_rate = 1, because the dictionary covers the 127.0.0.1 address.
SELECT dictGet('ip_trie_dictionary_01862', 'value', tuple(toIPv4('127.0.0.1')))
FORMAT Null;

-- found_rate = 0.5, because the dictionary does not cover 1.1.1.1 and we have two lookups in total as of now.
SELECT dictGet('ip_trie_dictionary_01862', 'value', tuple(toIPv4('1.1.1.1')))
FORMAT Null;

DROP DICTIONARY ip_trie_dictionary_01862;

DROP TABLE ip_trie_source_table_01862;

-- Polygon
DROP TABLE IF EXISTS polygons_01862;

CREATE TABLE polygons_01862
(
    key Array(Array(Array(Tuple(Float64, Float64)))),
    name String
)
ENGINE = Memory();

INSERT INTO polygons_01862;

INSERT INTO polygons_01862;

INSERT INTO polygons_01862;

INSERT INTO polygons_01862;

DROP TABLE IF EXISTS points_01862;

CREATE TABLE points_01862
(
    x Float64,
    y Float64
)
ENGINE = Memory();

INSERT INTO points_01862;

INSERT INTO points_01862;

INSERT INTO points_01862;

INSERT INTO points_01862;

INSERT INTO points_01862;

DROP DICTIONARY IF EXISTS polygon_dictionary_01862;

CREATE DICTIONARY polygon_dictionary_01862
(
    key Array(Array(Array(Tuple(Float64, Float64)))),
    name String
)
PRIMARY KEY key
SOURCE(clickhouse(USER 'default' TABLE 'polygons_01862'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(POLYGON());

SELECT
    name,
    query_count,
    status,
    last_exception
FROM `system`.dictionaries
WHERE database = currentDatabase()
    AND name = 'polygon_dictionary_01862';

SELECT
    tuple(x, y) AS key,
    dictGet('polygon_dictionary_01862', 'name', key)
FROM points_01862
FORMAT Null;

DROP DICTIONARY polygon_dictionary_01862;

DROP TABLE polygons_01862;

DROP TABLE points_01862;