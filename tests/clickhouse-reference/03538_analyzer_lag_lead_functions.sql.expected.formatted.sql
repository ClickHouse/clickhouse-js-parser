SET enable_analyzer = '1';

SELECT
    number,
    lag(number, 1, 8472) OVER () AS lag,
    LAG(number, 1, 8472) OVER () AS lagInsensitive,
    lag(number, 1, 8472) OVER (ORDER BY number ASC) AS lagASC,
    lag(number, 1, 8472) OVER (ORDER BY number DESC) AS lagDESC,
    lead(number, 1, 8472) OVER () AS lead,
    LEAD(number, 1, 8472) OVER () AS leadInsensitive,
    lead(number, 1, 8472) OVER (ORDER BY number DESC) AS leadDESC,
    lead(number, 1, 8472) OVER (ORDER BY number ASC) AS leadASC
FROM numbers(5)
ORDER BY number ASC
FORMAT Pretty;

SELECT
    number,
    lead(number, 1, 8472) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lead
FROM numbers(5)
ORDER BY number ASC
FORMAT Pretty; -- { serverError BAD_ARGUMENTS }

SELECT
    number,
    lag(number, 1, 8472) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lag
FROM numbers(5)
ORDER BY number ASC
FORMAT Pretty; -- { serverError BAD_ARGUMENTS }

SET enable_analyzer = '0';

SELECT
    number,
    lead(number, 1, 8472) OVER () AS lead
FROM numbers(5)
ORDER BY number ASC
FORMAT Pretty; -- { serverError NOT_IMPLEMENTED }

SELECT
    number,
    lag(number, 1, 8472) OVER () AS lag
FROM numbers(5)
ORDER BY number ASC
FORMAT Pretty; -- { serverError NOT_IMPLEMENTED }