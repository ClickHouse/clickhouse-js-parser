SET enable_analyzer = '0';

DROP TABLE IF EXISTS test_table;

CREATE TABLE test_table
(
    id UInt64,
    value String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_table;

SELECT 1
UNION ALL
SELECT 1;

SELECT '--';

SELECT 1
UNION DISTINCT
SELECT 1
UNION ALL
SELECT 1;

SELECT 1
INTERSECT
SELECT 1;

SELECT 1
EXCEPT
SELECT 1;

SELECT id
FROM (
        SELECT 1 AS id
        UNION ALL
        SELECT 1
    );

SELECT value
FROM (
        SELECT 1 AS value
        UNION ALL
        SELECT 1
        UNION ALL
        SELECT 1
    );

SELECT id
FROM test_table
UNION ALL
SELECT id
FROM test_table;

SELECT id
FROM test_table
UNION DISTINCT
SELECT id
FROM test_table;

SELECT id
FROM test_table
INTERSECT
SELECT id
FROM test_table;

SELECT id
FROM test_table
EXCEPT
SELECT id
FROM test_table;

SELECT id
FROM (
        SELECT id
        FROM test_table
        UNION ALL
        SELECT id
        FROM test_table
    );

SELECT id
FROM (
        SELECT id
        FROM test_table
        UNION DISTINCT
        SELECT id
        FROM test_table
    );

SELECT id
FROM (
        SELECT id
        FROM test_table
INTERSECT
        SELECT id
        FROM test_table
    );

SELECT id
FROM (
        SELECT id
        FROM test_table
EXCEPT
        SELECT id
        FROM test_table
    );

-- { echoOff }
DROP TABLE test_table;