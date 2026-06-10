DROP TABLE IF EXISTS test_tuple_element;

CREATE TABLE test_tuple_element
(
    tuple Tuple(k1 Nullable(UInt64), k2 UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '8192';

INSERT INTO test_tuple_element;

SELECT
    tupleElement(tuple, 'k1', 0) AS fine_k1_with_0,
    tupleElement(tuple, 'k1', NULL) AS k1_with_null,
    tupleElement(tuple, 'k2', 0) AS k2_with_0,
    tupleElement(tuple, 'k2', NULL) AS k2_with_null
FROM test_tuple_element;

DROP TABLE test_tuple_element;