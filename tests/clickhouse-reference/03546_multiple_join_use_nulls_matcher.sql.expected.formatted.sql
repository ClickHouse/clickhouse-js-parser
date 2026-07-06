DROP TABLE IF EXISTS tableA;

DROP TABLE IF EXISTS tableB;

DROP TABLE IF EXISTS tableC;

CREATE TABLE tableA
(
    key String
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tableB
(
    key String,
    value2 Int32
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE tableC
(
    key String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tableA;

INSERT INTO tableB;

INSERT INTO tableC;

SET enable_analyzer = '1';

SET join_use_nulls = '1';

SELECT
    value2 = 1 AS x,
    toTypeName(x)
FROM (
        SELECT *
        FROM
            tableA
        LEFT JOIN tableB
            ON tableB.key = tableA.key
        LEFT JOIN tableC AS t
            ON tableB.key = t.key
    )
ORDER BY 1 ASC;

SELECT
    value2 = 1 AS x,
    toTypeName(x)
FROM (
        SELECT tableB.*
        FROM
            tableA
        LEFT JOIN tableB
            ON tableB.key = tableA.key
        LEFT JOIN tableC AS t
            ON tableB.key = t.key
    )
ORDER BY 1 ASC;

SELECT
    value2 = 1 AS x,
    toTypeName(x)
FROM (
        SELECT tableB.*
        FROM
            tableA
        INNER JOIN tableB
            ON tableB.key = tableA.key
        LEFT JOIN tableC AS t
            ON tableB.key = t.key
    )
ORDER BY 1 ASC;

SELECT
    value2 = 1 AS x,
    toTypeName(x)
FROM (
        SELECT tableB.*
        FROM
            tableA
        INNER JOIN tableB
            ON tableB.key = tableA.key
        RIGHT JOIN tableC AS t
            ON tableB.key = t.key
    )
ORDER BY 1 ASC;