-- Tags: no-fasttest
SET engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(current_database() || '03624_parquet_row_number.parquet') SELECT number * 10 AS x
FROM numbers(20)
SETTINGS
    max_threads = '1',
    output_format_parquet_row_group_size = '5';

SELECT
    _row_number,
    x
FROM file(current_database() || '03624_parquet_row_number.parquet')
WHERE x % 3 != 0
    AND x > 60
ORDER BY _row_number ASC;