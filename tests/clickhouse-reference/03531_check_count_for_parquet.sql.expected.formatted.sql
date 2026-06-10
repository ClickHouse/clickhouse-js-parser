-- Tags: no-fasttest, no-parallel
-- no-fasttest because of Parquet
-- no-parallel because we're writing a file with fixed name
SELECT count()
FROM url('http://localhost:11111/test/hive_partitioning/column0=Elizabeth/sample.parquet');

SELECT count()
FROM url('http://localhost:11111/test/hive_partitioning/column0=Elizabeth/sample.parquet')
WHERE column1 = 'meow';

INSERT INTO FUNCTION file('03531.parquet') SELECT *
FROM numbers(42)
SETTINGS
    engine_file_truncate_on_insert = '1',
    output_format_parquet_row_group_size = '10';

SELECT sleep(1); -- quirk in schema cache: cache is not used for up to 1s after file is written

SELECT count()
FROM file('03531.parquet');

SELECT count()
FROM file('03531.parquet')
WHERE number = 13;