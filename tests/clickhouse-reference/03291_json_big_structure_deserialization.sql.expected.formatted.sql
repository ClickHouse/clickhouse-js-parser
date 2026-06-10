SET enable_json_type = '1';

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 0)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS max_compress_block_size = '128', marks_compress_block_size = '128', min_rows_for_wide_part = '1', min_bytes_for_wide_part = '1', index_granularity = '8192', replace_long_file_name_to_hash = '1';

INSERT INTO test SELECT toJSONString(map(repeat('a' || number, 5000), 42))
FROM numbers(10000);

SET max_threads = '1';

SET enable_filesystem_cache = '0';

SET max_parallel_replicas = '1';

SET remote_filesystem_read_method = 'read';

SET remote_filesystem_read_prefetch = '0';

SELECT json.a
FROM test
FORMAT Null;

DROP TABLE test;