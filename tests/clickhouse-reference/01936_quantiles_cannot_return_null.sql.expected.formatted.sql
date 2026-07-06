SET aggregate_functions_null_for_empty = '0';

SELECT quantiles(0.95)(x)
FROM (
        SELECT 1 AS x
        WHERE 0
    );

SELECT quantiles(0.95)(number)
FROM (
        SELECT number
        FROM numbers(10)
        WHERE number > 10
    );

SET aggregate_functions_null_for_empty = '1';