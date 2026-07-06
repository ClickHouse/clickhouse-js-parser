SET enable_analyzer = '1';

WITH d AS (
    SELECT
        'key'::Varchar(255) AS c,
        'x'::Varchar(255) AS s
)

SELECT
    r1,
    c AS r2
FROM
    (
        SELECT
            t AS s,
            c AS r1
        FROM
            (
                SELECT
                    'y'::Varchar(255) AS t,
                    'x'::Varchar(255) AS s
            ) AS t1
        LEFT JOIN d
            USING (s)
    ) AS t2
LEFT JOIN d
    USING (s)
SETTINGS join_use_nulls = '1';