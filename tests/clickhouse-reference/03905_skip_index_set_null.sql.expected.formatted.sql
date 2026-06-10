-- Regression test for https://github.com/ClickHouse/ClickHouse/issues/84856
-- Skip index of type `set` should not throw `Bad get: has Null` when
-- the indexed column contains NULL values.
DROP TABLE IF EXISTS t_skip_index_null;

CREATE TABLE t_skip_index_null
(
    id UInt64,
    val Nullable(String),
    INDEX idx_val val TYPE set(0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO t_skip_index_null;

SELECT
    id,
    val
FROM t_skip_index_null
WHERE val = 'a'
ORDER BY id ASC;

SELECT
    id,
    val
FROM t_skip_index_null
WHERE val IS NULL
ORDER BY id ASC;

SELECT count()
FROM t_skip_index_null
WHERE val = 'nonexistent';

DROP TABLE t_skip_index_null;