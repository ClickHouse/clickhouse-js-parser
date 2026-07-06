-- Tags: no-fasttest
SET output_format_parquet_use_custom_encoder = '1';

SET input_format_parquet_use_native_reader_v3 = '1';

SET engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(current_database() || '03596_parquet_prewhere_page_skip_bug.parquet') SELECT
    number AS n,
    number * 10 AS n10
FROM numbers(200)
SETTINGS
    output_format_parquet_data_page_size = '100',
    output_format_parquet_batch_size = '10',
    output_format_parquet_row_group_size = '100',
    output_format_parquet_write_page_index = '0';

SELECT n10
FROM file(current_database() || '03596_parquet_prewhere_page_skip_bug.parquet')
PREWHERE n IN (131, 174, 175, 176)
ORDER BY `all` ASC
SETTINGS
    input_format_parquet_page_filter_push_down = '0',
    input_format_parquet_filter_push_down = '0',
    input_format_parquet_bloom_filter_push_down = '0',
    input_format_parquet_max_block_size = '10';