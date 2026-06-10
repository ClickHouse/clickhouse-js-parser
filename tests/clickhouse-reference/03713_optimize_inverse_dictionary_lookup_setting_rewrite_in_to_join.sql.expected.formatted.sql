-- Tags: no-replicated-database, no-parallel-replicas
-- no-parallel, no-parallel-replicas: Dictionary is not created in parallel replicas.
SET enable_analyzer = '1';

SET optimize_inverse_dictionary_lookup = '1';

SET optimize_or_like_chain = '0';

-- Expect no rewrite of dictGet(...) = 'constant'
SET rewrite_in_to_join = '1';

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