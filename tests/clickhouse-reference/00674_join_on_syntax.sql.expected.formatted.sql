SET joined_subquery_requires_alias = '0';

SET enable_analyzer = '1';

DROP TABLE IF EXISTS tab1;

DROP TABLE IF EXISTS tab2;

DROP TABLE IF EXISTS tab3;

DROP TABLE IF EXISTS tab1_copy;

CREATE TABLE tab1
(
    a1 Int32,
    b1 Int32
)
ENGINE = MergeTree()
ORDER BY a1;

CREATE TABLE tab2
(
    a2 Int32,
    b2 Int32
)
ENGINE = MergeTree()
ORDER BY a2;

CREATE TABLE tab3
(
    a3 Int32,
    b3 Int32
)
ENGINE = MergeTree()
ORDER BY a3;

CREATE TABLE tab1_copy
(
    a1 Int32,
    b1 Int32
)
ENGINE = MergeTree()
ORDER BY a1;

INSERT INTO tab1;

INSERT INTO tab2;

INSERT INTO tab3;

INSERT INTO tab1_copy;

SELECT a1
FROM
    tab1
ANY LEFT JOIN tab2
    ON b1 = a2;

SELECT
    a1,
    b1
FROM
    tab1
ANY LEFT JOIN tab2
    ON b1 = a2;

SELECT
    a1,
    a2
FROM
    tab1
ANY LEFT JOIN tab2
    ON b1 = a2;

SELECT
    a1,
    b2
FROM
    tab1
ANY LEFT JOIN tab2
    ON b1 = a2;

SELECT
    a1,
    a2,
    b2
FROM
    tab1
ANY LEFT JOIN tab2
    ON b1 = a2;

SELECT b1
FROM
    tab1
ANY LEFT JOIN tab2
    ON toInt32(a1 + 1) = a2;

SELECT
    b1,
    a2
FROM
    tab1
ANY LEFT JOIN tab2
    ON toInt32(a1 + 1) = a2;

SELECT
    b1,
    b2
FROM
    tab1
ANY LEFT JOIN tab2
    ON toInt32(a1 + 1) = a2;

SELECT a1
FROM
    tab1
ANY LEFT JOIN tab2
    ON b1 + 1 = a2 + 1;

SELECT a2
FROM
    tab1
ANY LEFT JOIN tab2
    ON b1 + 1 = a2 + 1;

SELECT
    a1,
    b1,
    a2,
    b2
FROM
    tab1
ANY LEFT JOIN tab2
    ON b1 + 1 = a2 + 1;

SELECT
    a1,
    b1,
    a2,
    b2,
    a2 + 1
FROM
    tab1
ANY LEFT JOIN tab2
    ON b1 + 1 = a2 + 1;

SELECT
    a1,
    b1,
    a2,
    b2
FROM
    tab1
ANY LEFT JOIN tab2
    ON a1 + 4 = b2 + 2;

SELECT
    a2,
    b2
FROM
    tab2
ANY LEFT JOIN tab3
    ON a2 = a3
    AND b2 = b3;

SELECT
    a3,
    b3
FROM
    tab2
ANY LEFT JOIN tab3
    ON a2 = a3
    AND b2 = b3;

SELECT
    a2,
    b2,
    a3,
    b3
FROM
    tab2
ANY LEFT JOIN tab3
    ON a2 = a3
    AND b2 = b3;

SELECT a1
FROM
    tab1
ANY LEFT JOIN tab2
    ON b1 + 1 = a2 + 1
    AND a1 + 4 = b2 + 2;

SELECT
    a1,
    b2
FROM
    tab1
ANY LEFT JOIN tab2
    ON b1 + 1 = a2 + 1
    AND a1 + 4 = b2 + 2;

SELECT
    a1,
    b1,
    a2,
    b2
FROM
    tab1
ANY LEFT JOIN tab2
    ON b1 + 1 = a2 + 1
    AND a1 + 4 = b2 + 2;

SELECT
    a2,
    b2 + 1
FROM
    tab1
ANY LEFT JOIN tab2
    ON b1 + 1 = a2 + 1
    AND a1 + 4 = b2 + 2;

SELECT
    a1,
    a2,
    b1,
    b2
FROM
    tab1 AS `first`
ANY LEFT JOIN tab2 AS second_
    ON `first`.b1 = second_.a2;

SELECT
    a1,
    a2,
    b1,
    b2
FROM
    tab1 AS `first`
ANY LEFT JOIN tab2 AS second_
    ON second_.a2 = `first`.b1;

SELECT
    a1,
    a2,
    b1,
    b2
FROM
    tab1 AS `first`
ANY LEFT JOIN tab2 AS second_
    ON tab1.b1 = tab2.a2;

SELECT
    a1,
    a2,
    b1,
    b2
FROM
    tab1 AS `first`
ANY LEFT JOIN tab2 AS second_
    ON tab2.a2 = tab1.b1;

SELECT
    a1,
    a2,
    b1,
    b2
FROM
    tab1 AS `first`
ANY LEFT JOIN tab2 AS second_
    ON `first`.b1 = tab2.a2;

SELECT
    a1,
    a2,
    b1,
    b2
FROM
    tab1 AS `first`
ANY LEFT JOIN tab2 AS second_
    ON tab2.a2 = `first`.b1;

SELECT
    a1,
    a2,
    b1,
    b2
FROM
    tab1 AS `first`
ANY LEFT JOIN tab2 AS second_
    ON tab1.b1 = second_.a2;

