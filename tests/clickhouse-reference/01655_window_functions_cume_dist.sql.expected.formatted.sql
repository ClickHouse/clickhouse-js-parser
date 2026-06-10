-- Tags: long
-- { echo }
-- Test for the cume_dist window function.
SET enable_analyzer = '1';

SELECT '-- Basic functionality';

SELECT
    number,
    cume_dist() OVER (ORDER BY number ASC)
FROM numbers(5);

SELECT
    number,
    intDiv(number, 3) AS p,
    cume_dist() OVER (PARTITION BY p ORDER BY number ASC)
FROM numbers(10);

SELECT
    number,
    cume_dist() OVER (ORDER BY number DESC)
FROM numbers(5);

CREATE TABLE IF NOT EXISTS test_cume_dist
(
    a Int,
    b Nullable(Int)
)
ENGINE = Memory();

TRUNCATE TABLE test_cume_dist;

INSERT INTO test_cume_dist;

SELECT
    a,
    b,
    cume_dist() OVER (ORDER BY b ASC)
FROM test_cume_dist
ORDER BY
    b ASC,
    a ASC;

INSERT INTO test_cume_dist;

SELECT
    a,
    b,
    cume_dist() OVER (PARTITION BY a ORDER BY b ASC)
FROM test_cume_dist
ORDER BY
    a ASC,
    b ASC;

INSERT INTO test_cume_dist;

SELECT
    a,
    b,
    cume_dist() OVER (ORDER BY b ASC)
FROM test_cume_dist
ORDER BY a ASC;

SELECT
    a,
    b,
    cume_dist() OVER (ORDER BY b ASC NULLS FIRST)
FROM test_cume_dist
ORDER BY a ASC;

SELECT
    a,
    b,
    cume_dist() OVER (ORDER BY b ASC NULLS LAST)
FROM test_cume_dist
ORDER BY a ASC;

SELECT
    a,
    b,
    cume_dist() OVER (PARTITION BY a ORDER BY b ASC)
FROM test_cume_dist
WHERE a = 3;

SELECT
    a,
    b,
    cume_dist() OVER (PARTITION BY a ORDER BY b ASC)
FROM test_cume_dist
WHERE a = 7;

SELECT
    number,
    cume_dist() OVER (ORDER BY number ASC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
FROM numbers(5); -- { serverError BAD_ARGUMENTS }

DROP TABLE test_cume_dist;