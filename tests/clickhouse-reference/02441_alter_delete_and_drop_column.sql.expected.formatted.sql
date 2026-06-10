-- Tags: no-replicated-database, no-shared-merge-tree
-- no-shared-merge-tree: depend on system.replication_queue
CREATE TABLE mut
(
    n int,
    m int,
    k int
)
ENGINE = ReplicatedMergeTree('/test/02441/{database}/mut', '1')
ORDER BY n;

SET insert_keeper_fault_injection_probability = '0';

SYSTEM STOP MERGES mut;

INSERT INTO mut;

ALTER TABLE mut DELETE WHERE n = 10;

-- a funny way to wait for a MUTATE_PART to be assigned
SELECT sleepEachRow(2)
FROM url('http://localhost:8123/?param_tries={1..10}&query=' || encodeURLComponent('select 1 where ''MUTATE_PART'' not in (select type from system.replication_queue where database=''' || currentDatabase() || ''' and table=''mut'')'), 'LineAsString', 's String')
SETTINGS
    max_threads = '1',
    http_make_head_request = '0'
FORMAT Null;

ALTER TABLE mut DROP COLUMN k SETTINGS alter_sync = '0';

-- a funny way to wait for ALTER_METADATA to disappear from the replication queue
SELECT sleepEachRow(2)
FROM url('http://localhost:8123/?param_tries={1..10}&query=' || encodeURLComponent('select * from system.replication_queue where database=''' || currentDatabase() || ''' and table=''mut'' and type=''ALTER_METADATA'''), 'LineAsString', 's String')
SETTINGS
    max_threads = '1',
    http_make_head_request = '0'
FORMAT Null;

SYSTEM SYNC REPLICA mut PULL;

SELECT
    type,
    new_part_name,
    parts_to_merge
FROM `system`.replication_queue
WHERE database = currentDatabase()
    AND table = 'mut'
    AND type != 'GET_PART';

SYSTEM START MERGES mut;

SET receive_timeout = '30';

SYSTEM SYNC REPLICA mut;

SELECT *
FROM mut;