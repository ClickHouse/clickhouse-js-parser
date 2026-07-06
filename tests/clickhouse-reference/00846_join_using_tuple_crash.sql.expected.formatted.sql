SET any_join_distinct_right_table_keys = '1';

SELECT *
FROM
    (
        SELECT
            dummy AS a,
            (toUInt8(0), toUInt8(0)) AS tup
        FROM `system`.one
    ) AS js1
INNER JOIN (
        SELECT
            dummy AS a,
            (toUInt8(0), toUInt8(0)) AS tup
        FROM `system`.one
    ) AS js2
    USING (a, tup);

SELECT *
FROM
    (
        SELECT
            dummy AS a,
            (toUInt8(0), toUInt8(0)) AS tup
        FROM `system`.one
    ) AS js1
GLOBAL ANY FULL JOIN (
        SELECT
            dummy AS a,
            (toUInt8(0), toUInt8(0)) AS tup
        FROM `system`.one
    ) AS js2
    USING (a, tup);