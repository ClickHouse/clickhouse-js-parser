SET any_join_distinct_right_table_keys = '1';

SELECT a
FROM
    (
        SELECT (1, 2) AS a
    ) AS js1
ANY INNER JOIN (
        SELECT (1, 2) AS a
    ) AS js2
    USING (a);