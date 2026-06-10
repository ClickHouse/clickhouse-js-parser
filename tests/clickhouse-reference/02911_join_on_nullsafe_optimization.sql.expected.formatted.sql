DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

DROP TABLE IF EXISTS t1n;

DROP TABLE IF EXISTS t2n;

CREATE TABLE t1
(
    x Nullable(Int64),
    y Nullable(UInt64)
)
ENGINE = TinyLog();

CREATE TABLE t2
(
    x Nullable(Int64),
    y Nullable(UInt64)
)
ENGINE = TinyLog();

INSERT INTO t1;

INSERT INTO t2;

CREATE TABLE t1n
(
    x Int64,
    y UInt64
)
ENGINE = TinyLog();

CREATE TABLE t2n
(
    x Int64,
    y UInt64
)
ENGINE = TinyLog();

INSERT INTO t1n;

INSERT INTO t2n;

SET enable_analyzer = '1';

-- { echoOn }
SELECT *
FROM
    t1
INNER JOIN t2
    ON t1.x <=> t2.x
    OR t1.x IS NULL
    AND t2.x IS NULL
ORDER BY t1.x ASC NULLS LAST;

SELECT *
FROM
    t1
INNER JOIN t2
    ON (t1.x <=> t2.x
    OR t1.x IS NULL
    AND t2.x IS NULL)
    OR t1.y <=> t2.y
ORDER BY t1.x ASC NULLS LAST;

SELECT *
FROM
    t1
INNER JOIN t2
    ON t1.x = t2.x
    OR t1.x IS NULL
    AND t2.x IS NULL
ORDER BY t1.x ASC;

SELECT *
FROM
    t1
INNER JOIN t2
    ON t1.x <=> t2.x
    AND (t1.x = t1.y
    OR t1.x IS NULL
    AND t1.y IS NULL)
ORDER BY t1.x ASC;

SELECT *
FROM
    t1
INNER JOIN t2
    ON (t1.x = t2.x
    OR t1.x IS NULL
    AND t2.x IS NULL)
    AND t1.y <=> t2.y
ORDER BY t1.x ASC NULLS LAST;

SELECT *
FROM
    t1
INNER JOIN t2
    ON t1.x <=> t2.x
    OR t1.y <=> t2.y
    OR t1.x IS NULL
    AND t2.x IS NULL
    OR t1.y IS NULL
    AND t2.y IS NULL
ORDER BY t1.x ASC NULLS LAST;

SELECT *
FROM
    t1
INNER JOIN t2
    ON (t1.x <=> t2.x
    OR t1.x IS NULL
    AND t2.x IS NULL)
    AND (t1.y = t2.y
    OR t1.y IS NULL
    AND t2.y IS NULL)
    AND COALESCE(t1.x, 0) != 2
ORDER BY t1.x ASC NULLS LAST;

SELECT x = y
    OR x IS NULL
    AND y IS NULL
FROM t1
ORDER BY x ASC NULLS LAST;

SELECT *
FROM
    t1
INNER JOIN t2
    ON t1.x = t2.x
    AND (t2.x IS NOT NULL
    AND t1.x IS NOT NULL)
    OR t2.x IS NULL
    AND t1.x IS NULL
ORDER BY t1.x ASC NULLS LAST;

SELECT *
FROM
    t1
INNER JOIN t2
    ON t1.x = t2.x
    AND (t2.x IS NOT NULL
    AND t1.x IS NOT NULL)
    OR t2.x != t1.x
    AND t2.x IS NULL
    AND t1.x IS NULL
ORDER BY t1.x ASC NULLS LAST;

SELECT *
FROM
    t1
INNER JOIN t2
    ON t1.x = t2.x
    AND (t2.x IS NOT NULL
    AND t1.x IS NOT NULL)
    OR t2.x != t1.x
    AND t2.x != t1.x
ORDER BY `ALL` ASC NULLS LAST
SETTINGS query_plan_use_new_logical_join_step = '0';

SELECT *
FROM
    t1
INNER JOIN t2
    ON t1.x = t2.x
    AND (t2.x IS NOT NULL
    AND t1.x IS NOT NULL)
    OR t2.x != t1.x
    AND t2.x IS NULL
    AND t2.x IS NULL
ORDER BY t1.x ASC NULLS LAST
SETTINGS
    query_plan_use_new_logical_join_step = '0',
    use_join_disjunctions_push_down = '0';

-- aliases defined in the join condition are valid
SELECT
    *,
    e,
    e2
FROM
    t1
FULL JOIN t2
    ON (t1.x = t2.x AS e)
    AND (t2.x IS NOT NULL
    AND t1.x IS NOT NULL)
    OR t2.x IS NULL
    AND t1.x IS NULL AS e2
ORDER BY
    t1.x ASC NULLS LAST,
    t2.x ASC NULLS LAST;

SELECT
    *,
    e,
    e2
FROM
    t1
FULL JOIN t2
    ON (t1.x = t2.x AS e)
    AND (t2.x IS NOT NULL
    AND t1.x IS NOT NULL) AS e2
ORDER BY
    t1.x ASC NULLS LAST,
    t2.x ASC NULLS LAST;

-- check for non-nullable columns for which `is null` is replaced with constant
SELECT *
FROM
    t1n AS t1
INNER JOIN t2n AS t2
    ON t1.x = t2.x
    AND (t2.x IS NOT NULL
    AND t1.x IS NOT NULL)
    OR t2.x IS NULL
    AND t1.x IS NULL
ORDER BY t1.x ASC NULLS LAST;

-- { echoOff }
SELECT '--';

-- IS NOT NULL and constants are optimized out
SELECT count()
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN QUERY TREE', '', (
                SELECT *
                FROM
                    t1
                INNER JOIN t2
                    ON t1.x = t2.x
                    AND t1.x IS NOT NULL
                    AND true
                    AND t2.x IS NOT NULL
            ))
    )
WHERE `explain` LIKE '%CONSTANT%'
    OR `explain` ILIKE '%is%null%';

SELECT count()
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN QUERY TREE', '', (
                SELECT *
                FROM
                    t1
                INNER JOIN t2
                    ON t1.x = t2.x
                    AND true
            ))
    )
WHERE `explain` LIKE '%CONSTANT%'
    OR `explain` ILIKE '%is%null%';

-- this is not optimized out
SELECT count()
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN QUERY TREE', '', (
                SELECT *
                FROM
                    t1
                INNER JOIN t2
                    ON t1.x <=> t2.x
                    OR t1.x IS NULL
                    AND t1.y <=> t2.y
                    AND t2.x IS NULL
            ))
    )
WHERE `explain` LIKE '%CONSTANT%'
    OR `explain` ILIKE '%is%null%';

SELECT count()
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN QUERY TREE', '', (
                SELECT *
                FROM
                    t1
                INNER JOIN t2
                    ON t1.x <=> t2.x
                    AND (t1.x = t1.y
                    OR t1.x IS NULL
                    AND t1.y IS NULL)
            ))
    )
WHERE `explain` LIKE '%CONSTANT%'
    OR `explain` ILIKE '%is%null%';

SELECT count()
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN QUERY TREE', '', (
                SELECT *
                FROM
                    t1
                INNER JOIN t2
                    ON t1.x = t2.x
                    AND NOT(t1.x = 1
                    OR t1.x IS NULL)
            ))
    )
WHERE `explain` ILIKE '%function_name: isNull%';