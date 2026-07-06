DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1
(
    key UInt32,
    val UInt32
)
ENGINE = Memory();

INSERT INTO t1;

CREATE TABLE t2
(
    key UInt32,
    val UInt32
)
ENGINE = Memory();

INSERT INTO t2;

SET join_algorithm = 'full_sorting_merge';

SELECT *
FROM
    t1
INNER JOIN t2
    ON t1.key = t2.key
    OR t1.val = t2.key; -- { serverError NOT_IMPLEMENTED }

SELECT *
FROM
    t1
ANTI LEFT JOIN t2
    ON t1.key = t2.key; -- { serverError NOT_IMPLEMENTED }

SELECT *
FROM
    t1
SEMI LEFT JOIN t2
    ON t1.key = t2.key; -- { serverError NOT_IMPLEMENTED }

SELECT *
FROM
    t1
ANY INNER JOIN t2
    ON t1.key = t2.key
SETTINGS any_join_distinct_right_table_keys = '1'; -- { serverError NOT_IMPLEMENTED }

SELECT *
FROM
    (
        SELECT
            key,
            sum(val) AS val
        FROM t1
        GROUP BY key
        WITH TOTALS
    ) AS t1
INNER JOIN (
        SELECT
            key,
            sum(val) AS val
        FROM t2
        GROUP BY key
        WITH TOTALS
    ) AS t2
    ON t1.key = t2.key; -- { serverError NOT_IMPLEMENTED }

SELECT *
FROM
    t1
INNER JOIN (
        SELECT
            key,
            sum(val) AS val
        FROM t2
        GROUP BY key
        WITH TOTALS
    ) AS t2
    ON t1.key = t2.key; -- { serverError NOT_IMPLEMENTED }

SELECT *
FROM
    (
        SELECT
            key,
            sum(val) AS val
        FROM t1
        GROUP BY key
        WITH TOTALS
    ) AS t1
INNER JOIN t2
    ON t1.key = t2.key; -- { serverError NOT_IMPLEMENTED }

SELECT *
FROM
    t1
FULL JOIN t2
    ON t1.key = t2.key
    AND t2.key > 0; -- { serverError NOT_IMPLEMENTED }

SELECT *
FROM
    t1
FULL JOIN t2
    ON t1.key = t2.key
    AND t1.key > 0; -- { serverError NOT_IMPLEMENTED }