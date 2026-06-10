SET enable_analyzer = '1';

SET max_block_size = '65505';

SET optimize_group_by_function_keys = '1';

SELECT round(max(log(2) * number), 6) AS k
FROM numbers(10000000)
GROUP BY
    number % 2,
    number % 3,
    (number % 2 + number % 3) % 2
ORDER BY k ASC;

SELECT round(avg(log(2) * number), 6) AS k
FROM numbers(10000000)
GROUP BY
    number % 5,
    number % 5 * (number % 5)
ORDER BY k ASC;

SELECT round(avg(log(2) * number), 6) AS k
FROM numbers(10000000)
GROUP BY
    number % 2 * (number % 3),
    number % 3
ORDER BY k ASC;

SELECT round(avg(log(2) * number), 6) AS k
FROM numbers(10000000)
GROUP BY
    number % 2 * (number % 3),
    number % 3,
    number % 2
ORDER BY k ASC;

SELECT round(avg(log(2) * number), 6) AS k
FROM numbers(10000000)
GROUP BY
    number % 2 % 3,
    number % 2
ORDER BY k ASC;

EXPLAIN SYNTAX
SELECT max(log(2) * number) AS k
FROM numbers(10000000)
GROUP BY
    number % 2,
    number % 3,
    (number % 2 + number % 3) % 2
ORDER BY k ASC;

EXPLAIN SYNTAX
SELECT avg(log(2) * number) AS k
FROM numbers(10000000)
GROUP BY
    number % 5,
    number % 5 * (number % 5)
ORDER BY k ASC;

EXPLAIN SYNTAX
SELECT avg(log(2) * number) AS k
FROM numbers(10000000)
GROUP BY
    number % 2 * (number % 3),
    number % 3
ORDER BY k ASC;

EXPLAIN SYNTAX
SELECT avg(log(2) * number) AS k
FROM numbers(10000000)
GROUP BY
    number % 2 * (number % 3),
    number % 3,
    number % 2
ORDER BY k ASC;

EXPLAIN SYNTAX
SELECT avg(log(2) * number) AS k
FROM numbers(10000000)
GROUP BY
    number % 2 % 3,
    number % 2
ORDER BY k ASC;

SET optimize_group_by_function_keys = '0'; -- TODO - test with similar variables of different tables (collision)