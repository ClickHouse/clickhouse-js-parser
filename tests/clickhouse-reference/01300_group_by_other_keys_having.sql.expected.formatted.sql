SET optimize_group_by_function_keys = '1';

SET optimize_syntax_fuse_functions = '0';

SET enable_analyzer = '1';

-- { echoOn }
SELECT round(avg(log(2) * number), 6) AS k
FROM numbers(10000000)
GROUP BY
    number % 2 * (number % 3),
    number % 3,
    number % 2
HAVING avg(log(2) * number) > 3465735.3
ORDER BY k ASC;

SELECT round(avg(log(2) * number), 6) AS k
FROM numbers(10000000)
GROUP BY
    number % 2 * (number % 3),
    number % 3,
    number % 2
HAVING avg(log(2) * number) > 3465735.3
ORDER BY k ASC
SETTINGS enable_analyzer = '1';

SELECT round(avg(log(2) * number), 6) AS k
FROM numbers(10000000)
GROUP BY
    number % 5,
    number % 5 * (number % 5)
HAVING number % 5 * (number % 5) < 5
ORDER BY k ASC;

SELECT round(avg(log(2) * number), 6) AS k
FROM numbers(10000000)
GROUP BY
    number % 5,
    number % 5 * (number % 5)
HAVING number % 5 * (number % 5) < 5
ORDER BY k ASC
SETTINGS enable_analyzer = '1';

SELECT number % 5 * (number % 5) AS k
FROM numbers(10000000)
GROUP BY
    number % 5,
    number % 5 * (number % 5)
HAVING number % 5 * (number % 5) < 5
ORDER BY k ASC;

SELECT number % 5 * (number % 5) AS k
FROM numbers(10000000)
GROUP BY
    number % 5,
    number % 5 * (number % 5)
HAVING number % 5 * (number % 5) < 5
ORDER BY k ASC
SETTINGS enable_analyzer = '1';

-- { echoOff }
EXPLAIN SYNTAX
SELECT avg(log(2) * number) AS k
FROM numbers(10000000)
GROUP BY
    number % 2 * (number % 3),
    number % 3,
    number % 2
HAVING avg(log(2) * number) > 3465735.3
ORDER BY k ASC;

EXPLAIN SYNTAX
SELECT avg(log(2) * number) AS k
FROM numbers(10000000)
GROUP BY
    number % 2 * (number % 3),
    number % 3,
    number % 2
HAVING avg(log(2) * number) > 3465735.3
ORDER BY k ASC
SETTINGS enable_analyzer = '0';

EXPLAIN QUERY TREE run_passes = '1'
SELECT avg(log(2) * number) AS k
FROM numbers(10000000)
GROUP BY
    number % 2 * (number % 3),
    number % 3,
    number % 2
HAVING avg(log(2) * number) > 3465735.3
ORDER BY k ASC;

EXPLAIN SYNTAX
SELECT avg(log(2) * number) AS k
FROM numbers(10000000)
GROUP BY
    number % 5,
    number % 5 * (number % 5)
HAVING number % 5 * (number % 5) < 5
ORDER BY k ASC;

EXPLAIN SYNTAX
SELECT avg(log(2) * number) AS k
FROM numbers(10000000)
GROUP BY
    number % 5,
    number % 5 * (number % 5)
HAVING number % 5 * (number % 5) < 5
ORDER BY k ASC
SETTINGS enable_analyzer = '0';

EXPLAIN QUERY TREE run_passes = '1'
SELECT avg(log(2) * number) AS k
FROM numbers(10000000)
GROUP BY
    number % 5,
    number % 5 * (number % 5)
HAVING number % 5 * (number % 5) < 5
ORDER BY k ASC;

EXPLAIN SYNTAX
SELECT number % 5 * (number % 5) AS k
FROM numbers(10000000)
GROUP BY
    number % 5,
    number % 5 * (number % 5)
HAVING number % 5 * (number % 5) < 5
ORDER BY k ASC;

EXPLAIN SYNTAX
SELECT number % 5 * (number % 5) AS k
FROM numbers(10000000)
GROUP BY
    number % 5,
    number % 5 * (number % 5)
HAVING number % 5 * (number % 5) < 5
ORDER BY k ASC
SETTINGS enable_analyzer = '0';

EXPLAIN QUERY TREE run_passes = '1'
SELECT number % 5 * (number % 5) AS k
FROM numbers(10000000)
GROUP BY
    number % 5,
    number % 5 * (number % 5)
HAVING number % 5 * (number % 5) < 5
ORDER BY k ASC;

SET optimize_group_by_function_keys = '0';