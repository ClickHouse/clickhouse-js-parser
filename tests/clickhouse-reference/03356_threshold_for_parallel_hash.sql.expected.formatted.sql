CREATE TABLE lhs
(
    a UInt64
)
ENGINE = MergeTree()
ORDER BY ();

CREATE TABLE rhs
(
    a UInt64
)
ENGINE = MergeTree()
ORDER BY ();

INSERT INTO lhs SELECT *
FROM numbers_mt(100000.);

INSERT INTO rhs SELECT *
FROM numbers_mt(1000000.);

SET enable_parallel_replicas = '0'; -- join optimization (and table size estimation) disabled with parallel replicas

SET enable_analyzer = '1', use_query_condition_cache = '0';

SET join_algorithm = 'direct,parallel_hash,hash'; -- default

SET parallel_hash_join_threshold = '100001';

-- Tables should be swapped; the new right table is below the threshold - use HashJoin
SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    lhs AS t0
                INNER JOIN rhs AS t1
                    ON t0.a = t1.a
                SETTINGS query_plan_join_swap_table = 'auto'
            ))
    )
WHERE `explain` ILIKE '%Algorithm%';

-- Tables were not swapped; the right table is above the threshold - use ConcurrentHashJoin
SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    lhs AS t0
                INNER JOIN rhs AS t1
                    ON t0.a = t1.a
                SETTINGS query_plan_join_swap_table = false
            ))
    )
WHERE `explain` ILIKE '%Algorithm%';

-- Check estimations obtained from the cache
-- Tables should be swapped; the new right table is below the threshold - use HashJoin
SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    lhs AS t0
                INNER JOIN rhs AS t1
                    ON t0.a = t1.a
                SETTINGS query_plan_join_swap_table = true
            ))
    )
WHERE `explain` ILIKE '%Algorithm%';

-- Same queries but we cannot do fallback to `hash`
SET join_algorithm = 'parallel_hash';

-- Check estimations obtained from the cache
-- Right table is big, regardless of cardinality of join key, we should use ConcurrentHashJoin
SELECT *
FROM
    lhs AS t0
INNER JOIN (
        SELECT a % 10000 AS a
        FROM rhs
    ) AS t1
    ON t0.a = t1.a
SETTINGS query_plan_join_swap_table = false
FORMAT Null;

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    lhs AS t0
                INNER JOIN (
                        SELECT a % 10000 AS a
                        FROM rhs
                    ) AS t1
                    ON t0.a = t1.a
                SETTINGS query_plan_join_swap_table = false
            ))
    )
WHERE `explain` ILIKE '%Algorithm%';

-- Right table is big, but only a small fraction of rows reaches the join - use HashJoin
SELECT *
FROM
    lhs AS t0
INNER JOIN rhs AS t1
    ON t0.a = t1.a
WHERE t1.a < 10000
SETTINGS query_plan_join_swap_table = false
FORMAT Null;

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    lhs AS t0
                INNER JOIN rhs AS t1
                    ON t0.a = t1.a
                WHERE t1.a < 10000
                SETTINGS query_plan_join_swap_table = false
            ))
    )
WHERE `explain` ILIKE '%Algorithm%';