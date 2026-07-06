-- { echoOn }
SET max_block_size = '10', enable_unaligned_array_join = true;

SELECT
    n,
    count(1)
FROM
    (
        SELECT groupArray(number % 10) AS x
        FROM (
                SELECT *
                FROM numbers(100000)
            )
    )
ARRAY JOIN x AS n
GROUP BY n;

SELECT
    n % 10,
    count(1)
FROM
    (
        SELECT range(0, number) AS x
        FROM numbers(1000)
    )
LEFT ARRAY JOIN x AS n
GROUP BY n % 10;

SELECT
    (m + n) % 10,
    count(1)
FROM
    (
        SELECT
            range(0, number + 1) AS x,
            range(0, number + 2) AS y
        FROM numbers(100)
    )
ARRAY JOIN x AS m, y AS n
GROUP BY (m + n) % 10;

SET max_block_size = '1000', enable_unaligned_array_join = true;

SET max_block_size = '100000', enable_unaligned_array_join = true; -- { echoOff }