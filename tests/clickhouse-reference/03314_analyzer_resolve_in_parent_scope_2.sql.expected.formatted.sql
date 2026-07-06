CREATE TABLE test
(
    raw_id String,
    columns_n Nested(col_1 Nullable(String), col_2 Nullable(String))
)
ENGINE = MergeTree()
ORDER BY raw_id;

INSERT INTO test;

WITH t LIKE '%_1%' AS issue

SELECT
    raw_id,
    arrayFilter(((t, t2) -> NOT issue), columns_n.col_1, columns_n.col_2)
FROM test
ORDER BY raw_id ASC;