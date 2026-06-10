-- Tags: no-replicated-database, no-parallel-replicas
-- no-parallel, no-parallel-replicas: Dictionary is not created in parallel replicas.
SET enable_analyzer = '1';

SET optimize_inverse_dictionary_lookup = '1';

SET optimize_or_like_chain = '0';

DROP DICTIONARY IF EXISTS dictionary_all;

DROP TABLE IF EXISTS ref_table_all;

DROP TABLE IF EXISTS tab;

CREATE TABLE ref_table_all
(
    id UInt64,
    name String,
    i8 String,
    i16 String,
    i32 String,
    i64 String,
    u8 String,
    u16 String,
    u32 String,
    u64 String,
    f32 String,
    f64 String,
    d String,
    dt String,
    uid String,
    ip4 String,
    ip6 String
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO ref_table_all;

CREATE DICTIONARY dictionary_all
(
    id UInt64,
    name String,
    i8 String,
    i16 String,
    i32 String,
    i64 String,
    u8 String,
    u16 String,
    u32 String,
    u64 String,
    f32 String,
    f64 String,
    d String,
    dt String,
    uid String,
    ip4 String,
    ip6 String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'ref_table_all'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

CREATE TABLE tab
(
    id UInt64,
    payload String
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tab;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    id,
    payload
FROM tab
WHERE dictGet('dictionary_all', 'name', id) = 'alpha'
ORDER BY
    id ASC,
    payload ASC;

SELECT
    id,
    payload
FROM tab
WHERE dictGet('dictionary_all', 'name', id) = 'alpha'
ORDER BY
    id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    id,
    payload
FROM tab
WHERE dictGetString('dictionary_all', 'name', id) = 'alpha'
ORDER BY
    id ASC,
    payload ASC;

SELECT
    id,
    payload
FROM tab
WHERE dictGetString('dictionary_all', 'name', id) = 'alpha'
ORDER BY
    id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    id,
    payload
FROM tab
WHERE dictGetInt32('dictionary_all', 'i32', id) = -32
ORDER BY
    id ASC,
    payload ASC;

SELECT
    id,
    payload
FROM tab
WHERE dictGetInt32('dictionary_all', 'i32', id) = -32
ORDER BY
    id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    id,
    payload
FROM tab
WHERE dictGetUInt64('dictionary_all', 'u64', id) = 64
ORDER BY
    id ASC,
    payload ASC;

SELECT
    id,
    payload
FROM tab
WHERE dictGetUInt64('dictionary_all', 'u64', id) = 64
ORDER BY
    id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    id,
    payload
FROM tab
WHERE dictGetFloat64('dictionary_all', 'f64', id) = 20.
ORDER BY
    id ASC,
    payload ASC;

SELECT
    id,
    payload
FROM tab
WHERE dictGetFloat64('dictionary_all', 'f64', id) = 20.
ORDER BY
    id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    id,
    payload
FROM tab
WHERE dictGetDate('dictionary_all', 'd', id) = toDate('2025-01-01')
ORDER BY
    id ASC,
    payload ASC;

SELECT
    id,
    payload
FROM tab
WHERE dictGetDate('dictionary_all', 'd', id) = toDate('2025-01-01')
ORDER BY
    id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    id,
    payload
FROM tab
WHERE dictGetDateTime('dictionary_all', 'dt', id) = toDateTime('2025-01-01 10:00:00')
ORDER BY
    id ASC,
    payload ASC;

SELECT
    id,
    payload
FROM tab
WHERE dictGetDateTime('dictionary_all', 'dt', id) = toDateTime('2025-01-01 10:00:00')
ORDER BY
    id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    id,
    payload
FROM tab
WHERE dictGetUUID('dictionary_all', 'uid', id) = toUUID('00000000-0000-0000-0000-000000000001')
ORDER BY
    id ASC,
    payload ASC;

SELECT
    id,
    payload
FROM tab
WHERE dictGetUUID('dictionary_all', 'uid', id) = toUUID('00000000-0000-0000-0000-000000000001')
ORDER BY
    id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    id,
    payload
FROM tab
WHERE dictGetIPv4('dictionary_all', 'ip4', id) = toIPv4('192.168.0.1')
ORDER BY
    id ASC,
    payload ASC;

SELECT
    id,
    payload
FROM tab
WHERE dictGetIPv4('dictionary_all', 'ip4', id) = toIPv4('192.168.0.1')
ORDER BY
    id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    id,
    payload
FROM tab
WHERE dictGetIPv6('dictionary_all', 'ip6', id) = toIPv6('2001:db8::1')
ORDER BY
    id ASC,
    payload ASC;

SELECT
    id,
    payload
FROM tab
WHERE dictGetIPv6('dictionary_all', 'ip6', id) = toIPv6('2001:db8::1')
ORDER BY
    id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    id,
    payload
FROM tab
WHERE dictGetOrNull('dictionary_all', 'name', id) = 'alpha'
ORDER BY
    id ASC,
    payload ASC;

SELECT
    id,
    payload
FROM tab
WHERE dictGetOrNull('dictionary_all', 'name', id) = 'alpha'
ORDER BY
    id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    id,
    payload
FROM tab
WHERE isNull(dictGetOrNull('dictionary_all', 'name', id))
ORDER BY
    id ASC,
    payload ASC;

SELECT
    id,
    payload
FROM tab
WHERE isNull(dictGetOrNull('dictionary_all', 'name', id))
ORDER BY
    id ASC,
    payload ASC;