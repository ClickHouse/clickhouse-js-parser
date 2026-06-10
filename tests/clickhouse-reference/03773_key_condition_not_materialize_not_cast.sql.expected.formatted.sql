-- Tags: no-replicated-database, no-parallel-replicas, no-parallel, no-random-merge-tree-settings
-- add_minmax_index_for_numeric_columns=0: Different plan
-- EXPLAIN output may differ
DROP TABLE IF EXISTS t_cast_bug;

CREATE TABLE t_cast_bug
(
    val UInt8
)
ENGINE = MergeTree()
ORDER BY val
SETTINGS add_minmax_index_for_numeric_columns = '0';

SYSTEM STOP MERGES t_cast_bug;

INSERT INTO t_cast_bug;

INSERT INTO t_cast_bug;

INSERT INTO t_cast_bug;

SELECT val
FROM t_cast_bug
WHERE NOT CAST(val = 0 AS UInt8)
ORDER BY val ASC;

EXPLAIN indexes = '1'
SELECT val
FROM t_cast_bug
WHERE NOT CAST(val = 0 AS UInt8)
ORDER BY val ASC;

DROP TABLE IF EXISTS t_materialize_bug;

CREATE TABLE t_materialize_bug
(
    val UInt8
)
ORDER BY val
SETTINGS add_minmax_index_for_numeric_columns = '0';

CREATE VIEW v
AS
SELECT
    val,
    val = 0 AS is_zero
FROM t_materialize_bug;

SYSTEM STOP MERGES t_materialize_bug;

INSERT INTO t_materialize_bug;

INSERT INTO t_materialize_bug;

INSERT INTO t_materialize_bug;

SELECT val
FROM v
WHERE NOT is_zero
ORDER BY val ASC;

EXPLAIN indexes = '1'
SELECT val
FROM v
WHERE NOT is_zero
ORDER BY val ASC;