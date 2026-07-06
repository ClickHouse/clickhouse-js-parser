-- Test SELECT * REPLACE with all SQL clauses using new analyzer
-- This test verifies comprehensive fix for SELECT * REPLACE in all applicable clauses
-- See issue: https://github.com/ClickHouse/ClickHouse/issues/85313
-- See PR: https://github.com/ClickHouse/ClickHouse/pull/87630
SET allow_experimental_analyzer = '1';

-- Setup test tables
DROP TABLE IF EXISTS test_replace_main;

DROP TABLE IF EXISTS test_replace_merge;

CREATE TABLE test_replace_main
(
    id UInt32,
    a UInt32,
    b UInt32,
    c String
)
ENGINE = Memory();

INSERT INTO test_replace_main;

CREATE TABLE test_replace_merge
(
    id UInt32,
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test_replace_merge;

SELECT * REPLACE (a AS b)
FROM test_replace_main
WHERE b > 150
ORDER BY id ASC;

DROP TABLE IF EXISTS test_arith;

CREATE TABLE test_arith
(
    a UInt32,
    b UInt32
)
ENGINE = Memory();

INSERT INTO test_arith;

SELECT * REPLACE (a + 10 AS b)
FROM test_arith
WHERE b = 11;

SELECT * REPLACE (a + 10 AS b)
FROM test_arith
WHERE b = 12;

SELECT * REPLACE (a * 10 + a AS b)
FROM test_arith
WHERE b = 11;

-- Test 1b: String replacement in WHERE
DROP TABLE IF EXISTS test_replace_str;

CREATE TABLE test_replace_str
(
    id UInt32,
    s String
)
ENGINE = Memory();

INSERT INTO test_replace_str;

SELECT * REPLACE (s || '_suffix' AS s)
FROM test_replace_str
WHERE s = 'hello_suffix';

DROP TABLE test_arith;

DROP TABLE test_replace_str;

SELECT * REPLACE (a AS b)
FROM test_replace_main
ORDER BY b ASC;

SELECT * REPLACE (a AS b)
FROM test_replace_main
ORDER BY
    b DESC,
    id ASC;

SELECT * REPLACE (a AS b)
FROM test_replace_merge
PREWHERE b > 150
ORDER BY id ASC;

DROP TABLE IF EXISTS test_limit_by;

CREATE TABLE test_limit_by
(
    id UInt32,
    a UInt32,
    b UInt32
)
ENGINE = Memory();

INSERT INTO test_limit_by;

SELECT * REPLACE (a AS b)
FROM test_limit_by
ORDER BY id ASC
LIMIT 1 BY b < 200;

DROP TABLE test_limit_by;

SELECT
    * REPLACE (a AS b),
    ROW_NUMBER() OVER (ORDER BY b ASC) AS rn
FROM test_replace_main
ORDER BY id ASC;

SELECT * REPLACE (a * 2 + 10 AS b)
FROM test_replace_main
WHERE b > 250
ORDER BY id ASC;

SELECT * REPLACE (a AS b, 'replaced_' || c AS c)
FROM test_replace_main
WHERE b > 150
ORDER BY id ASC;

SELECT *
FROM (
        SELECT * REPLACE (a AS b)
        FROM test_replace_main
        WHERE b > 150
    )
ORDER BY id ASC;

SELECT * REPLACE (c || '_suffix' AS c)
FROM test_replace_main
WHERE c = 'beta_suffix'
ORDER BY id ASC;

SELECT * REPLACE (a AS b)
FROM test_replace_main
WHERE b > 150
ORDER BY b ASC
LIMIT 2;

SELECT * REPLACE (a + 100 AS b)
FROM test_replace_main
WHERE b + 50 > 200
ORDER BY b ASC;

DROP TABLE IF EXISTS test_group_by;

CREATE TABLE test_group_by
(
    id UInt32,
    category String,
    value UInt32
)
ENGINE = Memory();

INSERT INTO test_group_by;

SELECT
    category,
    sum(value) AS total
FROM (
        SELECT * REPLACE (value * 10 AS value)
        FROM test_group_by
    )
GROUP BY category
ORDER BY category ASC;

DROP TABLE test_group_by;

DROP TABLE IF EXISTS test_group_by_sub;

CREATE TABLE test_group_by_sub
(
    category String,
    value UInt32
)
ENGINE = Memory();

INSERT INTO test_group_by_sub;

SELECT
    category,
    total
FROM (
        SELECT
            category || '_modified' AS category,
            sum(value) AS total
        FROM test_group_by_sub
        GROUP BY category
    )
ORDER BY category ASC;

DROP TABLE test_group_by_sub;

DROP TABLE IF EXISTS test_group_by_direct;

CREATE TABLE test_group_by_direct
(
    category String,
    value UInt32
)
ENGINE = Memory();

INSERT INTO test_group_by_direct;

SELECT
    category || '_modified' AS category,
    sum(value) AS total
FROM test_group_by_direct
GROUP BY category
ORDER BY category ASC;

DROP TABLE test_group_by_direct;

DROP TABLE IF EXISTS test_having;

CREATE TABLE test_having
(
    id UInt32,
    category String,
    amount UInt32
)
ENGINE = Memory();

INSERT INTO test_having;

SELECT
    category,
    sum(amount) AS total
FROM (
        SELECT * REPLACE (amount + 100 AS amount)
        FROM test_having
    )
GROUP BY category
HAVING total > 200
ORDER BY category ASC;

DROP TABLE test_having;

DROP TABLE IF EXISTS test_having_sub;

CREATE TABLE test_having_sub
(
    category String,
    amount UInt32
)
ENGINE = Memory();

INSERT INTO test_having_sub;

SELECT
    category,
    total
FROM (
        SELECT
            category,
            sum(amount + 100) AS total
        FROM test_having_sub
        GROUP BY category
        HAVING total > 200
    )
ORDER BY category ASC;

DROP TABLE test_having_sub;

DROP TABLE IF EXISTS test_having_direct;

CREATE TABLE test_having_direct
(
    category String,
    amount UInt32
)
ENGINE = Memory();

INSERT INTO test_having_direct;

SELECT
    category,
    sum(amount + 100) AS total
FROM test_having_direct
GROUP BY category
HAVING total > 200
ORDER BY category ASC;

DROP TABLE test_having_direct;

-- Cleanup
DROP TABLE test_replace_main;

DROP TABLE test_replace_merge;