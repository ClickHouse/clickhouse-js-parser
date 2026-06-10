-- Tags: long, no-object-storage
-- no-object-storage: Avoid flakiness due to cache / buffer usage
SET insert_keeper_fault_injection_probability = '0'; -- to succeed this test can require too many retries due to 100 partitions, so disable fault injections

-- regression for MEMORY_LIMIT_EXCEEDED error because of deferred final part flush
DROP TABLE IF EXISTS data_02228;

CREATE TABLE data_02228
(
    key1 UInt32,
    sign Int8,
    s UInt64
)
ENGINE = CollapsingMergeTree(sign)
ORDER BY key1
PARTITION BY key1 % 100
SETTINGS auto_statistics_types = '';

INSERT INTO data_02228 SELECT
    number,
    1,
    number
FROM numbers_mt(10000)
SETTINGS
    max_memory_usage = '30Mi',
    max_partitions_per_insert_block = '1024',
    max_insert_delayed_streams_for_parallel_write = '0';

INSERT INTO data_02228 SELECT
    number,
    1,
    number
FROM numbers_mt(10000)
SETTINGS
    max_memory_usage = '30Mi',
    max_partitions_per_insert_block = '1024',
    max_insert_delayed_streams_for_parallel_write = '1000000'; -- { serverError MEMORY_LIMIT_EXCEEDED }

DROP TABLE data_02228;

DROP TABLE IF EXISTS data_rep_02228 SYNC;

CREATE TABLE data_rep_02228
(
    key1 UInt32,
    sign Int8,
    s UInt64
)
ENGINE = ReplicatedCollapsingMergeTree('/clickhouse/{database}', 'r1', sign)
ORDER BY key1
PARTITION BY key1 % 100
SETTINGS auto_statistics_types = '';

INSERT INTO data_rep_02228 SELECT
    number,
    1,
    number
FROM numbers_mt(10000)
SETTINGS
    max_memory_usage = '30Mi',
    max_partitions_per_insert_block = '1024',
    max_insert_delayed_streams_for_parallel_write = '0';

INSERT INTO data_rep_02228 SELECT
    number,
    1,
    number
FROM numbers_mt(10000)
SETTINGS
    max_memory_usage = '30Mi',
    max_partitions_per_insert_block = '1024',
    max_insert_delayed_streams_for_parallel_write = '1000000'; -- { serverError MEMORY_LIMIT_EXCEEDED }

DROP TABLE data_rep_02228 SYNC;