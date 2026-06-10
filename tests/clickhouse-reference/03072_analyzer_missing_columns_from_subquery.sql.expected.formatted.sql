-- https://github.com/ClickHouse/ClickHouse/issues/14699
SET enable_analyzer = '1';

SELECT *
FROM (
        SELECT number
        FROM numbers(1)
    )
WHERE NOT ignore(*);