-- { echoOn }
SYSTEM STOP MERGES tbl;

-- simple test case
CREATE TABLE IF NOT EXISTS replacing_mt
(
    x String
)
ENGINE = ReplacingMergeTree()
ORDER BY x;

INSERT INTO replacing_mt;

-- expected output is 2 because final is turned off
SELECT count()
FROM replacing_mt;

SET final = '1';

-- JOIN test cases
CREATE TABLE IF NOT EXISTS lhs
(
    x String
)
ENGINE = ReplacingMergeTree()
ORDER BY x;

CREATE TABLE IF NOT EXISTS rhs
(
    x String
)
ENGINE = ReplacingMergeTree()
ORDER BY x;

INSERT INTO lhs;

INSERT INTO rhs;

SET final = '0';

-- expected output is 4 because select_final == 0
SELECT count()
FROM
    lhs
INNER JOIN rhs
    ON lhs.x = rhs.x;

CREATE TABLE IF NOT EXISTS regular_mt_table
(
    x String
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO regular_mt_table;

-- expected output is 1, it should silently ignore final modifier
SELECT count()
FROM regular_mt_table;

-- view test
CREATE MATERIALIZED VIEW mv_regular_mt_table
TO regular_mt_table
AS
SELECT *
FROM regular_mt_table;

CREATE VIEW nv_regular_mt_table
AS
SELECT *
FROM mv_regular_mt_table;

SET final = '1';

SELECT count()
FROM nv_regular_mt_table;

-- join on mix of tables that support / do not support select final with explain
CREATE TABLE IF NOT EXISTS left_table
(
    id UInt64,
    val_left String
)
ENGINE = ReplacingMergeTree()
ORDER BY id;

CREATE TABLE IF NOT EXISTS middle_table
(
    id UInt64,
    val_middle String
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE IF NOT EXISTS right_table
(
    id UInt64,
    val_right String
)
ENGINE = ReplacingMergeTree()
ORDER BY id;

INSERT INTO left_table;

INSERT INTO left_table;

INSERT INTO left_table;

INSERT INTO middle_table;

INSERT INTO middle_table;

INSERT INTO right_table;

INSERT INTO right_table;

INSERT INTO right_table;

-- expected output
-- 1 c a c
-- 1 c b c
SELECT
    left_table.id,
    val_left,
    val_middle,
    val_right
FROM
    left_table
INNER JOIN middle_table
    ON left_table.id = middle_table.id
INNER JOIN right_table
    ON middle_table.id = right_table.id
ORDER BY
    left_table.id ASC,
    val_left ASC,
    val_middle ASC,
    val_right ASC;

EXPLAIN SYNTAX
SELECT
    left_table.id,
    val_left,
    val_middle,
    val_right
FROM
    left_table
INNER JOIN middle_table
    ON left_table.id = middle_table.id
INNER JOIN right_table
    ON middle_table.id = right_table.id
ORDER BY
    left_table.id ASC,
    val_left ASC,
    val_middle ASC,
    val_right ASC;

-- extra: same with subquery
SELECT
    left_table.id,
    val_left,
    val_middle,
    val_right
FROM
    left_table
INNER JOIN middle_table
    ON left_table.id = middle_table.id
INNER JOIN (
        SELECT *
        FROM right_table
        WHERE id = 1
    ) AS r
    ON middle_table.id = r.id
ORDER BY
    left_table.id ASC,
    val_left ASC,
    val_middle ASC,
    val_right ASC;

-- distributed tables
DROP TABLE IF EXISTS left_table;

DROP TABLE IF EXISTS middle_table;

DROP TABLE IF EXISTS right_table;

CREATE TABLE IF NOT EXISTS right_table_local
(
    id UInt64,
    val_right String
)
ENGINE = ReplacingMergeTree()
ORDER BY id;

CREATE TABLE IF NOT EXISTS right_table AS right_table_local
ENGINE = Distributed('test_shard_localhost', currentDatabase(), right_table_local);

INSERT INTO right_table_local;

INSERT INTO right_table_local;

INSERT INTO right_table_local;

SET prefer_localhost_replica = '0';

-- expected output:
-- 1 c 1 a 1 c
-- 1 c 1 b 1 c
SELECT
    left_table.*,
    middle_table.*,
    right_table.*
FROM
    left_table
INNER JOIN middle_table
    ON left_table.id = middle_table.id
INNER JOIN right_table
    ON middle_table.id = right_table.id
ORDER BY
    left_table.id ASC,
    val_left ASC,
    val_middle ASC,
    val_right ASC;

SET prefer_localhost_replica = '1';

-- Quite exotic with Merge engine
DROP TABLE IF EXISTS table_to_merge_a;

DROP TABLE IF EXISTS table_to_merge_b;

DROP TABLE IF EXISTS table_to_merge_c;

DROP TABLE IF EXISTS merge_table;

CREATE TABLE IF NOT EXISTS table_to_merge_a
(
    id UInt64,
    val String
)
ENGINE = ReplacingMergeTree()
ORDER BY id;

CREATE TABLE IF NOT EXISTS table_to_merge_b
(
    id UInt64,
    val String
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE IF NOT EXISTS table_to_merge_c
(
    id UInt64,
    val String
)
ENGINE = ReplacingMergeTree()
ORDER BY id;

CREATE TABLE merge_table AS table_to_merge_a
ENGINE = Merge(currentDatabase(), '^(table_to_merge_[a-z])$');

INSERT INTO table_to_merge_a;

INSERT INTO table_to_merge_a;

INSERT INTO table_to_merge_a;

INSERT INTO table_to_merge_b;

INSERT INTO table_to_merge_b;

INSERT INTO table_to_merge_c;

INSERT INTO table_to_merge_c;

INSERT INTO table_to_merge_c;

-- expected output:
-- 1 c, 2 a, 2 b, 3 c
SELECT *
FROM merge_table
ORDER BY
    id ASC,
    val ASC;