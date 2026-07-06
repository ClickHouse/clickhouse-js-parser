SET joined_subquery_requires_alias = '0';

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

INSERT INTO tab2;

INSERT INTO tab3;

INSERT INTO tab3;

INSERT INTO tab3;

INSERT INTO tab3;

SET max_threads = '1';

SET any_join_distinct_right_table_keys = '0';

SELECT
    tab2.*,
    tab3.*
FROM
    tab2
ANY INNER JOIN tab3
    ON a2 = a3
    OR b2 = b3
ORDER BY `ALL` ASC;

SELECT
    tab2.*,
    tab3.*
FROM
    tab2
ANY INNER JOIN tab3
    ON b2 = b3
    OR a2 = a3
ORDER BY `ALL` ASC;

SET any_join_distinct_right_table_keys = '1';

SELECT 1
FROM
    (
        SELECT
            1 AS a,
            1 AS aa,
            1 AS aaa,
            1 AS aaaa
    ) AS A
INNER JOIN (
        SELECT
            1 AS b,
            1 AS bb,
            1 AS bbb,
            1 AS bbbb,
            1 AS bbbbb
    ) AS B
    ON a = b
    OR a = bb
    OR a = bbb
    OR a = bbbb
    OR aa = b
    OR aa = bb
    OR aa = bbb
    OR aa = bbbb
    OR aaa = b
    OR aaa = bb
    OR aaa = bbb
    OR aaa = bbbb
    OR aaaa = b
    OR aaaa = bb
    OR aaaa = bbb
    OR aaaa = bbbb
    OR a = bbbbb
    OR aa = bbbbb;

DROP TABLE tab2;

DROP TABLE tab3;