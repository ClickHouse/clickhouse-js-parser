CREATE TABLE test1
(
    col UInt64,
    col_sq UInt64 MATERIALIZED col * col
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple();

INSERT INTO test1;

CREATE TABLE test2
(
    col UInt64
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple();

INSERT INTO test2;

SELECT
    t1.col,
    t1.col_sq
FROM
    test2 AS t2
LEFT JOIN test1 AS t1
    ON t1.col = t2.col
SETTINGS enable_analyzer = '1';

SELECT
    t1.col,
    t1.col_sq
FROM
    test2 AS t2
LEFT JOIN test1 AS t1
    ON t1.col = t2.col
SETTINGS enable_analyzer = '0'; -- {serverError UNKNOWN_IDENTIFIER}