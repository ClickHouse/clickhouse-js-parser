SET distributed_aggregation_memory_efficient = '1';

SELECT
    number AS a,
    number + 1 AS b
FROM remote('127.0.0.{1,2}', numbers_mt(100000.))
GROUP BY GROUPING SETS ((a), (b))
FORMAT Null;