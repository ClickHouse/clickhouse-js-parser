-- { echo }
-- Normal cases
SELECT
    a,
    b,
    ntile(3) OVER (PARTITION BY a ORDER BY b ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    );

SELECT
    a,
    b,
    ntile(3) OVER (PARTITION BY a ORDER BY b ASC)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    );

SELECT
    a,
    b,
    ntile(2) OVER (PARTITION BY a ORDER BY b ASC)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    );

SELECT
    a,
    b,
    ntile(1) OVER (PARTITION BY a ORDER BY b ASC)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    );

SELECT
    a,
    b,
    ntile(100) OVER (PARTITION BY a ORDER BY b ASC)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    );

SELECT
    a,
    b,
    ntile(65535) OVER (PARTITION BY a ORDER BY b ASC)
FROM (
        SELECT
            1 AS a,
            number AS b
        FROM numbers(65535)
    )
LIMIT 100;

-- Bad arguments
SELECT
    a,
    b,
    ntile(3.) OVER (PARTITION BY a ORDER BY b ASC)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    ); -- { serverError BAD_ARGUMENTS }

SELECT
    a,
    b,
    ntile('2') OVER (PARTITION BY a ORDER BY b ASC)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    ); -- { serverError BAD_ARGUMENTS }

SELECT
    a,
    b,
    ntile(0) OVER (PARTITION BY a ORDER BY b ASC)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    ); -- { serverError BAD_ARGUMENTS }

SELECT
    a,
    b,
    ntile(-2) OVER (PARTITION BY a ORDER BY b ASC)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    ); -- { serverError BAD_ARGUMENTS }

SELECT
    a,
    b,
    ntile(b + 1) OVER (PARTITION BY a ORDER BY b ASC)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    ); -- { serverError BAD_ARGUMENTS }

SELECT
    a,
    b,
    ntile() OVER (PARTITION BY a ORDER BY b ASC)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    ); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT
    a,
    b,
    ntile(3, 2) OVER (PARTITION BY a ORDER BY b ASC)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    ); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

-- Bad window type
SELECT
    a,
    b,
    ntile(2) OVER (PARTITION BY a)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    ); -- { serverError BAD_ARGUMENTS }

SELECT
    a,
    b,
    ntile(2) OVER (PARTITION BY a ORDER BY b ASC ROWS BETWEEN 4 PRECEDING AND UNBOUNDED FOLLOWING)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    ); -- { serverError BAD_ARGUMENTS }

SELECT
    a,
    b,
    ntile(2) OVER (PARTITION BY a ORDER BY b ASC ROWS BETWEEN UNBOUNDED PRECEDING AND 4 FOLLOWING)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    ); -- { serverError BAD_ARGUMENTS }

SELECT
    a,
    b,
    ntile(2) OVER (PARTITION BY a ORDER BY b ASC ROWS BETWEEN 4 PRECEDING AND 4 FOLLOWING)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    );

; -- { serverError BAD_ARGUMENTS }

SELECT
    a,
    b,
    ntile(2) OVER (PARTITION BY a ORDER BY b ASC ROWS BETWEEN CURRENT ROW AND 4 FOLLOWING)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    );

SELECT
    a,
    b,
    ntile(2) OVER (PARTITION BY a ORDER BY b ASC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM (
        SELECT
            intDiv(number, 10) AS a,
            number % 10 AS b
        FROM numbers(20)
    );