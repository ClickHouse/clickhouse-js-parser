-- Test: Disjunctions pushdown into JOIN branches
-- This test exercises the optimizer controlled by the setting `use_join_disjunctions_push_down`.
-- It checks that disjunctions (OR) over conjunctions can be split and pushed as per-side
-- pre-join filters without changing query results, and that when the optimization is disabled
-- such pre-join filters are not produced. It also validates join-order-dependent pushdown
SET enable_analyzer = '1';

SET enable_join_runtime_filters = '0';

DROP TABLE IF EXISTS tp1;

DROP TABLE IF EXISTS tp2;

CREATE TABLE tp1
(
    k Int32,
    a Int32
)
ENGINE = MergeTree()
ORDER BY k;

CREATE TABLE tp2
(
    k Int32,
    x Int32
)
ENGINE = MergeTree()
ORDER BY k;

INSERT INTO tp1;

INSERT INTO tp2;

-- We need to make sure that query plan creates the JOIN filter only with the optimization enabled, and WHERE filter in both cases
---------- CASE A ----------
SELECT '--- CASE A: plan (enabled) ---';

SET use_join_disjunctions_push_down = '1';

SELECT REGEXP_REPLACE(trimLeft(`explain`), '__set_Int32_\\d+_\\d+', '__set_Int32_UNIQ_ID')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT
                    t1.k,
                    t1.a,
                    t2.x
                FROM
                    tp1 AS t1
                INNER JOIN tp2 AS t2
                    ON t1.k = t2.k
                WHERE t1.k IN (1, 2)
                    AND t2.x = 100
                    OR t1.k IN (3, 4)
                    AND t2.x = 200
                ORDER BY t1.k ASC
            ))
    )
WHERE `explain` ILIKE '%Filter column: %'
SETTINGS enable_parallel_replicas = '0'
FORMAT TSV;

SET use_join_disjunctions_push_down = '0';

SELECT
    t1.k,
    t1.a,
    t2.x
FROM
    tp1 AS t1
INNER JOIN tp2 AS t2
    ON t1.k = t2.k
WHERE t1.k IN (1, 2)
    AND t2.x = 100
    OR t1.k IN (3, 4)
    AND t2.x = 200
ORDER BY t1.k ASC;

SELECT REGEXP_REPLACE(trimLeft(`explain`), '__set_Int32_\\d+_\\d+', '__set_Int32_UNIQ_ID')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT
                    t1.k,
                    t1.a,
                    t2.x
                FROM
                    tp1 AS t1
                INNER JOIN tp2 AS t2
                    ON t1.k = t2.k
                WHERE t2.x = 100
                    OR t2.x = 200
                ORDER BY t1.k ASC
            ))
    )
WHERE `explain` ILIKE '%Filter column: %'
SETTINGS enable_parallel_replicas = '0'
FORMAT TSV;

SELECT
    t1.k,
    t1.a,
    t2.x
FROM
    tp1 AS t1
INNER JOIN tp2 AS t2
    ON t1.k = t2.k
WHERE t2.x = 100
    OR t2.x = 200
ORDER BY t1.k ASC;

SELECT REGEXP_REPLACE(trimLeft(`explain`), '__set_Int32_\\d+_\\d+', '__set_Int32_UNIQ_ID')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT
                    t1.k,
                    t1.a,
                    t2.x
                FROM
                    tp1 AS t1
                INNER JOIN tp2 AS t2
                    ON t1.k = t2.k
                WHERE t1.k IN (1, 2)
                    OR t1.k IN (3, 4)
                ORDER BY t1.k ASC
            ))
    )
WHERE `explain` ILIKE '%Filter column: %'
SETTINGS enable_parallel_replicas = '0'
FORMAT TSV;

SELECT
    t1.k,
    t1.a,
    t2.x
FROM
    tp1 AS t1
INNER JOIN tp2 AS t2
    ON t1.k = t2.k
WHERE t1.k IN (1, 2)
    OR t1.k IN (3, 4)
ORDER BY t1.k ASC;

DROP TABLE tp1;

DROP TABLE tp2;

---------- CASE D ----------
DROP TABLE IF EXISTS table1;

DROP TABLE IF EXISTS table2;

CREATE TABLE table1
(
    a UInt32,
    b String
)
ENGINE = Memory();

CREATE TABLE table2
(
    c UInt32,
    d String
)
ENGINE = Memory();

INSERT INTO table1;

INSERT INTO table2;

SELECT REGEXP_REPLACE(trimLeft(`explain`), '__set_Int32_\\d+_\\d+', '__set_Int32_UNIQ_ID')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    table1
                INNER JOIN table2
                    ON b = d
                WHERE a > 0
                    AND c > 0
                    AND (a > 5
                    AND c < 10
                    OR a > 6
                    AND c < 11)
                ORDER BY
                    a ASC,
                    c ASC
            ))
    )
WHERE `explain` ILIKE '%Filter column: %'
SETTINGS enable_parallel_replicas = '0'
FORMAT TSV;

SELECT *
FROM
    table1
INNER JOIN table2
    ON a = c
WHERE a > 0
    AND c > 0
    AND (a > 5
    AND c < 10
    OR a > 6
    AND c < 11)
ORDER BY
    a ASC,
    c ASC
FORMAT TSV;

DROP TABLE table1;

DROP TABLE table2;

SELECT
    n1.number,
    n2.number
FROM
    numbers(6) AS n1,
    numbers(6) AS n2
WHERE n1.number = 1
    AND n2.number = 2
    OR n1.number = 3
    AND n2.number = 4
    OR n1.number = 5
ORDER BY
    n1.number ASC,
    n2.number ASC
FORMAT TSV;

SELECT REGEXP_REPLACE(trimLeft(`explain`), '__set_Int32_\\d+_\\d+', '__set_Int32_UNIQ_ID')
FROM (
        SELECT `explain`
        FROM (
                SELECT *
                FROM viewExplain('EXPLAIN', 'actions = 1', (
                        SELECT
                            n1.number,
                            n2.number,
                            n3.number
                        FROM
                            numbers(3) AS n2,
                            numbers(3) AS n3,
                            numbers(3) AS n1
                        WHERE n1.number = 1
                            AND n2.number + n3.number = 3
                            OR n1.number = 2
                            AND n2.number + n3.number = 2
                    ))
            )
    )
WHERE `explain` ILIKE '%Filter column: %'
SETTINGS enable_parallel_replicas = '0'
FORMAT TSV;