-- Tags: no-fasttest, no-parallel
-- Create an ~80 MB parquet file with one row group and one column.
INSERT INTO FUNCTION file('03147_parquet_memory_tracking.parquet') SELECT number
FROM numbers(10000000)
SETTINGS
    output_format_parquet_compression_method = 'none',
    output_format_parquet_row_group_size = '1000000000000',
    engine_file_truncate_on_insert = '1';

SET input_format_parquet_max_block_size = '10000000';

SET input_format_parquet_prefer_block_bytes = '1000000000000';

-- Try to read it with 60 MB memory limit. Should fail because we read the 80 MB column all at once.
SELECT sum(ignore(*))
FROM file('03147_parquet_memory_tracking.parquet')
SETTINGS max_memory_usage = '60000000'; -- { serverError MEMORY_LIMIT_EXCEEDED }

-- Try to read it with 500 MB memory limit, just in case.
SELECT sum(ignore(*))
FROM file('03147_parquet_memory_tracking.parquet')
SETTINGS max_memory_usage = '500000000';

-- Truncate the file to avoid leaving too much garbage behind.
INSERT INTO FUNCTION file('03147_parquet_memory_tracking.parquet') SELECT number
FROM numbers(1)
SETTINGS engine_file_truncate_on_insert = '1';