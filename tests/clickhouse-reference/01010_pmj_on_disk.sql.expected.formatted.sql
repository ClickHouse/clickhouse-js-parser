SET join_algorithm = 'hash';

SET query_plan_join_swap_table = false;

SELECT
    n,
    j
FROM
    (
        SELECT number AS n
        FROM numbers(4)
    ) AS nums
ANY LEFT JOIN (
        SELECT
            number * 2 AS n,
            number + 10 AS j
        FROM numbers(4000)
    ) AS js2
    USING (n)
ORDER BY n ASC;

SET max_rows_in_join = '1000';

SET join_algorithm = 'partial_merge';

SET partial_merge_join_optimizations = '1';

SET join_algorithm = 'auto';

SET max_rows_in_join = '10';