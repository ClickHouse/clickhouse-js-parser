-- https://github.com/ClickHouse/ClickHouse/issues/13210
SET enable_analyzer = '1';

CREATE TABLE test_a_table
(
    name String,
    a_col String
)
ENGINE = MergeTree()
ORDER BY name;

CREATE TABLE test_b_table
(
    name String,
    b_col String,
    some_val String
)
ENGINE = MergeTree()
ORDER BY name;

SELECT
    b.name AS name,
    a.a_col AS a_col,
    b.b_col AS b_col,
    'N' AS some_val
FROM
    test_a_table AS a
INNER JOIN test_b_table AS b
    ON a.name = b.name
WHERE b.some_val = 'Y';

SELECT
    b.name AS name,
    a.a_col AS a_col,
    b.b_col AS b_col,
    if(1, 'N', b.some_val) AS some_val
FROM
    test_a_table AS a
INNER JOIN test_b_table AS b
    ON a.name = b.name
WHERE b.some_val = 'Y';