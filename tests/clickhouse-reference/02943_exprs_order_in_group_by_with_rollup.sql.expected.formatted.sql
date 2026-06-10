DROP TABLE IF EXISTS test_group_by_with_rollup_order;

CREATE TABLE test_group_by_with_rollup_order
(
    id Int64,
    a Nullable(Int64),
    b Nullable(String)
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test_group_by_with_rollup_order;

INSERT INTO test_group_by_with_rollup_order;

INSERT INTO test_group_by_with_rollup_order;

INSERT INTO test_group_by_with_rollup_order;

SELECT
    toString(a) AS r1,
    b,
    count()
FROM test_group_by_with_rollup_order
GROUP BY
    r1,
    b
WITH ROLLUP
ORDER BY
    b ASC,
    r1 ASC;