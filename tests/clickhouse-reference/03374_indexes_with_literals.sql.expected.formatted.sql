-- Tags: no-random-settings, no-parallel-replicas
-- add_minmax_index_for_numeric_columns=0: We don't want to use implicit indexes since we are checking the one created manually
SET enable_analyzer = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x Int64,
    INDEX idx1 CAST(x AS String) TYPE bloom_filter() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '1', add_minmax_index_for_numeric_columns = '0';

INSERT INTO test SELECT number
FROM numbers(1000);

EXPLAIN indexes = '1'
SELECT *
FROM test
WHERE CAST(x AS String) = '100';

DROP TABLE test;

CREATE TABLE test
(
    x Int64,
    INDEX idx1 CAST(x AS String) TYPE set(0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '1', add_minmax_index_for_numeric_columns = '0';

CREATE TABLE test
(
    x Int64,
    INDEX idx1 CAST(x AS String) TYPE tokenbf_v1(16000, 2, 0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '1', add_minmax_index_for_numeric_columns = '0';

CREATE TABLE test
(
    x Int64,
    INDEX idx1 CAST(x AS String) TYPE ngrambf_v1(4, 16000, 2, 0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '1', add_minmax_index_for_numeric_columns = '0';

CREATE TABLE test
(
    x Int64,
    INDEX idx1 CAST(x AS String) TYPE minmax() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '1', add_minmax_index_for_numeric_columns = '0';