SET compile_expressions = '1';

SET min_count_to_compile_expression = '0';

SELECT
    nan AS value,
    value = value,
    value = materialize(value),
    materialize(value) = value,
    materialize(value) = materialize(value);

SELECT
    CAST(nan AS Float32) AS value,
    value = value,
    value = materialize(value),
    materialize(value) = value,
    materialize(value) = materialize(value);

SELECT
    nan AS lhs,
    CAST(nan AS Float32) AS rhs,
    lhs = rhs,
    lhs = materialize(rhs),
    materialize(lhs) = rhs,
    materialize(lhs) = materialize(rhs);

SELECT '--';

DROP TABLE IF EXISTS test_table;

CREATE TABLE test_table
(
    id UInt32,
    value UInt32
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test_table;

SELECT value
FROM (
        SELECT stddevSamp(id) AS value
        FROM test_table
    ) AS subquery
WHERE value = value
    AND NOT value = value;

DROP TABLE test_table;

SELECT
    nan AS value,
    value != value,
    value != materialize(value),
    materialize(value) != value,
    materialize(value) != materialize(value);

SELECT
    CAST(nan AS Float32) AS value,
    value != value,
    value != materialize(value),
    materialize(value) != value,
    materialize(value) != materialize(value);

SELECT
    nan AS lhs,
    CAST(nan AS Float32) AS rhs,
    lhs != rhs,
    lhs != materialize(rhs),
    materialize(lhs) != rhs,
    materialize(lhs) != materialize(rhs);

CREATE TABLE test_table
(
    id UInt32,
    value_1 UInt32,
    value_2 Float32
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test_table;

SELECT value
FROM (
        SELECT corr(value_1, value_1) OVER test_window AS value
        FROM test_table
        WINDOW test_window AS (PARTITION BY value_2 ORDER BY id ASC)
    ) AS subquery
WHERE NOT NOT value != value;

CREATE TABLE test_table
(
    id Float32,
    value Float32
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test_table;

SELECT *
FROM
    (
        SELECT corr(id, id) AS corr_value
        FROM test_table
        GROUP BY value
    ) AS subquery
ANTI LEFT JOIN test_table
    ON subquery.corr_value = test_table.id
WHERE test_table.id >= test_table.id
    AND NOT test_table.id >= test_table.id;