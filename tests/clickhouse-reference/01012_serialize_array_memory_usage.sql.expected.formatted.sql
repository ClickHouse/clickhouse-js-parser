-- Tags: no-replicated-database
-- serialization of big arrays shouldn't use too much memory
SET max_memory_usage = '300000000';

SELECT ignore(x)
FROM (
        SELECT groupArray(number) AS x
        FROM numbers(3355443)
    )
GROUP BY x
FORMAT Null;