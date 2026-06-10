SET any_join_distinct_right_table_keys = '1';

SET joined_subquery_requires_alias = '0';

SET enable_analyzer = '1';

SELECT *
FROM
    (
        SELECT
            1 AS a,
            'x' AS b
    )
INNER JOIN (
        SELECT
            1 AS a,
            'y' AS b
    )
    USING (a);

SELECT *
FROM
    (
        SELECT
            1 AS a,
            'x' AS b
    )
LEFT JOIN (
        SELECT
            1 AS a,
            'y' AS b
    )
    USING (a);

SELECT *
FROM
    (
        SELECT
            1 AS a,
            'x' AS b
    )
FULL JOIN (
        SELECT
            1 AS a,
            'y' AS b
    )
    USING (a);

SELECT *
FROM
    (
        SELECT
            1 AS a,
            'x' AS b
    )
RIGHT JOIN (
        SELECT
            1 AS a,
            'y' AS b
    )
    USING (a);

SELECT *
FROM
    (
        SELECT
            1 AS a,
            'x' AS b
    )
ANY INNER JOIN (
        SELECT
            1 AS a,
            'y' AS b
    )
    USING (a);

SELECT *
FROM
    (
        SELECT
            1 AS a,
            'x' AS b
    )
ANY LEFT JOIN (
        SELECT
            1 AS a,
            'y' AS b
    )
    USING (a);

SELECT *
FROM
    (
        SELECT
            1 AS a,
            'x' AS b
    )
ANY FULL JOIN (
        SELECT
            1 AS a,
            'y' AS b
    )
    USING (a);

SELECT *
FROM
    (
        SELECT
            1 AS a,
            'x' AS b
    )
ANY RIGHT JOIN (
        SELECT
            1 AS a,
            'y' AS b
    )
    USING (a);

SET any_join_distinct_right_table_keys = '0';