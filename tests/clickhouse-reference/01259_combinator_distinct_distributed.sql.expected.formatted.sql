-- Tags: distributed
SET distributed_aggregation_memory_efficient = '1';

SELECT sumDistinct(number % 13)
FROM remote('127.0.0.{1,2}', numbers_mt(100000));

SELECT arraySort(groupArrayDistinct(number % 13))
FROM remote('127.0.0.{1,2}', numbers_mt(100000));

SELECT finalizeAggregation(countStateDistinct(toString(number % 20)))
FROM remote('127.0.0.{1,2}', numbers_mt(100000));

SELECT round(corrStableDistinct(x, y), 5)
FROM (
        SELECT
            number % 10 AS x,
            number % 5 AS y
        FROM remote('127.0.0.{1,2}', numbers(1000))
    );

SET distributed_aggregation_memory_efficient = '0';