-- https://github.com/ClickHouse/ClickHouse/issues/51321
EXPLAIN ESTIMATE
SELECT any(toTypeName(s))
FROM
    (
        SELECT
            'bbbbbbbb',
            toTypeName(s),
            CAST('' AS LowCardinality(String)),
            NULL,
            CAST('\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0' AS String) AS s
    ) AS t1
FULL JOIN (
        SELECT
            CAST('bbbbb\0\0bbb\0bb\0bb' AS LowCardinality(String)),
            CAST(CAST('a' AS String) AS LowCardinality(String)) AS s
        GROUP BY CoNnEcTiOn_Id()
    ) AS t2
    USING (s)
WITH TOTALS;

EXPLAIN ESTIMATE
SELECT any(s)
FROM
    (
        SELECT '' AS s
    ) AS t1
INNER JOIN (
        SELECT '' AS s
        GROUP BY connection_id()
    ) AS t2
    USING (s);