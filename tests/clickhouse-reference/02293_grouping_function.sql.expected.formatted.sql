SET optimize_group_by_function_keys = '0';

SELECT
    number,
    grouping(number, number % 2, number % 3) AS gr
FROM numbers(10)
GROUP BY GROUPING SETS ((number), (number % 2))
ORDER BY
    number ASC,
    gr ASC; -- { serverError BAD_ARGUMENTS }

-- { echoOn }
SELECT
    number,
    grouping(number, number % 2) AS gr
FROM numbers(10)
GROUP BY GROUPING SETS ((number), (number % 2))
ORDER BY
    number ASC,
    gr ASC
SETTINGS force_grouping_standard_compatibility = '0';

SELECT
    number,
    grouping(number % 2, number) AS gr
FROM numbers(10)
GROUP BY GROUPING SETS ((number), (number % 2))
ORDER BY
    number ASC,
    gr ASC
SETTINGS force_grouping_standard_compatibility = '0';

SELECT
    number,
    grouping(number, number % 2) = 1 AS gr
FROM numbers(10)
GROUP BY GROUPING SETS ((number), (number % 2))
ORDER BY
    number ASC,
    gr ASC
SETTINGS force_grouping_standard_compatibility = '0';

SELECT number
FROM numbers(10)
GROUP BY GROUPING SETS ((number), (number % 2))
ORDER BY
    number ASC,
    grouping(number, number % 2) = 1 ASC
SETTINGS force_grouping_standard_compatibility = '0';

SELECT
    number,
    count(),
    grouping(number, number % 2) AS gr
FROM numbers(10)
GROUP BY GROUPING SETS ((number), (number, number % 2), ())
ORDER BY (gr, number) ASC
SETTINGS force_grouping_standard_compatibility = '0';

SELECT number
FROM numbers(10)
GROUP BY GROUPING SETS ((number), (number % 2))
HAVING grouping(number, number % 2) = 2
ORDER BY number ASC
SETTINGS
    enable_optimize_predicate_expression = '0',
    force_grouping_standard_compatibility = '0';

SELECT number
FROM numbers(10)
GROUP BY GROUPING SETS ((number), (number % 2))
HAVING grouping(number, number % 2) = 1
ORDER BY number ASC
SETTINGS
    enable_optimize_predicate_expression = '0',
    force_grouping_standard_compatibility = '0';

SELECT
    number,
    grouping(number, number % 2) = 1 AS gr
FROM remote('127.0.0.{2,3}', numbers(10))
GROUP BY GROUPING SETS ((number), (number % 2))
ORDER BY
    number ASC,
    gr ASC
SETTINGS force_grouping_standard_compatibility = '0';