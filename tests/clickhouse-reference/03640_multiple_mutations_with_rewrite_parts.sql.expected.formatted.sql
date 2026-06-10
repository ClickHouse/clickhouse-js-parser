DROP TABLE IF EXISTS test_materialize;

CREATE TABLE test_materialize
(
    part Int,
    key Int,
    value String
)
ENGINE = MergeTree()
ORDER BY key
PARTITION BY part
SETTINGS index_granularity = '100', use_const_adaptive_granularity = false, enable_index_granularity_compression = false, min_bytes_for_wide_part = '0';

INSERT INTO test_materialize SELECT
    intDiv(number, 5000),
    number,
    repeat('a', number)
FROM numbers(10000.)
SETTINGS
    max_block_size = '10',
    min_insert_block_size_rows = '10000';

-- { echoOn }
SELECT
    partition_id,
    `rows`,
    index_granularity_bytes_in_memory_allocated > 25
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'test_materialize'
    AND active
ORDER BY 1 ASC;

ALTER TABLE test_materialize MODIFY SETTING use_const_adaptive_granularity = true;

ALTER TABLE test_materialize ADD COLUMN new_value String;

ALTER TABLE test_materialize DELETE WHERE new_value != '';

ALTER TABLE test_materialize REWRITE PARTS SETTINGS mutations_sync = '2';

SELECT
    partition_id,
    `rows`,
    index_granularity_bytes_in_memory_allocated
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'test_materialize'
    AND active
ORDER BY 1 ASC;

ALTER TABLE test_materialize MODIFY SETTING use_const_adaptive_granularity = '0';

ALTER TABLE test_materialize REWRITE PARTS;

ALTER TABLE test_materialize DELETE WHERE key % 2 = 0 SETTINGS mutations_sync = '2';

SELECT *
FROM `system`.mutations
WHERE database = currentDatabase()
    AND NOT is_done
FORMAT Vertical;

ALTER TABLE test_materialize APPLY DELETED MASK, REWRITE PARTS;