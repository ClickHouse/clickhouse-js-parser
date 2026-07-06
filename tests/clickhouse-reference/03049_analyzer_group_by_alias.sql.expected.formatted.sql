-- https://github.com/ClickHouse/ClickHouse/issues/7520
SET enable_analyzer = '1';

CREATE TABLE test
(
    a UInt32,
    b UInt32
)
ENGINE = Memory();

INSERT INTO test;

-- 1	5
-- 2	4
WITH a AS key

SELECT
    a AS k1,
    sum(b) AS k2
FROM test
GROUP BY key
ORDER BY
    k1 ASC,
    k2 ASC;

WITH a AS key

SELECT key AS k1
FROM test
GROUP BY key
ORDER BY key ASC;

WITH a AS key

SELECT key AS k1
FROM test
ORDER BY key ASC;