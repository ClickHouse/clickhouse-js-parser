DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x UInt32,
    arr1 Array(UInt32),
    arr2 Array(UInt32)
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO test;

SELECT *
FROM test
WHERE x = 1
    AND arrayExists(((x1, x2) -> x1 = x2), arr1, arr2)
SETTINGS allow_reorder_prewhere_conditions = '0';

DROP TABLE test;