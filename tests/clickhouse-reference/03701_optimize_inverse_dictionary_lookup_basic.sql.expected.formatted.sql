-- Tags: no-replicated-database, no-parallel-replicas
-- no-parallel, no-parallel-replicas: Dictionary is not created in parallel replicas.
SET enable_analyzer = '1';

SET optimize_inverse_dictionary_lookup = '1';

SET optimize_or_like_chain = '0';

DROP DICTIONARY IF EXISTS colors;

DROP TABLE IF EXISTS ref_colors;

CREATE TABLE ref_colors
(
    id UInt64,
    name String,
    n UInt64
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO ref_colors;

CREATE DICTIONARY colors
(
    id UInt64,
    name String,
    n UInt64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'ref_colors'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    color_id UInt64,
    payload String
)
ENGINE = MergeTree()
ORDER BY color_id;

INSERT INTO t;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload
FROM t
WHERE dictGetString('colors', 'name', color_id) = 'red'
ORDER BY
    color_id ASC,
    payload ASC;

SELECT
    color_id,
    payload
FROM t
WHERE dictGetString('colors', 'name', color_id) = 'red'
ORDER BY
    color_id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload
FROM t
WHERE 'red' = dictGetString('colors', 'name', color_id)
ORDER BY
    color_id ASC,
    payload ASC;

SELECT
    color_id,
    payload
FROM t
WHERE 'red' = dictGetString('colors', 'name', color_id)
ORDER BY
    color_id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload
FROM t
WHERE dictGetUInt64('colors', 'n', color_id) < 10
ORDER BY
    color_id ASC,
    payload ASC;

SELECT
    color_id,
    payload
FROM t
WHERE dictGetUInt64('colors', 'n', color_id) < 10
ORDER BY
    color_id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload
FROM t
WHERE 10 > dictGetUInt64('colors', 'n', color_id)
ORDER BY
    color_id ASC,
    payload ASC;

SELECT
    color_id,
    payload
FROM t
WHERE 10 > dictGetUInt64('colors', 'n', color_id)
ORDER BY
    color_id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload
FROM t
WHERE dictGetInt32('colors', 'n', color_id) >= 2
ORDER BY
    color_id ASC,
    payload ASC;

SELECT
    color_id,
    payload
FROM t
WHERE dictGetInt32('colors', 'n', color_id) >= 2
ORDER BY
    color_id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload
FROM t
WHERE dictGetString('colors', 'name', color_id) LIKE 'r%'
ORDER BY
    color_id ASC,
    payload ASC;

SELECT
    color_id,
    payload
FROM t
WHERE dictGetString('colors', 'name', color_id) LIKE 'r%'
ORDER BY
    color_id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload
FROM t
WHERE dictGetString('colors', 'name', color_id) ILIKE 'r%'
ORDER BY
    color_id ASC,
    payload ASC;

SELECT
    color_id,
    payload
FROM t
WHERE dictGetString('colors', 'name', color_id) ILIKE 'r%'
ORDER BY
    color_id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT color_id
FROM t
WHERE equals(dictGetString('colors', 'name', color_id), 'red')
ORDER BY color_id ASC;

SELECT color_id
FROM t
WHERE equals(dictGetString('colors', 'name', color_id), 'red')
ORDER BY color_id ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload
FROM t
WHERE dictGetString('colors', 'name', color_id) != 'red'
ORDER BY
    color_id ASC,
    payload ASC;

SELECT
    color_id,
    payload
FROM t
WHERE dictGetString('colors', 'name', color_id) != 'red'
ORDER BY
    color_id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload
FROM t
WHERE dictGetString('colors', 'name', color_id) NOT LIKE 'r%'
ORDER BY
    color_id ASC,
    payload ASC;

SELECT
    color_id,
    payload
FROM t
WHERE dictGetString('colors', 'name', color_id) NOT LIKE 'r%'
ORDER BY
    color_id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload
FROM t
WHERE dictGetString('colors', 'name', color_id) NOT ILIKE 'r%'
ORDER BY
    color_id ASC,
    payload ASC;

SELECT
    color_id,
    payload
FROM t
WHERE dictGetString('colors', 'name', color_id) NOT ILIKE 'r%'
ORDER BY
    color_id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload
FROM t
WHERE match(dictGetString('colors', 'name', color_id), '^r')
ORDER BY
    color_id ASC,
    payload ASC;

SELECT
    color_id,
    payload
FROM t
WHERE match(dictGetString('colors', 'name', color_id), '^r')
ORDER BY
    color_id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload
FROM t
WHERE NOT dictGetString('colors', 'name', color_id) = 'red'
ORDER BY
    color_id ASC,
    payload ASC;

SELECT
    color_id,
    payload
FROM t
WHERE NOT dictGetString('colors', 'name', color_id) = 'red'
ORDER BY
    color_id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload
FROM t
WHERE dictGetString('colors', 'name', color_id) = 'red'
    AND dictGetUInt64('colors', 'n', color_id) < 10
    OR dictGetString('colors', 'name', color_id) = 'green'
ORDER BY
    color_id ASC,
    payload ASC;

SELECT
    color_id,
    payload
FROM t
WHERE dictGetString('colors', 'name', color_id) = 'red'
    AND dictGetUInt64('colors', 'n', color_id) < 10
    OR dictGetString('colors', 'name', color_id) = 'green'
ORDER BY
    color_id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload
FROM t
WHERE dictGetString('colors', 'name', color_id) = NULL
ORDER BY
    color_id ASC,
    payload ASC;

SELECT
    color_id,
    payload
FROM t
WHERE dictGetString('colors', 'name', color_id) = NULL
ORDER BY
    color_id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT color_id
FROM t
PREWHERE dictGetString('colors', 'name', color_id) = 'red'
ORDER BY color_id ASC;

SELECT color_id
FROM t
PREWHERE dictGetString('colors', 'name', color_id) = 'red'
ORDER BY color_id ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    row_number() OVER (PARTITION BY 1 ORDER BY color_id ASC) AS rn
FROM t
QUALIFY dictGetString('colors', 'name', color_id) = 'red'
ORDER BY
    color_id ASC,
    rn ASC;

SELECT
    color_id,
    row_number() OVER (PARTITION BY 1 ORDER BY color_id ASC) AS rn
FROM t
QUALIFY dictGetString('colors', 'name', color_id) = 'red'
ORDER BY
    color_id ASC,
    rn ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT color_id
FROM t
WHERE dictGetString('colors', 'name', color_id) = 'nonexistent_color'
ORDER BY color_id ASC;

SELECT color_id
FROM t
WHERE dictGetString('colors', 'name', color_id) = 'nonexistent_color'
ORDER BY color_id ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    count() AS c
FROM t
GROUP BY color_id
HAVING dictGetString('colors', 'name', color_id) = 'red'
ORDER BY
    color_id ASC,
    c ASC;

SELECT
    color_id,
    count() AS c
FROM t
GROUP BY color_id
HAVING dictGetString('colors', 'name', color_id) = 'red'
ORDER BY
    color_id ASC,
    c ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    t1.color_id,
    t1.payload,
    t2.payload AS payload2
FROM
    t AS t1
INNER JOIN t AS t2
    ON t1.color_id = t2.color_id
    AND dictGetString('colors', 'name', t1.color_id) = 'red'
ORDER BY
    t1.color_id ASC,
    t1.payload ASC,
    payload2 ASC;

SELECT
    t1.color_id,
    t1.payload,
    t2.payload AS payload2
FROM
    t AS t1
INNER JOIN t AS t2
    ON t1.color_id = t2.color_id
    AND dictGetString('colors', 'name', t1.color_id) = 'red'
ORDER BY
    t1.color_id ASC,
    t1.payload ASC,
    payload2 ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    t1.color_id,
    t1.payload,
    t2.payload AS payload2
FROM
    t AS t1
LEFT JOIN t AS t2
    ON t1.color_id = t2.color_id
    AND dictGetString('colors', 'name', t1.color_id) = 'red'
ORDER BY
    t1.color_id ASC,
    t1.payload ASC,
    payload2 ASC;

SELECT
    t1.color_id,
    t1.payload,
    t2.payload AS payload2
FROM
    t AS t1
LEFT JOIN t AS t2
    ON t1.color_id = t2.color_id
    AND dictGetString('colors', 'name', t1.color_id) = 'red'
ORDER BY
    t1.color_id ASC,
    t1.payload ASC,
    payload2 ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload,
    multiIf(dictGetString('colors', 'name', color_id) = 'red', 'match', 'no_match') AS tag
FROM t
ORDER BY
    color_id ASC,
    payload ASC,
    tag ASC;

SELECT
    color_id,
    payload,
    multiIf(dictGetString('colors', 'name', color_id) = 'red', 'match', 'no_match') AS tag
FROM t
ORDER BY
    color_id ASC,
    payload ASC,
    tag ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT countIf(dictGetString('colors', 'name', color_id) = 'red') AS cnt
FROM t;

SELECT countIf(dictGetString('colors', 'name', color_id) = 'red') AS cnt
FROM t;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT sumIf(color_id, dictGetString('colors', 'name', color_id) = 'red') AS sum_id_match
FROM t;

SELECT sumIf(color_id, dictGetString('colors', 'name', color_id) = 'red') AS sum_id_match
FROM t;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload
FROM t
ORDER BY
    dictGetString('colors', 'name', color_id) = 'red' DESC,
    color_id ASC,
    payload ASC;

SELECT
    color_id,
    payload
FROM t
ORDER BY
    dictGetString('colors', 'name', color_id) = 'red' DESC,
    color_id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    dictGetString('colors', 'name', color_id) = 'red' AS is_red,
    count() AS c
FROM t
GROUP BY dictGetString('colors', 'name', color_id) = 'red'
ORDER BY
    is_red ASC,
    c ASC;

SELECT
    dictGetString('colors', 'name', color_id) = 'red' AS is_red,
    count() AS c
FROM t
GROUP BY dictGetString('colors', 'name', color_id) = 'red'
ORDER BY
    is_red ASC,
    c ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    payload
FROM t
ORDER BY
    color_id ASC,
    payload ASC
LIMIT 1 BY dictGetString('colors', 'name', color_id) = 'red';

SELECT
    color_id,
    payload
FROM t
ORDER BY
    color_id ASC,
    payload ASC
LIMIT 1 BY dictGetString('colors', 'name', color_id) = 'red';

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    color_id,
    row_number() OVER (PARTITION BY dictGetString('colors', 'name', color_id) = 'red' ORDER BY color_id ASC) AS rn
FROM t
ORDER BY
    color_id ASC,
    rn ASC;

SELECT
    color_id,
    row_number() OVER (PARTITION BY dictGetString('colors', 'name', color_id) = 'red' ORDER BY color_id ASC) AS rn
FROM t
ORDER BY
    color_id ASC,
    rn ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT color_id
FROM t
WHERE dictGetString('colors', 'name', color_id) = payload
ORDER BY color_id ASC;

SELECT color_id
FROM t
WHERE dictGetString('colors', 'name', color_id) = payload
ORDER BY color_id ASC;

-- Validation of attribute name
CREATE DICTIONARY dict
(
    c0 UInt128
)
PRIMARY KEY c0
SOURCE(null())
LIFETIME(MIN 0 MAX 0)
LAYOUT(FLAT());

SELECT
    *,
    dictGetUInt16('dict', 'c0', t1.c0) = true
FROM dict AS t1; -- { serverError BAD_ARGUMENTS }

DROP TABLE IF EXISTS t__fuzz_0;

CREATE TABLE t__fuzz_0
(
    color_id UInt64,
    payload String
)
ENGINE = MergeTree()
ORDER BY color_id;

CREATE DICTIONARY colors
(
    color_id UInt64,
    payload String
)
PRIMARY KEY color_id
SOURCE(clickhouse(TABLE 't__fuzz_0'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SELECT equals(materialize(9), CAST('red' AS Nullable(String)) = dictGetString('colors', 'payload', color_id))
FROM t__fuzz_0;

SET allow_suspicious_low_cardinality_types = '1';

DROP DICTIONARY IF EXISTS dictionary_all;

DROP TABLE IF EXISTS ref_table_all;

DROP TABLE IF EXISTS tab__fuzz_24;

CREATE TABLE tab__fuzz_24
(
    id LowCardinality(UInt16),
    payload LowCardinality(Nullable(Int8))
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tab__fuzz_24;

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

SELECT DISTINCT
    13,
    *,
    or(-32 = dictGetInt32(toFixedString('dictionary_all', toLowCardinality(14)), toFixedString('i32', 3), id), isNotDistinctFrom(1, 9223372036854775806), toLowCardinality(19), NOT equals(payload, 9223372036854775806)),
    isNotNull('dictGetFloat64 - plan'),
    id,
    isNotNull(1)
FROM tab__fuzz_24
PREWHERE equals(9223372036854775806, payload)
WHERE isNotDistinctFrom(id, isNotDistinctFrom(9223372036854775806, equals(1, isNotNull(9223372036854775806))))
QUALIFY and(NULL, equals(1, isZeroOrNull(1)))
ORDER BY payload DESC;