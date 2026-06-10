-- Test that lazy materialization works together with read-in-order optimization
-- Tags: no-random-settings
SET query_plan_optimize_lazy_materialization = '1';

SET query_plan_max_limit_for_lazy_materialization = '10';

SET optimize_read_in_order = '1';

SET enable_analyzer = '1';

SET parallel_replicas_local_plan = '1';

DROP TABLE IF EXISTS test_lazy_read_in_order;

-- Create a table with sorting key on column 'a'
CREATE TABLE test_lazy_read_in_order
(
    a UInt64,
    b String,
    c String,
    d String,
    e UInt64
)
ENGINE = MergeTree()
ORDER BY a;

-- Insert test data
INSERT INTO test_lazy_read_in_order SELECT
    number,
    repeat('b', 100),
    repeat('c', 100),
    repeat('d', 100),
    number * 2
FROM numbers(1000);

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT
                    a,
                    b,
                    c,
                    d,
                    e
                FROM test_lazy_read_in_order
                WHERE a >= 0
                ORDER BY a ASC
                LIMIT 5
                SETTINGS max_threads = '1'
            ))
    )
WHERE `explain` LIKE '%LazilyRead%'
    OR `explain` LIKE '%Lazily read columns:%'
    OR `explain` LIKE '%ReadType:%'
    OR `explain` LIKE '%Prefix sort description:%'
    OR `explain` LIKE '%Result sort description:%';

SELECT
    a,
    e
FROM test_lazy_read_in_order
WHERE a >= 0
ORDER BY a ASC
LIMIT 5;

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT
                    a,
                    b,
                    c,
                    d,
                    e
                FROM test_lazy_read_in_order
                WHERE e > 100
                ORDER BY a ASC
                LIMIT 5
                SETTINGS max_threads = '1'
            ))
    )
WHERE `explain` LIKE '%LazilyRead%'
    OR `explain` LIKE '%Lazily read columns:%'
    OR `explain` LIKE '%ReadType:%'
    OR `explain` LIKE '%Prefix sort description:%'
    OR `explain` LIKE '%Result sort description:%';

SELECT
    a,
    e
FROM test_lazy_read_in_order
WHERE e > 100
ORDER BY a ASC
LIMIT 5;

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT
                    a,
                    b,
                    c,
                    d,
                    e
                FROM test_lazy_read_in_order
                PREWHERE e > 100
                ORDER BY a ASC
                LIMIT 5
                SETTINGS max_threads = '1'
            ))
    )
WHERE `explain` LIKE '%LazilyRead%'
    OR `explain` LIKE '%Lazily read columns:%'
    OR `explain` LIKE '%ReadType:%'
    OR `explain` LIKE '%Prefix sort description:%'
    OR `explain` LIKE '%Result sort description:%';

SELECT
    a,
    e
FROM test_lazy_read_in_order
PREWHERE e > 100
ORDER BY a ASC
LIMIT 5;

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT
                    a,
                    b,
                    c,
                    d,
                    e
                FROM test_lazy_read_in_order
                WHERE a >= 0
                ORDER BY
                    a ASC,
                    e ASC
                LIMIT 5
                SETTINGS max_threads = '1'
            ))
    )
WHERE `explain` LIKE '%LazilyRead%'
    OR `explain` LIKE '%Lazily read columns:%'
    OR `explain` LIKE '%ReadType:%'
    OR `explain` LIKE '%Prefix sort description:%'
    OR `explain` LIKE '%Result sort description:%';

SELECT
    a,
    e
FROM test_lazy_read_in_order
WHERE a >= 0
ORDER BY
    a ASC,
    e ASC
LIMIT 5;

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT
                    a,
                    b,
                    c,
                    d,
                    e
                FROM test_lazy_read_in_order
                WHERE a >= 0
                ORDER BY
                    a ASC,
                    a + 1 ASC
                LIMIT 5
                SETTINGS max_threads = '1'
            ))
    )
WHERE `explain` LIKE '%LazilyRead%'
    OR `explain` LIKE '%Lazily read columns:%'
    OR `explain` LIKE '%ReadType:%'
    OR `explain` LIKE '%Prefix sort description:%'
    OR `explain` LIKE '%Result sort description:%';

SELECT
    a,
    e
FROM test_lazy_read_in_order
WHERE a >= 0
ORDER BY
    a ASC,
    a + 1 ASC
LIMIT 5;

-- Additional correctness tests for lazy materialization with read-in-order
DROP TABLE IF EXISTS test_correctness;

CREATE TABLE test_correctness
(
    id UInt64,
    value String,
    score UInt64,
    data String
)
ENGINE = MergeTree()
ORDER BY id;

-- Insert data in non-sequential order to test sorting
INSERT INTO test_correctness;

-- With both optimizations enabled
SELECT
    id,
    value,
    score
FROM test_correctness
ORDER BY id ASC
LIMIT 5;

-- DESC should also work
SELECT
    id,
    value,
    score
FROM test_correctness
ORDER BY id DESC
LIMIT 5;

-- Filter and order
SELECT
    id,
    value,
    score
FROM test_correctness
WHERE score >= 50
ORDER BY id ASC;

-- Same query with optimizations disabled should give same results
SELECT
    id,
    value,
    score
FROM test_correctness
WHERE id >= 0
ORDER BY id ASC
LIMIT 5
SETTINGS
    optimize_read_in_order = '0',
    query_plan_optimize_lazy_materialization = '0';

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT
                    id,
                    value,
                    score,
                    data
                FROM test_correctness
                WHERE id >= 0
                ORDER BY id ASC
                LIMIT 5
                SETTINGS max_threads = '1'
            ))
    )
WHERE `explain` LIKE '%LazilyRead%'
    OR `explain` LIKE '%Lazily read columns:%'
    OR `explain` LIKE '%ReadType:%'
    OR `explain` LIKE '%Prefix sort description:%'
    OR `explain` LIKE '%Result sort description:%';