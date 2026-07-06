-- Tags: no-parallel, no-replicated-database, no-shared-merge-tree
-- Tag: no-parallel - to avoid polluting FETCH PARTITION thread pool with other fetches
-- Tag: no-replicated-database - replica_path is different
DROP TABLE IF EXISTS data1;

DROP TABLE IF EXISTS data2;

CREATE TABLE data1
(
    key Int
)
ENGINE = ReplicatedMergeTree('/tables/{database}/{table}', 'r1')
ORDER BY ();

CREATE TABLE data2
(
    key Int
)
ENGINE = ReplicatedMergeTree('/tables/{database}/{table}', 'r1')
ORDER BY ();

SYSTEM STOP MERGES data1;

INSERT INTO data1 SELECT *
FROM numbers(100)
SETTINGS
    max_block_size = '1',
    min_insert_block_size_rows = '1';

SELECT
    'parts in data1',
    count()
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'data1';

ALTER TABLE data2 FETCH PARTITION () FROM '/tables/{database}/data1';

SELECT
    'detached parts in data2',
    count()
FROM `system`.detached_parts
WHERE database = currentDatabase()
    AND table = 'data2';

SYSTEM FLUSH LOGS query_log;

SELECT
    'FETCH PARTITION uses multiple threads',
    peak_threads_usage > 10
FROM `system`.query_log
WHERE event_date >= yesterday()
    AND type != 'QueryStart'
    AND query_kind = 'Alter'
    AND current_database = currentDatabase();