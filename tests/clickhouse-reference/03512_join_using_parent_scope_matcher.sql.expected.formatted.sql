#!/usr/bin/env -S ${HOME}/clickhouse-client --queries-file
DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1
(
    b Float64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO t1;

CREATE TABLE t2
(
    a UInt32
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO t2;

SET enable_analyzer = '1';

SET analyzer_compatibility_join_using_top_level_identifier = '1';

SELECT
    * APPLY(x -> x + 1),
    b + 1 AS a
FROM
    t1
INNER JOIN t2
    USING (a)
ORDER BY `ALL` ASC;

SELECT
    t1.* APPLY(x -> x + 1),
    b + 1 AS a
FROM
    t1
INNER JOIN t2
    USING (a)
ORDER BY `ALL` ASC;

SELECT
    t2.* APPLY(x -> x + 1),
    b + 1 AS a
FROM
    t1
INNER JOIN t2
    USING (a)
ORDER BY `ALL` ASC;

SELECT
    (*, 1),
    b + 1 AS a,
    b + 1 AS a
FROM
    t1
INNER JOIN t2
    USING (a)
ORDER BY `ALL` ASC;