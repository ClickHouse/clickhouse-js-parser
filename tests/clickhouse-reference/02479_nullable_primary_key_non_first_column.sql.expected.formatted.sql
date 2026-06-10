DROP TABLE IF EXISTS test_table;

CREATE TABLE test_table
(
    A Nullable(String),
    B Nullable(String)
)
ENGINE = MergeTree()
ORDER BY (A, B)
SETTINGS index_granularity = '1', allow_nullable_key = '1';

INSERT INTO test_table;

SELECT *
FROM test_table
WHERE B IS NULL;

DROP TABLE test_table;

DROP TABLE IF EXISTS dm_metric_small2;

CREATE TABLE dm_metric_small2
(
    x Nullable(Int64),
    y Nullable(Int64),
    z Nullable(Int64)
)
ENGINE = MergeTree()
ORDER BY (x, y, z)
SETTINGS index_granularity = '1', allow_nullable_key = '1';

INSERT INTO dm_metric_small2;

SELECT *
FROM dm_metric_small2
WHERE x = 1
    AND y = 1
    AND z IS NULL;

DROP TABLE dm_metric_small2;