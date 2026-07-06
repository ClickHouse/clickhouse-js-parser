-- https://github.com/ClickHouse/ClickHouse/issues/21558
DROP TABLE IF EXISTS test_array_bloom;

CREATE TABLE test_array_bloom
(
    id UInt16,
    ts DateTime,
    data Array(String),
    INDEX test_bloom data TYPE bloom_filter() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY id
PARTITION BY toYYYYMM(ts);

INSERT INTO test_array_bloom;

INSERT INTO test_array_bloom;

SELECT id
FROM test_array_bloom
WHERE has(data, 'ccc');

SELECT id
FROM
    test_array_bloom
ARRAY JOIN data
WHERE data IN ('aaa')
ORDER BY id ASC;

DROP TABLE test_array_bloom;