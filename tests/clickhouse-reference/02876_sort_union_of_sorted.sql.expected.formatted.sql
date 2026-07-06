DROP TABLE IF EXISTS table1;

DROP TABLE IF EXISTS table2;

CREATE TABLE table1
(
    number UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE table2
(
    number UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO table1 SELECT number
FROM numbers_mt(1, 10);

INSERT INTO table2 SELECT number
FROM numbers_mt(11, 10);

SELECT *
FROM (
        SELECT *
        FROM table1
        ORDER BY number ASC
        UNION ALL
        SELECT *
        FROM table2
        ORDER BY number ASC
    )
ORDER BY number ASC;

SELECT *
FROM (
        SELECT *
        FROM table1
        ORDER BY number ASC
        UNION ALL
        SELECT *
        FROM table2
        ORDER BY number ASC
    )
ORDER BY number DESC;

SELECT *
FROM (
        SELECT *
        FROM table1
        ORDER BY number DESC
        UNION ALL
        SELECT *
        FROM table2
        ORDER BY number DESC
    )
ORDER BY number DESC;

DROP TABLE table1;

DROP TABLE table2;