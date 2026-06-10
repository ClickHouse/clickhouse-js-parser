SET enable_analyzer = '1';

-- { echoOn }
SELECT sum(number + 1)
FROM numbers(10);

SELECT sum(1 + number)
FROM numbers(10);

SELECT sum(number - 1)
FROM numbers(10);

SELECT sum(1 - number)
FROM numbers(10);

EXPLAIN QUERY TREE
SELECT sum(number + 1)
FROM numbers(10);

EXPLAIN QUERY TREE
SELECT sum(1 + number)
FROM numbers(10);

EXPLAIN QUERY TREE
SELECT sum(number - 1)
FROM numbers(10);

EXPLAIN QUERY TREE
SELECT sum(1 - number)
FROM numbers(10);

WITH CAST('1' AS Nullable(UInt64)) AS my_literal

SELECT sum(number + my_literal)
FROM numbers(0);

WITH CAST('1' AS Nullable(UInt64)) AS my_literal

SELECT sum(number) + my_literal * count()
FROM numbers(0);

EXPLAIN QUERY TREE
WITH CAST('1' AS Nullable(UInt64)) AS my_literal

SELECT sum(number + my_literal)
FROM numbers(0);

EXPLAIN QUERY TREE
WITH CAST('1' AS Nullable(UInt64)) AS my_literal

SELECT sum(number) + my_literal * count()
FROM numbers(0);

-- { echoOff }
DROP TABLE IF EXISTS test_table;

CREATE TABLE test_table
(
    uint64 UInt64,
    float64 Float64,
    decimal32 Decimal32(5)
)
ENGINE = MergeTree()
ORDER BY uint64;

-- Use Float64 numbers divisible by 1/16 (or some other small power of two), so that their sum doesn't depend on summation order.
INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

-- { echoOn }
SELECT sum(uint64 + 1 AS i)
FROM test_table
WHERE i > 0;

SELECT sum(uint64 + 1) AS j
FROM test_table
HAVING j > 0;

SELECT sum(uint64 + 1 AS i) AS j
FROM test_table
WHERE i > 0
HAVING j > 0;

SELECT sum((uint64 AS m) + (1 AS n)) AS j
FROM test_table
WHERE m > 0
    AND n > 0
HAVING j > 0;

SELECT sum((uint64 AS m) + (1 AS n) AS i) AS j
FROM test_table
WHERE m > 0
    AND n > 0
    AND i > 0
HAVING j > 0;

EXPLAIN QUERY TREE
SELECT sum(uint64 + 1 AS i)
FROM test_table
WHERE i > 0;

EXPLAIN QUERY TREE
SELECT sum(uint64 + 1) AS j
FROM test_table
HAVING j > 0;

EXPLAIN QUERY TREE
SELECT sum(uint64 + 1 AS i) AS j
FROM test_table
WHERE i > 0
HAVING j > 0;

EXPLAIN QUERY TREE
SELECT sum((uint64 AS m) + (1 AS n)) AS j
FROM test_table
WHERE m > 0
    AND n > 0
HAVING j > 0;

EXPLAIN QUERY TREE
SELECT sum((uint64 AS m) + (1 AS n) AS i) AS j
FROM test_table
WHERE m > 0
    AND n > 0
    AND i > 0
HAVING j > 0;

SELECT sum(1 + uint64 AS i)
FROM test_table
WHERE i > 0;

SELECT sum(1 + uint64) AS j
FROM test_table
HAVING j > 0;

SELECT sum(1 + uint64 AS i) AS j
FROM test_table
WHERE i > 0
HAVING j > 0;

SELECT sum((1 AS m) + (uint64 AS n)) AS j
FROM test_table
WHERE m > 0
    AND n > 0
HAVING j > 0;

SELECT sum((1 AS m) + (uint64 AS n) AS i) AS j
FROM test_table
WHERE m > 0
    AND n > 0
    AND i > 0
HAVING j > 0;

EXPLAIN QUERY TREE
SELECT sum(1 + uint64 AS i)
FROM test_table
WHERE i > 0;

EXPLAIN QUERY TREE
SELECT sum(1 + uint64) AS j
FROM test_table
HAVING j > 0;

