-- Tags: zookeeper, no-replicated-database, no-ordinary-database
-- no-replicated-database: we explicitly run this test by creating a replicated database
DROP DATABASE IF EXISTS CLICKHOUSE_DATABASE;

CREATE DATABASE CLICKHOUSE_DATABASE
ENGINE = Replicated('/clickhouse/databases/{database}', 'shard1', 'replica1')
FORMAT NULL;

USE CLICKHOUSE_DATABASE;

CREATE TABLE t1
(
    x UInt8,
    y String
)
ENGINE = ReplicatedMergeTree()
ORDER BY x
FORMAT NULL;

TRUNCATE DATABASE CLICKHOUSE_DATABASE; -- { serverError 48 }

DROP DATABASE CLICKHOUSE_DATABASE;