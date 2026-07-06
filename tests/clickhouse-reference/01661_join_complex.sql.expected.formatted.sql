SELECT *
FROM
    (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t1
INNER JOIN (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t2
    ON t1.b = t2.b
    AND t1.c = t2.b
    AND t1.d = t2.b
    OR t1.e = t2.e;

SELECT *
FROM
    (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t1
INNER JOIN (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t2
    ON t1.d = t2.b
    OR t1.c = t2.b
    OR t1.d = t2.b
    AND t1.d = t2.b
    OR t1.e = t2.e
    AND t1.a = t2.a
    AND t2.f = t1.f;

SELECT *
FROM
    (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t1
LEFT JOIN (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t2
    ON t1.d = t2.b
    OR t1.c = t2.b
    OR t1.d = t2.b
    AND t1.d = t2.b
    OR t1.e = t2.e
    AND t1.a = t2.a
    AND t2.f = t1.f;

SELECT *
FROM
    (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t1
RIGHT JOIN (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t2
    ON t1.d = t2.b
    OR t1.c = t2.b
    OR t1.e = t2.e;

SELECT *
FROM
    (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t1
INNER JOIN (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t2
    ON t1.d = t2.b
    OR t1.c = t2.b
    OR t1.e = t2.e
    AND t1.a = t2.a
    AND t2.f = t1.f;

SELECT *
FROM
    (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t1
INNER JOIN (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t2
    ON t1.d = t2.b
    AND t1.e = t2.e
    OR t1.c = t2.b
    AND t1.e = t2.e
    OR t1.d = t2.b
    AND t1.f = t2.f
    OR t1.c = t2.b
    AND t1.f = t2.f;

SELECT *
FROM
    (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t1
INNER JOIN (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t2
    ON or(t1.d = t2.b
    AND t1.e = t2.e, t1.d = t2.b
    AND t1.f = t2.f, t1.c = t2.b
    AND t1.e = t2.e, t1.c = t2.b
    AND t1.f = t2.f);

SELECT *
FROM
    (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t1
INNER JOIN (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t2
    ON t1.d = t2.b
    AND t1.e = t2.e
    OR t1.d = t2.b
    AND t1.f = t2.f
    OR t1.c = t2.b
    AND t1.e = t2.e
    OR t1.c = t2.b
    AND t1.f = t2.f;

SELECT 'left ---';

SELECT *
FROM
    (
        SELECT
            '1' AS a,
            'X' AS b,
            'Y' AS c,
            'Z' AS d,
            'W' AS e,
            'V1' AS f
        UNION ALL
        SELECT
            '2',
            'A',
            'B',
            'C',
            'D',
            'E1'
        UNION ALL
        SELECT
            '3',
            'F',
            'G',
            'H',
            'I',
            'J1'
    ) AS t1
LEFT JOIN (
        SELECT
            '1' AS a,
            'X' AS b,
            'P' AS c,
            'Z' AS d,
            'W' AS e,
            'V1' AS f
        UNION ALL
        SELECT
            '2',
            'B',
            'Q',
            'C',
            'D',
            'E1'
        UNION ALL
        SELECT
            '4',
            'L',
            'M',
            'N',
            'O',
            'P1'
    ) AS t2
    ON (t1.d = t2.b
    OR t1.c = t2.b
    OR t1.d = t2.b
    AND t1.d = t2.b)
    OR t1.e = t2.e
    AND t1.a = t2.a
    AND t2.f = t1.f
ORDER BY `ALL` ASC
SETTINGS
    enable_analyzer = '1',
    query_plan_use_new_logical_join_step = '1';

SELECT 'right ---';

SELECT *
FROM
    (
        SELECT
            '1' AS a,
            'X' AS b,
            'Y' AS c,
            'Z' AS d,
            'W' AS e,
            'V1' AS f
        UNION ALL
        SELECT
            '2',
            'A',
            'B',
            'C',
            'D',
            'E1'
        UNION ALL
        SELECT
            '3',
            'F',
            'G',
            'H',
            'I',
            'J1'
    ) AS t1
RIGHT JOIN (
        SELECT
            '1' AS a,
            'X' AS b,
            'P' AS c,
            'Z' AS d,
            'W' AS e,
            'V1' AS f
        UNION ALL
        SELECT
            '2',
            'B',
            'Q',
            'C',
            'D',
            'E1'
        UNION ALL
        SELECT
            '4',
            'L',
            'M',
            'N',
            'O',
            'P1'
    ) AS t2
    ON (t1.d = t2.b
    OR t1.c = t2.b)
    OR t1.e = t2.e
ORDER BY `ALL` ASC
SETTINGS
    enable_analyzer = '1',
    query_plan_use_new_logical_join_step = '1';

SELECT 'inner ---';

SELECT *
FROM
    (
        SELECT
            '1' AS a,
            'X' AS b,
            'Y' AS c,
            'Z' AS d,
            'W' AS e,
            'V1' AS f
        UNION ALL
        SELECT
            '2',
            'A',
            'B',
            'C',
            'D',
            'E1'
        UNION ALL
        SELECT
            '3',
            'F',
            'G',
            'H',
            'I',
            'J1'
    ) AS t1
INNER JOIN (
        SELECT
            '1' AS a,
            'X' AS b,
            'P' AS c,
            'Z' AS d,
            'W' AS e,
            'V1' AS f
        UNION ALL
        SELECT
            '2',
            'B',
            'Q',
            'C',
            'D',
            'E1'
        UNION ALL
        SELECT
            '4',
            'L',
            'M',
            'N',
            'O',
            'P1'
    ) AS t2
    ON (t1.d = t2.b
    OR t1.c = t2.b)
    OR t1.e = t2.e
    AND t1.a = t2.a
    AND t2.f = t1.f
ORDER BY `ALL` ASC
SETTINGS
    enable_analyzer = '1',
    query_plan_use_new_logical_join_step = '1';

SELECT *
FROM
    (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t1
LEFT JOIN (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t2
    ON (t1.d = t2.b
    OR t1.c = t2.b
    OR t1.d = t2.b
    AND t1.d = t2.b)
    OR t1.e = t2.e
    AND t1.a = t2.a
    AND t2.f = t1.f
ORDER BY `ALL` ASC
SETTINGS
    enable_analyzer = '1',
    query_plan_use_new_logical_join_step = '0';

SELECT *
FROM
    (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t1
RIGHT JOIN (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t2
    ON (t1.d = t2.b
    OR t1.c = t2.b)
    OR t1.e = t2.e
ORDER BY `ALL` ASC
SETTINGS
    enable_analyzer = '1',
    query_plan_use_new_logical_join_step = '0';

SELECT *
FROM
    (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t1
INNER JOIN (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t2
    ON (t1.d = t2.b
    OR t1.c = t2.b)
    OR t1.e = t2.e
    AND t1.a = t2.a
    AND t2.f = t1.f
ORDER BY `ALL` ASC
SETTINGS
    enable_analyzer = '1',
    query_plan_use_new_logical_join_step = '0';

SELECT *
FROM
    (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t1
INNER JOIN (
        SELECT
            'a' AS a,
            'b' AS b,
            'c' AS c,
            'd' AS d,
            'e' AS e,
            'f' AS f
    ) AS t2
    ON (t1.d = t2.b
    OR t1.c = t2.b)
    AND (t1.e = t2.e
    OR t1.f = t2.f)
SETTINGS enable_analyzer = '1';

SET joined_subquery_requires_alias = '0';

SET max_threads = '1';

DROP TABLE IF EXISTS tab2;

DROP TABLE IF EXISTS tab3;

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

INSERT INTO tab2;

INSERT INTO tab2;

INSERT INTO tab3;

INSERT INTO tab3;

INSERT INTO tab3;

SELECT
    a2,
    b2,
    a3,
    b3
FROM
    tab2
ANY LEFT JOIN tab3
    ON a2 = a3
    AND a2 + 1 = b3 + 0
    OR b2 = b3
    AND a2 + 1 = b3 + 0
ORDER BY `ALL` ASC;

DROP TABLE tab2;

DROP TABLE tab3;