DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    i UInt64
)
ENGINE = MergeTree()
ORDER BY i;

INSERT INTO test SELECT number
FROM numbers(100);

INSERT INTO test SELECT number
FROM numbers(10, 100);

OPTIMIZE TABLE test FINAL;

-- Only set limit
SET limit = '5';

SELECT *
FROM test
ORDER BY i ASC; -- 5 rows

SELECT *
FROM test
ORDER BY i ASC
OFFSET 20; -- 5 rows

SELECT *
FROM (
        SELECT i
        FROM test
        ORDER BY i ASC
        LIMIT 10
        OFFSET 50
    ) AS TMP
ORDER BY i ASC; -- 5 rows

SELECT *
FROM test
ORDER BY i ASC
LIMIT 4
OFFSET 192; -- 4 rows

SELECT *
FROM test
ORDER BY i ASC
LIMIT 10
OFFSET 195; -- 5 rows

SELECT *
FROM test
ORDER BY i ASC
LIMIT 2 * 2
OFFSET 192;

-- Only set offset
SET limit = '0';

SET offset = '195';

SELECT *
FROM test
ORDER BY i ASC
LIMIT 100; -- no result

SET offset = '10';

SELECT *
FROM test
ORDER BY i ASC
LIMIT 20
OFFSET 100; -- 10 rows

SELECT *
FROM test
ORDER BY i ASC
LIMIT 11
OFFSET 100; -- 1 rows

SELECT *
FROM test
ORDER BY i ASC
LIMIT 20
OFFSET 10 * 10;

SELECT *
FROM test
ORDER BY i ASC
LIMIT 4 * 5
OFFSET 10 * 10;

-- offset and limit together
SET limit = '10';

SELECT *
FROM test
ORDER BY i ASC
LIMIT 50
OFFSET 50; -- 10 rows

SELECT *
FROM test
ORDER BY i ASC
LIMIT 50
OFFSET 190; -- 0 rows

SELECT *
FROM test
ORDER BY i ASC
LIMIT 50
OFFSET 185; -- 5 rows

SELECT *
FROM test
ORDER BY i ASC
LIMIT 18
OFFSET 5; -- 8 rows

DROP TABLE test;