SET enable_analyzer = '1';

SET enable_parallel_replicas = '0';

SET enable_join_runtime_filters = '1';

SELECT *
FROM
    (
        SELECT 1 AS a
    ) AS t1
INNER JOIN (
        SELECT 1 AS a
    ) AS t2
    ON t1.a = t2.a;