EXPLAIN QUERY TREE
SELECT sum(1 + uint64 AS i) AS j
FROM test_table
WHERE i > 0
HAVING j > 0;

EXPLAIN QUERY TREE
SELECT sum((1 AS m) + (uint64 AS n)) AS j
FROM test_table
WHERE m > 0
    AND n > 0
HAVING j > 0;

EXPLAIN QUERY TREE
SELECT sum((1 AS m) + (uint64 AS n) AS i) AS j
FROM test_table
WHERE m > 0
    AND n > 0
    AND i > 0
HAVING j > 0;

SELECT sum(uint64 - 1 AS i)
FROM test_table
WHERE i > 0;

SELECT sum(uint64 - 1) AS j
FROM test_table
HAVING j > 0;

SELECT sum(uint64 - 1 AS i) AS j
FROM test_table
WHERE i > 0
HAVING j > 0;

SELECT sum((uint64 AS m) - (1 AS n)) AS j
FROM test_table
WHERE m > 0
    AND n > 0
HAVING j > 0;

SELECT sum((uint64 AS m) - (1 AS n) AS i) AS j
FROM test_table
WHERE m > 0
    AND n > 0
    AND i > 0
HAVING j > 0;

EXPLAIN QUERY TREE
SELECT sum(uint64 - 1 AS i)
FROM test_table
WHERE i > 0;

EXPLAIN QUERY TREE
SELECT sum(uint64 - 1) AS j
FROM test_table
HAVING j > 0;

EXPLAIN QUERY TREE
SELECT sum(uint64 - 1 AS i) AS j
FROM test_table
WHERE i > 0
HAVING j > 0;

EXPLAIN QUERY TREE
SELECT sum((uint64 AS m) - (1 AS n)) AS j
FROM test_table
WHERE m > 0
    AND n > 0
HAVING j > 0;

EXPLAIN QUERY TREE
SELECT sum((uint64 AS m) - (1 AS n) AS i) AS j
FROM test_table
WHERE m > 0
    AND n > 0
    AND i > 0
HAVING j > 0;

SELECT sum(1 - uint64 AS i)
FROM test_table;

SELECT sum(1 - uint64) AS j
FROM test_table;

SELECT sum(1 - uint64 AS i) AS j
FROM test_table;

SELECT sum((1 AS m) - (uint64 AS n)) AS j
FROM test_table;

SELECT sum((1 AS m) - (uint64 AS n) AS i) AS j
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(1 - uint64 AS i)
FROM test_table
WHERE i > 0;

EXPLAIN QUERY TREE
SELECT sum(1 - uint64) AS j
FROM test_table
HAVING j < 0;

EXPLAIN QUERY TREE
SELECT sum(1 - uint64 AS i) AS j
FROM test_table
WHERE i > 0
HAVING j < 0;

EXPLAIN QUERY TREE
SELECT sum((1 AS m) - (uint64 AS n)) AS j
FROM test_table
WHERE m > 0
    AND n > 0
HAVING j < 0;

EXPLAIN QUERY TREE
SELECT sum((1 AS m) - (uint64 AS n) AS i) AS j
FROM test_table
WHERE m > 0
    AND n > 0
    AND i < 0
HAVING j < 0;

SELECT sum(uint64 + 2.11)
FROM test_table;

SELECT sum(2.11 + uint64)
FROM test_table;

SELECT sum(uint64 - 2.11)
FROM test_table;

SELECT sum(2.11 - uint64)
FROM test_table;

SELECT sum(uint64) + 2.11 * count(uint64)
FROM test_table;

SELECT 2.11 * count(uint64) + sum(uint64)
FROM test_table;

SELECT sum(uint64) - 2.11 * count(uint64)
FROM test_table;

