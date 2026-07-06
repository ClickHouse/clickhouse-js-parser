-- Tags: no-replicated-database, no-random-merge-tree-settings
DROP TABLE IF EXISTS data_01641;

-- Disable cache for s3 storage tests because it increases memory usage.
SET enable_filesystem_cache = '0';

SET remote_filesystem_read_method = 'read';

SET local_filesystem_read_method = 'pread';

CREATE TABLE data_01641
(
    key Int,
    value String
)
ENGINE = MergeTree()
ORDER BY (key, repeat(value, 40))
SETTINGS old_parts_lifetime = '0', min_bytes_for_wide_part = '0';

SET max_block_size = '1000', min_insert_block_size_rows = '0', min_insert_block_size_bytes = '0';

INSERT INTO data_01641 SELECT
    number,
    toString(number)
FROM numbers(120000);

SET max_memory_usage = '10Mi', max_untracked_memory = '0';

-- It fails iff memory is tracked in OPTIMIZE query, but it doesn't. OPTIMIZE query doesn't rely on query context.
OPTIMIZE TABLE data_01641 FINAL;

DROP TABLE data_01641;