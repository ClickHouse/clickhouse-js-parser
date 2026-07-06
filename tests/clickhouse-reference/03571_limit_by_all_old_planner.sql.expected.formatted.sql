SET max_threads = '1';

SET max_insert_threads = '1';

SET max_block_size = '65536';

SET enable_analyzer = '0';

DROP TABLE IF EXISTS test_limit_by_all_old_planner;

CREATE TABLE test_limit_by_all_old_planner
(
    id Int32,
    category String,
    value Int32,
    name String
)
ENGINE = Memory();

INSERT INTO test_limit_by_all_old_planner;

-- Test 1: Test that LIMIT BY ALL throws an exception when using the old planner
-- This tests the changes in TreeWriter.cpp
SELECT
    id,
    category,
    value,
    name
FROM test_limit_by_all_old_planner
LIMIT 1 BY ALL
SETTINGS allow_experimental_analyzer = '0'; -- {serverError NOT_IMPLEMENTED}

-- Test 2: Basic LIMIT BY usage.
SELECT
    id,
    category,
    value
FROM test_limit_by_all_old_planner
ORDER BY
    id ASC,
    category ASC,
    value ASC
LIMIT 1 BY id, category, value;

-- Test 3: LIMIT BY with computed column - make deterministic by ordering by value
SELECT
    id,
    category,
    concat(category, '_', name) AS combined
FROM test_limit_by_all_old_planner
ORDER BY
    id ASC,
    category ASC,
    value ASC
LIMIT 2 BY id, category, combined;

-- Test 4: LIMIT BY with window function - make deterministic
SELECT
    id,
    category,
    value,
    row_number() OVER (PARTITION BY category ORDER BY value ASC) AS rn
FROM test_limit_by_all_old_planner
ORDER BY
    id ASC,
    category ASC,
    value ASC,
    rn ASC
LIMIT 1 BY id, category, value, rn
LIMIT 3;

-- Test 5: LIMIT BY with WHERE clause - make deterministic
SELECT
    id,
    category,
    value
FROM test_limit_by_all_old_planner
WHERE value > 200
ORDER BY
    id ASC,
    category ASC,
    value ASC
LIMIT 1 BY id, category, value;

-- Test 6: LIMIT BY with unique values
SELECT id
FROM (
        SELECT DISTINCT
            id,
            category
        FROM test_limit_by_all_old_planner
    )
ORDER BY
    id ASC,
    category ASC
LIMIT 1 BY id;

-- Test 7: LIMIT BY with DISTINCT clause
SELECT DISTINCT
    id,
    category
FROM test_limit_by_all_old_planner
ORDER BY
    id ASC,
    category ASC
LIMIT 1 BY id, category
LIMIT 2;

-- Test 8: Negative LIMIT BY should throw an exception
SELECT
    id,
    category,
    value
FROM test_limit_by_all_old_planner
ORDER BY
    id ASC,
    category ASC,
    value ASC
LIMIT -1 BY id; -- { serverError NOT_IMPLEMENTED }

-- Test 9: LIMIT BY with OFFSET
SELECT
    id,
    category
FROM test_limit_by_all_old_planner
ORDER BY
    id ASC,
    category ASC,
    value ASC
LIMIT 1, 2 BY id, category;

-- Test 10: LIMIT BY with DESC ORDER BY
SELECT
    id,
    category
FROM test_limit_by_all_old_planner
ORDER BY value DESC
LIMIT 1 BY id, category
LIMIT 2;

-- Test 11: 0 LIMIT BY - Should give no result
SELECT
    id,
    category,
    value
FROM test_limit_by_all_old_planner
ORDER BY
    id ASC,
    category ASC,
    value ASC
LIMIT 0 BY id, category, value;

-- Test 12: Misc
SELECT
    id,
    category,
    value
FROM test_limit_by_all_old_planner
ORDER BY
    id ASC,
    category ASC,
    value ASC
LIMIT 1, 2 BY id;

SELECT
    d,
    category,
    count() AS c
FROM (
        WITH toStartOfDay(toDateTime('2025-01-01 12:00:00')) AS d

        SELECT
            d,
            category
        FROM test_limit_by_all_old_planner
        ORDER BY
            d ASC,
            category ASC,
            value ASC,
            name ASC
        LIMIT 2 BY d, category
        SETTINGS enable_positional_arguments = '0'
    )
GROUP BY
    d,
    category
ORDER BY
    d ASC,
    category ASC;

-- Test 13: NULL key handling
INSERT INTO test_limit_by_all_old_planner;

SELECT
    id,
    category
FROM test_limit_by_all_old_planner
ORDER BY
    id ASC,
    category ASC NULLS FIRST,
    value ASC
LIMIT 1 BY id, category;

DROP TABLE test_limit_by_all_old_planner;