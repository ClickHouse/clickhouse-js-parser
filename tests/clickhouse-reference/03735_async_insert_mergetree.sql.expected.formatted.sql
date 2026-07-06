SET async_insert = '1';

SET wait_for_async_insert = '0';

SET async_insert_deduplicate = '1';

SET deduplicate_blocks_in_dependent_materialized_views = '1';

SET async_insert_use_adaptive_busy_timeout = '0', async_insert_busy_timeout_min_ms = '1000', async_insert_busy_timeout_max_ms = '5000';

CREATE TABLE src_table
(
    id UInt32,
    name String
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS non_replicated_deduplication_window = '10000';

INSERT INTO src_table;

INSERT INTO src_table;

INSERT INTO src_table;

SYSTEM FLUSH ASYNC INSERT QUEUE src_table;

-- Expecting 2
SELECT
    'src_table',
    count(*)
FROM src_table;

CREATE TABLE dst_1_0
(
    id UInt32,
    name String
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS non_replicated_deduplication_window = '10000';

CREATE MATERIALIZED VIEW mv_1_0
TO dst_1_0
AS
SELECT *
FROM src_table
WHERE id % 2 = 0;

CREATE TABLE dst_1_1
(
    id UInt32,
    name String
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS non_replicated_deduplication_window = '10000';

CREATE MATERIALIZED VIEW mv_1_1
TO dst_1_1
AS
SELECT *
FROM src_table
WHERE id % 2 = 1;

CREATE TABLE dst_1_2
(
    id UInt32,
    name String
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS non_replicated_deduplication_window = '10000';

CREATE MATERIALIZED VIEW mv_1_2
TO dst_1_2
AS
SELECT *
FROM src_table;

CREATE TABLE dst_2_01
(
    id UInt32,
    name String
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS non_replicated_deduplication_window = '10000';

CREATE MATERIALIZED VIEW mv_2_00
TO dst_2_01
AS
SELECT *
FROM dst_1_0;

CREATE MATERIALIZED VIEW mv_2_01
TO dst_2_01
AS
SELECT *
FROM dst_1_1;

INSERT INTO src_table;

SELECT *
FROM src_table
ORDER BY `all` ASC;

-- Expecting 2
SELECT
    'dst_1_0',
    count(*)
FROM dst_1_0;

SELECT *
FROM dst_1_0
ORDER BY `all` ASC;

-- Expecting 4
SELECT
    'dst_1_1',
    count(*)
FROM dst_1_1;

SELECT *
FROM dst_1_1
ORDER BY `all` ASC;

-- Expecting 6
SELECT
    'dst_1_2',
    count(*)
FROM dst_1_2;

SELECT *
FROM dst_1_2
ORDER BY `all` ASC;

-- Expecting 6
SELECT
    'dst_2_01',
    count(*)
FROM dst_2_01;

SELECT *
FROM dst_2_01
ORDER BY `all` ASC;

SYSTEM FLUSH LOGS `system`.query_log;

SELECT
    query,
    query_kind,
    exception_code,
    read_rows,
    written_rows,
    ProfileEvents['QueriesWithSubqueries'] AS QueriesWithSubqueries,
    ProfileEvents['SelectQueriesWithSubqueries'] AS SelectQueriesWithSubqueries,
    ProfileEvents['AsyncInsertRows'] AS AsyncInsertRows,
    ProfileEvents['SelfDuplicatedAsyncInserts'] AS SelfDuplicatedAsyncInserts,
    ProfileEvents['DuplicatedAsyncInserts'] AS DuplicatedAsyncInserts
FROM `system`.query_log
WHERE has(databases, currentDatabase())
    AND has(tables, currentDatabase() || '.src_table')
    AND type != 'QueryStart'
    AND query_kind = 'AsyncInsertFlush'
ORDER BY `all` DESC
FORMAT Vertical;