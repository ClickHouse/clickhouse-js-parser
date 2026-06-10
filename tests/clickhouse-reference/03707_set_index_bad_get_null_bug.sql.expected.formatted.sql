SET enable_parallel_replicas = '0';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    ts Int64,
    v LowCardinality(String),
    INDEX v v TYPE set(0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY ts;

INSERT INTO test (v);

EXPLAIN indexes = '1', description = '0'
SELECT
    CAST(NULL AS Nullable(String)) AS source,
    v AS v
FROM test
WHERE source = 'VALUE1'
    OR v ILIKE 'VALUE1';