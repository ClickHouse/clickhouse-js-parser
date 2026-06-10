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
ENGINE = ReplicatedMergeTree('/clickhouse/tables/test/{database}/table', 'replica1')
ORDER BY id;

CREATE TABLE table_join
(
    id UInt32,
    surname String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/test/{database}/table_join', 'replica1')
ORDER BY id;

SET max_block_size = '30000';

SET max_insert_block_size = '30000';

SET min_insert_block_size_rows = '30000';

INSERT INTO table_join SELECT
    1 AS id,
    toString(number)
FROM numbers(10000);

INSERT INTO table_join SELECT
    2 AS id,
    toString(number)
FROM numbers(10000);

INSERT INTO table_join SELECT
    3 AS id,
    toString(number)
FROM numbers(10000);

INSERT INTO table_join SELECT
    4 AS id,
    toString(number)
FROM numbers(10000);

SYSTEM FLUSH ASYNC INSERT QUEUE `03733_table_join`;

SELECT count(*)
FROM table_join; -- Expecting 400000

CREATE TABLE table_join_mv_dst
(
    id UInt32,
    name String,
    surname String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/test/{database}/table_join_mv_dst', 'replica1')
ORDER BY id;

CREATE MATERIALIZED VIEW table_join_mv
TO table_join_mv_dst
AS
SELECT
    t1.id AS id,
    t1.name AS name,
    t2.surname AS surname
FROM
    src_table AS t1
INNER JOIN table_join AS t2
    USING (id);

INSERT INTO src_table;

INSERT INTO src_table;

SYSTEM FLUSH ASYNC INSERT QUEUE src_table;

SELECT count(*)
FROM src_table; -- Expecting 2

SELECT count(*)
FROM table_join_mv_dst; -- Expecting 20000

INSERT INTO src_table;

INSERT INTO src_table;

SYSTEM FLUSH LOGS `system`.query_log;

SELECT
    query,
    type,
    exception_code
FROM `system`.query_log
WHERE has(databases, currentDatabase())
    AND has(tables, currentDatabase() || '.src_table')
    AND type != 'QueryStart'
    AND query_kind = 'AsyncInsertFlush'
ORDER BY `all` DESC;