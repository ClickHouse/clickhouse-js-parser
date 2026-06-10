SET count_distinct_optimization = '1';

SELECT uniqExact('257')
FROM (
        SELECT
            number,
            CAST(number / 9223372036854775806 AS UInt64) AS m
        FROM numbers(3)
    );