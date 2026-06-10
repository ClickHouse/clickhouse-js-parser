SET allow_experimental_dynamic_type = '1';

SET min_bytes_to_use_direct_io = '0';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    id UInt64,
    d Dynamic
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_rows_for_wide_part = '1', min_bytes_for_wide_part = '1', index_granularity = '1', use_adaptive_write_buffer_for_dynamic_subcolumns = '0', max_compress_block_size = '8', min_compress_block_size = '8', use_compact_variant_discriminators_serialization = '0';

INSERT INTO test SELECT
    number,
    '12345678'::LowCardinality(String)
FROM numbers(20);

SELECT d.`LowCardinality(String)`
FROM test
SETTINGS max_threads = '1';

DROP TABLE test;