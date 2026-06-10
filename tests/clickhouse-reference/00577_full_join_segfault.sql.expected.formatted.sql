SET any_join_distinct_right_table_keys = '1';

SET joined_subquery_requires_alias = '0';

SELECT
    k,
    a1,
    b1,
    a2,
    b2
FROM
    (
        SELECT
            0 AS k,
            'hello' AS a1,
            123 AS b1,
            a1
    )
ANY FULL JOIN (
        SELECT
            1 AS k,
            'hello' AS a2,
            456 AS b2,
            a2
    )
    USING (k)
ORDER BY k ASC;

SELECT
    k,
    a,
    b
FROM
    (
        SELECT
            0 AS k,
            'hello' AS a,
            123 AS b,
            a
    )
ANY FULL JOIN (
        SELECT 1 AS k
    )
    USING (k)
ORDER BY k ASC;

SET join_use_nulls = '1';