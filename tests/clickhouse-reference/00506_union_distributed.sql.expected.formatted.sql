-- Tags: distributed
-- https://github.com/ClickHouse/ClickHouse/issues/1059
SET distributed_foreground_insert = '1';

DROP TABLE IF EXISTS union1;

DROP TABLE IF EXISTS union2;

DROP TABLE IF EXISTS union3;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE union1
(
    date Date,
    a Int32,
    b Int32,
    c Int32,
    d Int32
)
ENGINE = MergeTree(date, (a, date), 8192);

CREATE TABLE union2
(
    date Date,
    a Int32,
    b Int32,
    c Int32,
    d Int32
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), 'union1');

CREATE TABLE union3
(
    date Date,
    a Int32,
    b Int32,
    c Int32,
    d Int32
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), 'union2');

INSERT INTO union1;

INSERT INTO union1;

INSERT INTO union2;

INSERT INTO union3;

SELECT
    b,
    sum(c)
FROM (
        SELECT
            a,
            b,
            sum(c) AS c
        FROM union2
        WHERE a > 1
        GROUP BY
            a,
            b
        UNION ALL
        SELECT
            a,
            b,
            sum(c) AS c
        FROM union2
        WHERE b > 1
        GROUP BY
            a,
            b
        ORDER BY
            a ASC,
            b ASC
    ) AS a
GROUP BY b
ORDER BY b ASC;

SELECT
    b,
    sum(c)
FROM (
        SELECT
            a,
            b,
            sum(c) AS c
        FROM union1
        WHERE a > 1
        GROUP BY
            a,
            b
        UNION ALL
        SELECT
            a,
            b,
            sum(c) AS c
        FROM union2
        WHERE b > 1
        GROUP BY
            a,
            b
        ORDER BY
            a ASC,
            b ASC
    ) AS a
GROUP BY b
ORDER BY b ASC;

SELECT
    b,
    sum(c)
FROM (
        SELECT
            a,
            b,
            sum(c) AS c
        FROM union1
        WHERE a > 1
        GROUP BY
            a,
            b
        UNION ALL
        SELECT
            a,
            b,
            sum(c) AS c
        FROM union1
        WHERE b > 1
        GROUP BY
            a,
            b
        ORDER BY
            a ASC,
            b ASC
    ) AS a
GROUP BY b
ORDER BY b ASC;

SELECT
    b,
    sum(c)
FROM (
        SELECT
            a,
            b,
            sum(c) AS c
        FROM union2
        WHERE a > 1
        GROUP BY
            a,
            b
        UNION ALL
        SELECT
            a,
            b,
            sum(c) AS c
        FROM union3
        WHERE b > 1
        GROUP BY
            a,
            b
        ORDER BY
            a ASC,
            b ASC
    ) AS a
GROUP BY b
ORDER BY b ASC;

DROP TABLE union1;

DROP TABLE union2;

DROP TABLE union3;