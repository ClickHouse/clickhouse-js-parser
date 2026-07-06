-- https://github.com/ClickHouse/ClickHouse/issues/47288
SET enable_analyzer = '1';

SELECT 1 AS c0
FROM (
        SELECT C.`字段` AS `字段`
        FROM
            (
                SELECT 2 AS bb
            ) AS A
        LEFT JOIN (
                SELECT '1' AS `字段`
            ) AS C
            ON 1 = 1
        LEFT JOIN (
                SELECT 1 AS a
            ) AS D
            ON 1 = 1
    ) AS T0
WHERE T0.`字段` = '1';

SELECT 1 AS c0
FROM (
        SELECT C.`＄` AS `＄`
        FROM
            (
                SELECT 2 AS bb
            ) AS A
        LEFT JOIN (
                SELECT '1' AS `＄`
            ) AS C
            ON 1 = 1
        LEFT JOIN (
                SELECT 1 AS a
            ) AS D
            ON 1 = 1
    ) AS T0
WHERE T0.`＄` = '1';