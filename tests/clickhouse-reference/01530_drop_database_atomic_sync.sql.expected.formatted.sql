-- Tags: no-parallel
-- Tag no-parallel: creates database
DROP DATABASE IF EXISTS db_01530_atomic SYNC;

CREATE DATABASE db_01530_atomic
ENGINE = Atomic();

CREATE TABLE db_01530_atomic.data
(
    key Int
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/db_01530_atomic/data', 'test')
ORDER BY key;

DROP DATABASE db_01530_atomic SYNC;

SET database_atomic_wait_for_drop_and_detach_synchronously = '1';

DROP DATABASE db_01530_atomic;

SET database_atomic_wait_for_drop_and_detach_synchronously = '0';