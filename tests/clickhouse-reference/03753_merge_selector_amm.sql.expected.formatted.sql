-- Tags: long
DROP TABLE IF EXISTS mt SYNC;

CREATE TABLE mt
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY a
SETTINGS merge_selector_enable_heuristic_to_lower_max_parts_to_merge_at_once = '1', max_parts_to_merge_at_once = '10', parts_to_throw_insert = '50';

INSERT INTO mt SELECT
    number,
    number
FROM numbers(100)
SETTINGS
    max_block_size = '1',
    min_insert_block_size_bytes = '1';

SELECT count()
FROM mt;