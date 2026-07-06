-- { echoOn }
SELECT
    argMax((n, n), n) AS t,
    toTypeName(t)
FROM (
        SELECT if(number >= 100, NULL, number) AS n
        FROM numbers(10)
    );

SELECT
    argMax((n, n), n) AS t,
    toTypeName(t)
FROM (
        SELECT if(number <= 100, NULL, number) AS n
        FROM numbers(10)
    );

SELECT
    argMax((n, n), n) AS t,
    toTypeName(t)
FROM (
        SELECT if(number % 3 = 0, NULL, number) AS n
        FROM numbers(10)
    );

SELECT
    argMax((n, n), n) AS t,
    toTypeName(t)
FROM (
        SELECT if(number >= 100, NULL, number::Int32) AS n
        FROM numbers(10)
    );

SELECT
    argMax((n, n), n) AS t,
    toTypeName(t)
FROM (
        SELECT if(number <= 100, NULL, number::Int32) AS n
        FROM numbers(10)
    );

SELECT
    argMax((n, n), n) AS t,
    toTypeName(t)
FROM (
        SELECT if(number % 3 = 0, NULL, number::Int32) AS n
        FROM numbers(10)
    );

SELECT
    argMin((n, n), n) AS t,
    toTypeName(t)
FROM (
        SELECT if(number >= 100, NULL, number) AS n
        FROM numbers(5, 10)
    );

SELECT
    argMin((n, n), n) AS t,
    toTypeName(t)
FROM (
        SELECT if(number <= 100, NULL, number) AS n
        FROM numbers(5, 10)
    );

SELECT
    argMin((n, n), n) AS t,
    toTypeName(t)
FROM (
        SELECT if(number % 5 = 0, NULL, number) AS n
        FROM numbers(5, 10)
    );

SELECT
    argMin((n, n), n) AS t,
    toTypeName(t)
FROM (
        SELECT if(number >= 100, NULL, number::Int32) AS n
        FROM numbers(5, 10)
    );

SELECT
    argMin((n, n), n) AS t,
    toTypeName(t)
FROM (
        SELECT if(number <= 100, NULL, number::Int32) AS n
        FROM numbers(5, 10)
    );

SELECT
    argMin((n, n), n) AS t,
    toTypeName(t)
FROM (
        SELECT if(number % 5 = 0, NULL, number::Int32) AS n
        FROM numbers(5, 10)
    );

SELECT
    argMaxIf((n, n), n, n > 100) AS t,
    toTypeName(t)
FROM (
        SELECT if(number % 3 = 0, NULL, number) AS n
        FROM numbers(50)
    );

SELECT
    argMaxIf((n, n), n, n < 100) AS t,
    toTypeName(t)
FROM (
        SELECT if(number % 3 = 0, NULL, number) AS n
        FROM numbers(50)
    );

SELECT
    argMaxIf((n, n), n, n % 5 = 0) AS t,
    toTypeName(t)
FROM (
        SELECT if(number % 3 = 0, NULL, number) AS n
        FROM numbers(50)
    );