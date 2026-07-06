DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    val LowCardinality(Nullable(String))
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '8192';

INSERT INTO test SELECT number = 3 ? 'some value' : NULL
FROM numbers(5);

SELECT count(val)
FROM test
SETTINGS optimize_use_implicit_projections = '1';

DROP TABLE test;