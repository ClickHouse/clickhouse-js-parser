SET optimize_group_by_function_keys = '0';

-- { echoOn }
SELECT
    number,
    number % 2,
    sum(number) AS val
FROM remote('127.0.0.{2,3}', numbers(10))
GROUP BY
    number,
    number % 2
WITH ROLLUP
ORDER BY (number, number % 2, val) ASC
SETTINGS group_by_use_nulls = '1';

SELECT
    number,
    number % 2,
    sum(number) AS val
FROM remote('127.0.0.{2,3}', numbers(10))
GROUP BY
    number,
    number % 2
WITH ROLLUP
ORDER BY (number, number % 2, val) ASC
SETTINGS group_by_use_nulls = '0';

SELECT
    number,
    number % 2,
    sum(number) AS val
FROM remote('127.0.0.{2,3}', numbers(10))
GROUP BY
    number,
    number % 2
WITH CUBE
ORDER BY (number, number % 2, val) ASC
SETTINGS group_by_use_nulls = '1';

SELECT
    number,
    number % 2,
    sum(number) AS val
FROM remote('127.0.0.{2,3}', numbers(10))
GROUP BY
    number,
    number % 2
WITH CUBE
ORDER BY (number, number % 2, val) ASC
SETTINGS group_by_use_nulls = '0';

SELECT
    number,
    number % 2,
    sum(number) AS val
FROM remote('127.0.0.{2,3}', numbers(10))
GROUP BY GROUPING SETS ((number), (number % 2))
ORDER BY (number, number % 2, val) ASC
SETTINGS group_by_use_nulls = '1';

SELECT
    number,
    number % 2,
    sum(number) AS val
FROM remote('127.0.0.{2,3}', numbers(10))
GROUP BY GROUPING SETS ((number), (number % 2))
ORDER BY (number, number % 2, val) ASC
SETTINGS group_by_use_nulls = '0';