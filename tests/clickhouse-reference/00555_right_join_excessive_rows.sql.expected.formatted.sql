SET any_join_distinct_right_table_keys = '1';

SET max_block_size = '10';

SELECT *
FROM
    (
        SELECT toUInt64(1) AS s
        LIMIT 1
    ) AS js1
ANY RIGHT JOIN (
        SELECT
            number AS s,
            s AS x
        FROM numbers(11)
    ) AS js2
    USING (s)
ORDER BY s ASC;