SELECT
    a1,
    a2,
    b1,
    b2
FROM
    tab1 AS `first`
ANY LEFT JOIN tab2 AS second_
    ON second_.a2 = tab1.b1;

SELECT
    a1,
    a2,
    `first`.b1,
    second_.b2
FROM
    tab1 AS `first`
ANY LEFT JOIN tab2 AS second_
    ON b1 = a2;

SELECT
    a1,
    a2,
    tab1.b1,
    tab2.b2
FROM
    tab1 AS `first`
ANY LEFT JOIN tab2 AS second_
    ON b1 = a2;

SELECT
    a2,
    b2
FROM
    tab2
ANY LEFT JOIN tab3
    ON a2 + b2 = a3 + b3;

SELECT
    a2,
    b2
FROM
    tab2
ANY LEFT JOIN tab3
    ON a3 + tab3.b3 = a2 + b2;

SELECT
    a2,
    b2
FROM
    tab2 AS second_
ANY LEFT JOIN tab3
    ON a3 + b3 = a2 + second_.b2;

SELECT
    a2,
    b2
FROM
    tab2 AS second_
ANY LEFT JOIN tab3 AS third
    ON third.a3 + tab3.b3 = tab2.a2 + second_.b2;

SELECT
    a1,
    tab1_copy.a1
FROM
    tab1
ANY LEFT JOIN tab1_copy
    ON tab1.b1 + 3 = tab1_copy.b1 + 2
FORMAT JSONEachRow;

SELECT
    a1,
    copy.a1
FROM
    tab1
ANY LEFT JOIN tab1_copy AS copy
    ON tab1.b1 + 3 = tab1_copy.b1 + 2
FORMAT JSONEachRow;

SELECT
    a1,
    tab1_copy.a1
FROM
    tab1
ANY LEFT JOIN tab1_copy AS copy
    ON tab1.b1 + 3 = tab1_copy.b1 + 2
FORMAT JSONEachRow;

SELECT a1
FROM
    tab1
ANY LEFT JOIN (
        SELECT *
        FROM tab2
    )
    ON b1 = a2;

SELECT a1
FROM
    tab1
ANY LEFT JOIN (
        SELECT a2
        FROM tab2
    )
    ON b1 = a2;

SELECT
    a1,
    b1
FROM
    tab1
ANY LEFT JOIN (
        SELECT *
        FROM tab2
    )
    ON b1 = a2;

SELECT
    a1,
    b1,
    a2,
    b2
FROM
    tab1
ANY LEFT JOIN (
        SELECT *
        FROM tab2
    )
    ON b1 = a2;

SELECT
    a1,
    a2
FROM
    tab1
ANY LEFT JOIN (
        SELECT a2
        FROM tab2
    )
    ON b1 = a2;

SELECT b1
FROM
    tab1
ANY LEFT JOIN (
        SELECT *
        FROM tab2
    )
    ON toInt32(a1 + 1) = a2;

SELECT
    a1,
    b1,
    a2,
    b2
FROM
    tab1
ANY LEFT JOIN (
        SELECT *
        FROM tab2
    )
    ON b1 + 1 = a2 + 1;

SELECT
    a1,
    b1,
    a2
FROM
    tab1
ANY LEFT JOIN (
        SELECT *
        FROM tab2
    )
    ON b1 + 1 = a2 + 1;

SELECT
    a1,
    b1,
    a2,
    b2
FROM
    tab1
ANY LEFT JOIN (
        SELECT
            *,
            a2 AS z
        FROM tab2
    )
    ON b1 + 1 = z + 1;

SELECT
    a1,
    b1,
    a2,
    b2
FROM
    tab1
ANY LEFT JOIN (
        SELECT
            *,
            a2 + 1 AS z
        FROM tab2
    )
    ON b1 + 1 = z;

SELECT
    a1,
    b1,
    a2,
    b2
FROM
    tab1
ANY LEFT JOIN (
        SELECT
            *,
            a2 + 1 AS z
        FROM tab2
    )
    ON b1 + 2 = z + 1
FORMAT TSV;

SELECT
    a1,
    a2,
    b1,
    b2
FROM
    tab1 AS `first`
ANY LEFT JOIN (
        SELECT *
        FROM tab2
    ) AS second_
    ON `first`.b1 = second_.a2;

SELECT
    a1,
    a2,
    b1,
    b2
FROM
    tab1 AS `first`
ANY LEFT JOIN (
        SELECT
            *,
            a2 AS z
        FROM tab2
    ) AS second_
    ON `first`.b1 = second_.z;

SELECT
    a1,
    a2,
    b1,
    b2
FROM
    tab1 AS `first`
ANY LEFT JOIN (
        SELECT
            *,
            a2 + 1 AS z
        FROM tab2
    ) AS second_
    ON `first`.b1 + 1 = second_.z;

SELECT
    tab1.a1,
    a2,
    tab1.b1,
    second_.b2
FROM
    tab1 AS `first`
ANY LEFT JOIN (
        SELECT *
        FROM tab2
    ) AS second_
    ON `first`.b1 = second_.a2;

SELECT
    a1,
    s.a1
FROM
    tab1
ANY LEFT JOIN (
        SELECT *
        FROM tab1_copy
    ) AS s
    ON tab1.b1 + 3 = s.b1 + 2
FORMAT JSONEachRow;

DROP TABLE tab1;

DROP TABLE tab1_copy;

DROP TABLE tab2;

DROP TABLE tab3;