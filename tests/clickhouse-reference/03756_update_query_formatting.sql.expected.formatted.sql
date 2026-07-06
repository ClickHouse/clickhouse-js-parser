CREATE TABLE `03756_update_query_formatting`
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY a
SETTINGS enable_block_number_column = '1', enable_block_offset_column = '1';