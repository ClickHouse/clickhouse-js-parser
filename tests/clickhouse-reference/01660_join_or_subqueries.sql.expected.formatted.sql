SET joined_subquery_requires_alias = '0';

SET max_threads = '1';

DROP TABLE IF EXISTS tab1;

DROP TABLE IF EXISTS tab2;

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

INSERT INTO tab1;

INSERT INTO tab2;

INSERT INTO tab2;

SELECT a1
FROM
    tab1
ANY LEFT JOIN (
        SELECT *
        FROM tab2
    )
    ON b1 = a2
    OR b2 = a1;

SELECT a1
FROM
    tab1
ANY LEFT JOIN (
        SELECT
            a2,
            b2
        FROM tab2
    )
    ON b1 = a2
    OR b2 = a1;

SELECT
    a1,
    b1
FROM
    tab1
ANY LEFT JOIN (
        SELECT *
        FROM tab2
    )
    ON b1 = a2
    OR b2 = a1;

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
    ON b1 + 1 = z + 1
    OR b1 = z * 2;

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
    ON b1 + 1 = z
    OR b1 = z * 2;

DROP TABLE tab1;

DROP TABLE tab2;