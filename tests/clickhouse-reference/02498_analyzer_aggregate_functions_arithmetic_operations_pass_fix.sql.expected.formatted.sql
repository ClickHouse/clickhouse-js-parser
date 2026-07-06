SET enable_analyzer = '1';

SET optimize_arithmetic_operations_in_aggregate_functions = '1';

DROP TABLE IF EXISTS test_table;

CREATE TABLE test_table
(
    id UInt64,
    value UInt64
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test_table;

SELECT
    sum(2 * id AS func),
    func
FROM test_table
GROUP BY id;

SELECT
    max(100 - number),
    min(100 - number)
FROM numbers(2);

SELECT (sum(toDecimal64(2.11, 15) - number), 1)
FROM numbers(2);