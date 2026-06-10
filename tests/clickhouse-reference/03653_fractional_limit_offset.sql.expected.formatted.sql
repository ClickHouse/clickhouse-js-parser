SET enable_analyzer = '0';

SELECT number
FROM numbers(10)
LIMIT 0.1;

SELECT number
FROM numbers(100)
LIMIT 0.01;

SELECT number
FROM numbers(1000)
LIMIT 0.001;

SELECT number
FROM numbers(10)
LIMIT 0.5;

SELECT number
FROM numbers(10)
LIMIT 0.9;

SELECT number
FROM numbers(10)
LIMIT 0.99;

SELECT number
FROM numbers(10)
OFFSET 0.1;

SELECT number
FROM numbers(100)
OFFSET 0.01;

SELECT number
FROM numbers(10)
OFFSET 0.5;

SELECT number
FROM numbers(10)
OFFSET 0.9;

SELECT number
FROM numbers(10)
OFFSET 0.99;

SELECT number
FROM numbers(10)
LIMIT 0.1
OFFSET 0.1;

SELECT number
FROM numbers(10)
LIMIT 0.1
OFFSET 0.2;

SELECT number
FROM numbers(10)
LIMIT 0.1
OFFSET 0.5;

SELECT number
FROM numbers(100)
LIMIT 0.01
OFFSET 0.9;

SELECT number
FROM numbers(10)
LIMIT 0.1
OFFSET 1;

SELECT number
FROM numbers(10)
LIMIT 0.1
OFFSET 2;

SELECT number
FROM numbers(10)
LIMIT 0.1
OFFSET 5;

SELECT number
FROM numbers(100)
LIMIT 0.01
OFFSET 90;

SELECT number
FROM numbers(10)
LIMIT 1
OFFSET 0.1;

SELECT number
FROM numbers(10)
LIMIT 1
OFFSET 0.2;

SELECT number
FROM numbers(10)
LIMIT 1
OFFSET 0.5;

SELECT number
FROM numbers(100)
LIMIT 1
OFFSET 0.9;

SELECT number
FROM numbers(1000)
LIMIT 1
OFFSET 0.5;

SELECT number
FROM numbers(1000)
ORDER BY number DESC
LIMIT 1
OFFSET 0.5;

SELECT number
FROM numbers(12)
LIMIT 0.25
OFFSET 0.5;

SELECT number
FROM numbers(1000000)
LIMIT 1
OFFSET 0.0999999;

DROP TABLE IF EXISTS num_tab;

CREATE TABLE num_tab
(
    id UInt8,
    val UInt32
)
ENGINE = MergeTree()
ORDER BY (id, val) AS
SELECT
    number % 2 AS id,
    number AS val
FROM numbers(20);

SELECT IF(count() = 5
    AND min(val) = 15
    AND max(val) = 19
    AND sum(val) = 85
    AND uniqExact(id) = 2, 'OK', 'FAIL')
FROM (
        SELECT
            id,
            val
        FROM num_tab
        ORDER BY val ASC
        LIMIT 0.25
        OFFSET 0.75
    );

CREATE TABLE num_tab
ENGINE = MergeTree()
ORDER BY number AS
SELECT number
FROM numbers(1000000);

SELECT number
FROM num_tab
ORDER BY number ASC
LIMIT 10
OFFSET 0.99999;

SET enable_analyzer = '1';