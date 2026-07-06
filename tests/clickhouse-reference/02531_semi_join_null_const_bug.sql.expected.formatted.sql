SET join_use_nulls = '1';

SELECT b.id
FROM
    (
        SELECT toLowCardinality(CAST('0' AS UInt32)) AS id
        GROUP BY []
    ) AS a
SEMI LEFT JOIN (
        SELECT toLowCardinality(CAST('1' AS UInt64)) AS id
    ) AS b
    USING (id);