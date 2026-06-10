SET mutations_sync = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    id UInt64,
    json JSON
)
ENGINE = SummingMergeTree()
ORDER BY id
SETTINGS min_bytes_for_wide_part = '1', min_rows_for_wide_part = '1', index_granularity = '32', merge_max_block_size = '32';

INSERT INTO test SELECT
    number,
    '{}'
FROM numbers(100);

ALTER TABLE test UPDATE json = '{"a" : 42}' WHERE id > 90;

OPTIMIZE TABLE test FINAL;

SELECT DISTINCT arrayJoin(JSONDynamicPaths(json))
FROM test;

SELECT DISTINCT arrayJoin(JSONSharedDataPaths(json))
FROM test;

DROP TABLE test;

CREATE TABLE test
(
    id UInt64,
    json JSON
)
ENGINE = AggregatingMergeTree()
ORDER BY id
SETTINGS min_bytes_for_wide_part = '1', min_rows_for_wide_part = '1', index_granularity = '32', merge_max_block_size = '32';

CREATE TABLE test
(
    id UInt64,
    json JSON
)
ENGINE = CoalescingMergeTree()
ORDER BY id
SETTINGS min_bytes_for_wide_part = '1', min_rows_for_wide_part = '1', index_granularity = '32', merge_max_block_size = '32';