SELECT 2.11 * count(uint64) - sum(uint64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(uint64 + 2.11)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(2.11 + uint64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(uint64 - 2.11)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(2.11 - uint64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(uint64) + 2.11 * count(uint64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT 2.11 * count(uint64) + sum(uint64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(uint64) - 2.11 * count(uint64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT 2.11 * count(uint64) - sum(uint64)
FROM test_table;

SELECT sum(uint64 + 2)
FROM test_table;

SELECT sum(2 + uint64)
FROM test_table;

SELECT sum(uint64 - 2)
FROM test_table;

SELECT sum(2 - uint64)
FROM test_table;

SELECT sum(uint64) + 2 * count(uint64)
FROM test_table;

SELECT 2 * count(uint64) + sum(uint64)
FROM test_table;

SELECT sum(uint64) - 2 * count(uint64)
FROM test_table;

SELECT 2 * count(uint64) - sum(uint64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(uint64 + 2)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(2 + uint64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(uint64 - 2)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(2 - uint64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(uint64) + 2 * count(uint64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT 2 * count(uint64) + sum(uint64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(uint64) - 2 * count(uint64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT 2 * count(uint64) - sum(uint64)
FROM test_table;

SELECT sum(float64 + 2)
FROM test_table;

SELECT sum(2 + float64)
FROM test_table;

SELECT sum(float64 - 2)
FROM test_table;

SELECT sum(2 - float64)
FROM test_table;

SELECT sum(float64) + 2 * count(float64)
FROM test_table;

SELECT 2 * count(float64) + sum(float64)
FROM test_table;

SELECT sum(float64) - 2 * count(float64)
FROM test_table;

SELECT 2 * count(float64) - sum(float64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(float64 + 2)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(2 + float64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(float64 - 2)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(2 - float64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(float64) + 2 * count(float64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT 2 * count(float64) + sum(float64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(float64) - 2 * count(float64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT 2 * count(float64) - sum(float64)
FROM test_table;

SELECT sum(decimal32 + 2)
FROM test_table;

SELECT sum(2 + decimal32)
FROM test_table;

SELECT sum(decimal32 - 2)
FROM test_table;

SELECT sum(2 - decimal32)
FROM test_table;

SELECT sum(decimal32) + 2 * count(decimal32)
FROM test_table;

SELECT 2 * count(decimal32) + sum(decimal32)
FROM test_table;

SELECT sum(decimal32) - 2 * count(decimal32)
FROM test_table;

SELECT 2 * count(decimal32) - sum(decimal32)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(decimal32 + 2)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(2 + decimal32)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(decimal32 - 2)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(2 - decimal32)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(decimal32) + 2 * count(decimal32)
FROM test_table;

EXPLAIN QUERY TREE
SELECT 2 * count(decimal32) + sum(decimal32)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(decimal32) - 2 * count(decimal32)
FROM test_table;

EXPLAIN QUERY TREE
SELECT 2 * count(decimal32) - sum(decimal32)
FROM test_table;

SELECT sum(uint64 + 2) + sum(uint64 + 3)
FROM test_table;

SELECT sum(uint64 + 2) - sum(uint64 + 3)
FROM test_table;

SELECT sum(uint64 - 2) - sum(uint64 - 3)
FROM test_table;

SELECT sum(2 - uint64) - sum(3 - uint64)
FROM test_table;

SELECT sum(uint64) + 2 * count(uint64) + (sum(uint64) + 3 * count(uint64))
FROM test_table;

SELECT sum(uint64) + 2 * count(uint64) - (sum(uint64) + 3 * count(uint64))
FROM test_table;

SELECT sum(uint64) - 2 * count(uint64) + (sum(uint64) - 3 * count(uint64))
FROM test_table;

SELECT sum(uint64) - 2 * count(uint64) - (sum(uint64) - 3 * count(uint64))
FROM test_table;

SELECT 2 * count(uint64) - sum(uint64) + (3 * count(uint64) - sum(uint64))
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(uint64 + 2) + sum(uint64 + 3)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(uint64 + 2) - sum(uint64 + 3)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(uint64 - 2) + sum(uint64 - 3)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(uint64 - 2) - sum(uint64 - 3)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(2 - uint64) - sum(3 - uint64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(uint64) + 2 * count(uint64) + (sum(uint64) + 3 * count(uint64))
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(uint64) + 2 * count(uint64) - (sum(uint64) + 3 * count(uint64))
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(uint64) - 2 * count(uint64) + (sum(uint64) - 3 * count(uint64))
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(uint64) - 2 * count(uint64) - (sum(uint64) - 3 * count(uint64))
FROM test_table;

EXPLAIN QUERY TREE
SELECT 2 * count(uint64) - sum(uint64) + (3 * count(uint64) - sum(uint64))
FROM test_table;

SELECT sum(float64 + 2) + sum(float64 + 3)
FROM test_table;

SELECT sum(float64 + 2) - sum(float64 + 3)
FROM test_table;

SELECT sum(float64 - 2) + sum(float64 - 3)
FROM test_table;

SELECT sum(float64 - 2) - sum(float64 - 3)
FROM test_table;

SELECT sum(2 - float64) - sum(3 - float64)
FROM test_table;

SELECT sum(float64) + 2 * count(float64) + (sum(float64) + 3 * count(float64))
FROM test_table;

SELECT sum(float64) + 2 * count(float64) - (sum(float64) + 3 * count(float64))
FROM test_table;

SELECT sum(float64) - 2 * count(float64) + (sum(float64) - 3 * count(float64))
FROM test_table;

SELECT sum(float64) - 2 * count(float64) - (sum(float64) - 3 * count(float64))
FROM test_table;

SELECT 2 * count(float64) - sum(float64) + (3 * count(float64) - sum(float64))
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(float64 + 2) + sum(float64 + 3)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(float64 + 2) - sum(float64 + 3)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(float64 - 2) + sum(float64 - 3)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(float64 - 2) - sum(float64 - 3)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(2 - float64) - sum(3 - float64)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(float64) + 2 * count(float64) + (sum(float64) + 3 * count(float64))
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(float64) + 2 * count(float64) - (sum(float64) + 3 * count(float64))
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(float64) - 2 * count(float64) + (sum(float64) - 3 * count(float64))
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(float64) - 2 * count(float64) - (sum(float64) - 3 * count(float64))
FROM test_table;

EXPLAIN QUERY TREE
SELECT 2 * count(float64) - sum(float64) + (3 * count(float64) - sum(float64))
FROM test_table;

SELECT sum(decimal32 + 2) + sum(decimal32 + 3)
FROM test_table;

SELECT sum(decimal32 + 2) - sum(decimal32 + 3)
FROM test_table;

SELECT sum(decimal32 - 2) + sum(decimal32 - 3)
FROM test_table;

SELECT sum(decimal32 - 2) - sum(decimal32 - 3)
FROM test_table;

SELECT sum(2 - decimal32) - sum(3 - decimal32)
FROM test_table;

SELECT sum(decimal32) + 2 * count(decimal32) + (sum(decimal32) + 3 * count(decimal32))
FROM test_table;

SELECT sum(decimal32) + 2 * count(decimal32) - (sum(decimal32) + 3 * count(decimal32))
FROM test_table;

SELECT sum(decimal32) - 2 * count(decimal32) + (sum(decimal32) - 3 * count(decimal32))
FROM test_table;

SELECT sum(decimal32) - 2 * count(decimal32) - (sum(decimal32) - 3 * count(decimal32))
FROM test_table;

SELECT 2 * count(decimal32) - sum(decimal32) + (3 * count(decimal32) - sum(decimal32))
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(decimal32 + 2) + sum(decimal32 + 3)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(decimal32 + 2) - sum(decimal32 + 3)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(decimal32 - 2) + sum(decimal32 - 3)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(decimal32 - 2) - sum(decimal32 - 3)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(2 - decimal32) - sum(3 - decimal32)
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(decimal32) + 2 * count(decimal32) + (sum(decimal32) + 3 * count(decimal32))
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(decimal32) + 2 * count(decimal32) - (sum(decimal32) + 3 * count(decimal32))
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(decimal32) - 2 * count(decimal32) + (sum(decimal32) - 3 * count(decimal32))
FROM test_table;

EXPLAIN QUERY TREE
SELECT sum(decimal32) - 2 * count(decimal32) - (sum(decimal32) - 3 * count(decimal32))
FROM test_table;

EXPLAIN QUERY TREE
SELECT 2 * count(decimal32) - sum(decimal32) + (3 * count(decimal32) - sum(decimal32))
FROM test_table;