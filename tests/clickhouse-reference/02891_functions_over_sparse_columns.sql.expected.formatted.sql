DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    key Int
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS ratio_of_defaults_for_sparse_serialization = 0.1;

INSERT INTO test SELECT 0
FROM numbers(10);

SELECT arrayMap((x -> x <= key), [1])
FROM test;

DROP TABLE test;