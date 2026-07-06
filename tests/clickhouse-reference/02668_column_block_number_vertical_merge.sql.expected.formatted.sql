DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    id UInt32,
    a UInt32
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS enable_block_number_column = '1', enable_block_offset_column = '0', vertical_merge_algorithm_min_rows_to_activate = '1', vertical_merge_algorithm_min_columns_to_activate = '0', min_rows_for_wide_part = '1', min_bytes_for_wide_part = '1';

INSERT INTO test (id, a);

INSERT INTO test (id, a);

SELECT
    id,
    a,
    _block_number,
    _part
FROM test
ORDER BY id ASC;

SET mutations_sync = '1';

ALTER TABLE test UPDATE a = 0 WHERE id < 4;

OPTIMIZE TABLE test FINAL;

SELECT
    *,
    _block_number,
    _part
FROM test
ORDER BY id ASC;

INSERT INTO test (id, a);

DROP TABLE test;