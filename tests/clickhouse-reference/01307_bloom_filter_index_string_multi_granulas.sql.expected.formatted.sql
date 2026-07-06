DROP TABLE IF EXISTS test_01307;

CREATE TABLE test_01307
(
    id UInt64,
    val String,
    INDEX ind val TYPE bloom_filter() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '2', index_granularity_bytes = '10Mi';

INSERT INTO test_01307 (id, val) SELECT
    number AS id,
    toString(number) AS val
FROM numbers(4);

SELECT count()
FROM test_01307
WHERE identity(val) = '2';

SELECT count()
FROM test_01307
WHERE val = '2';

OPTIMIZE TABLE test_01307 FINAL;

DROP TABLE test_01307;