-- Tags: no-fasttest
INSERT INTO FUNCTION file(currentDatabase() || '_03773.parquet') SELECT
    '{"a": 42}'::JSON AS j1,
    tuple(42, '{}') AS t,
    '{"b": 1337}'::JSON AS j2
SETTINGS engine_file_truncate_on_insert = '1';

SELECT
    toTypeName(j1),
    toTypeName(t),
    toTypeName(j2)
FROM file(currentDatabase() || '_03773.parquet')
SETTINGS input_format_parquet_use_native_reader_v3 = '0';

SELECT
    toTypeName(j1),
    toTypeName(t),
    toTypeName(j2)
FROM file(currentDatabase() || '_03773.parquet')
SETTINGS input_format_parquet_use_native_reader_v3 = '1';