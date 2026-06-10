-- { echo ON }
DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    s String
)
ENGINE = MergeTree()
ORDER BY ()
SETTINGS serialization_info_version = 'basic', string_serialization_version = 'single_stream';

INSERT INTO test;

-- Old string type also supports .size subcolumn
SELECT s.size
FROM test;

-- system.parts_columns table only lists physical subcolumns/substreams
SELECT
    column,
    substreams,
    subcolumns.names,
    subcolumns.types
FROM `system`.parts_columns
WHERE database = currentDatabase()
    AND table = 'test'
    AND active
ORDER BY column ASC;

DROP TABLE test;

CREATE TABLE test
(
    s String
)
ENGINE = MergeTree()
ORDER BY ()
SETTINGS serialization_info_version = 'with_types', string_serialization_version = 'with_size_stream';

-- When `serialization_info_version` is set to `single_stream`, any per-type string serialization version (`string_serialization_version`) will be ignored and reset to `DEFAULT`.
CREATE TABLE test
(
    s String
)
ENGINE = MergeTree()
ORDER BY ()
SETTINGS serialization_info_version = 'basic', string_serialization_version = 'with_size_stream';

-- Lazy materialization test
SET query_plan_optimize_lazy_materialization = '1';

SET query_plan_max_limit_for_lazy_materialization = '10';

DROP TABLE IF EXISTS test_old;

DROP TABLE IF EXISTS test_new;

CREATE TABLE test_old
(
    x UInt64,
    y UInt64,
    s String
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS serialization_info_version = 'basic';

CREATE TABLE test_new
(
    x UInt64,
    y UInt64,
    s String
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS serialization_info_version = 'with_types', string_serialization_version = 'with_size_stream';

INSERT INTO test_old SELECT
    number,
    number,
    number
FROM numbers(10);

INSERT INTO test_new SELECT
    number,
    number,
    number
FROM numbers(10);

SELECT
    s.size,
    s
FROM test_old
WHERE y > 5
ORDER BY y ASC
LIMIT 2;

SELECT
    s,
    s.size
FROM test_old
WHERE y > 5
ORDER BY y ASC
LIMIT 2;

SELECT
    s.size,
    s
FROM test_new
WHERE y > 5
ORDER BY y ASC
LIMIT 2;

SELECT
    s,
    s.size
FROM test_new
WHERE y > 5
ORDER BY y ASC
LIMIT 2;

DROP TABLE test_old;

DROP TABLE test_new;

-- Substreams cache test for Compact/Wide parts and inside Tuple
DROP TABLE IF EXISTS test_old_compact;

DROP TABLE IF EXISTS test_old_wide;

DROP TABLE IF EXISTS test_new_compact;

DROP TABLE IF EXISTS test_new_wide;

CREATE TABLE test_old_compact
(
    s String,
    t Tuple(a String, b String)
)
ENGINE = MergeTree()
ORDER BY ()
SETTINGS serialization_info_version = 'basic', min_rows_for_wide_part = '10000000', min_bytes_for_wide_part = '10000000';

CREATE TABLE test_old_wide
(
    s String,
    t Tuple(a String, b String)
)
ENGINE = MergeTree()
ORDER BY ()
SETTINGS serialization_info_version = 'basic', min_rows_for_wide_part = '1', min_bytes_for_wide_part = '1';

CREATE TABLE test_new_compact
(
    s String,
    t Tuple(a String, b String)
)
ENGINE = MergeTree()
ORDER BY ()
SETTINGS serialization_info_version = 'with_types', string_serialization_version = 'with_size_stream', min_rows_for_wide_part = '10000000', min_bytes_for_wide_part = '10000000';

CREATE TABLE test_new_wide
(
    s String,
    t Tuple(a String, b String)
)
ENGINE = MergeTree()
ORDER BY ()
SETTINGS serialization_info_version = 'with_types', string_serialization_version = 'with_size_stream', min_rows_for_wide_part = '1', min_bytes_for_wide_part = '1';

INSERT INTO test_old_compact SELECT
    number,
    (number, number)
FROM numbers(10);

INSERT INTO test_old_wide SELECT
    number,
    (number, number)
FROM numbers(10);

INSERT INTO test_new_compact SELECT
    number,
    (number, number)
FROM numbers(10);

INSERT INTO test_new_wide SELECT
    number,
    (number, number)
FROM numbers(10);

SELECT
    s,
    s.size,
    t.a,
    t.a.size,
    t.b,
    t.b.size
FROM test_old_compact
ORDER BY `all` ASC
LIMIT 2
OFFSET 3;

SELECT
    s.size,
    s,
    t.a,
    t.a.size,
    t.b,
    t.b.size
FROM test_old_compact
ORDER BY `all` ASC
LIMIT 2
OFFSET 3;

SELECT
    s,
    s.size,
    t.a,
    t.a.size,
    t.b,
    t.b.size
FROM test_old_wide
ORDER BY `all` ASC
LIMIT 2
OFFSET 3;

SELECT
    s.size,
    s,
    t.a,
    t.a.size,
    t.b,
    t.b.size
FROM test_old_wide
ORDER BY `all` ASC
LIMIT 2
OFFSET 3;

SELECT
    s,
    s.size,
    t.a,
    t.a.size,
    t.b,
    t.b.size
FROM test_new_compact
ORDER BY `all` ASC
LIMIT 2
OFFSET 3;

SELECT
    s.size,
    s,
    t.a,
    t.a.size,
    t.b,
    t.b.size
FROM test_new_compact
ORDER BY `all` ASC
LIMIT 2
OFFSET 3;

SELECT
    s,
    s.size,
    t.a,
    t.a.size,
    t.b,
    t.b.size
FROM test_new_wide
ORDER BY `all` ASC
LIMIT 2
OFFSET 3;

SELECT
    s.size,
    s,
    t.a,
    t.a.size,
    t.b,
    t.b.size
FROM test_new_wide
ORDER BY `all` ASC
LIMIT 2
OFFSET 3;

DROP TABLE test_old_compact;

DROP TABLE test_old_wide;

DROP TABLE test_new_compact;

DROP TABLE test_new_wide;

-- Test empty string comparison and .size subcolumn optimization
SET enable_analyzer = '1';

SET optimize_empty_string_comparisons = '1';

SET optimize_functions_to_subcolumns = '0';

DROP TABLE IF EXISTS t_column_names;

CREATE TABLE t_column_names
(
    s String
)
ENGINE = Memory();

INSERT INTO t_column_names;

EXPLAIN QUERY TREE dump_tree = '0', dump_ast = '1'
SELECT s != ''
FROM t_column_names;

SELECT s != ''
FROM t_column_names;

SET optimize_functions_to_subcolumns = '1';

DROP TABLE t_column_names;