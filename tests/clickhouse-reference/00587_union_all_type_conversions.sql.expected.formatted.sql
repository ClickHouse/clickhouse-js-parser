SET max_threads = '1';

SELECT *
FROM (
        SELECT 1 AS x
        UNION ALL
        SELECT -1
    )
ORDER BY x DESC;

SELECT *
FROM (
        SELECT
            x,
            toTypeName(x)
        FROM (
                SELECT 1 AS x
                UNION ALL
                SELECT -1
            )
    )
ORDER BY x DESC;

SELECT x
FROM (
        SELECT 1 AS x
        UNION ALL
        SELECT NULL
    )
ORDER BY x DESC;

SELECT *
FROM (
        SELECT
            x,
            toTypeName(x)
        FROM (
                SELECT 1 AS x
                UNION ALL
                SELECT NULL
            )
    )
ORDER BY x DESC;

SELECT x
FROM (
        SELECT 1 AS x
        UNION ALL
        SELECT NULL
        UNION ALL
        SELECT 1.
    )
ORDER BY x DESC;

SELECT *
FROM (
        SELECT
            x,
            toTypeName(x),
            count()
        FROM (
                SELECT 1 AS x
                UNION ALL
                SELECT NULL
                UNION ALL
                SELECT 1.
            )
        GROUP BY x
    )
ORDER BY x DESC;

SELECT res
FROM (
        SELECT arrayJoin(x) AS res
        FROM (
                SELECT [1, 2, 3] AS x
                UNION ALL
                SELECT [nan, NULL]
            )
        ORDER BY res ASC
    )
ORDER BY res DESC;