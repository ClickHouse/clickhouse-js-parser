-- Tags: no-fasttest
INSERT INTO FUNCTION file(current_database() || '03630_parquet_bool_bug.parquet', Parquet, 'tags Array(Bool)') SETTINGS engine_file_truncate_on_insert = '1';

SELECT sum(tags)
FROM
    file(current_database() || '03630_parquet_bool_bug.parquet')
ARRAY JOIN tags
SETTINGS input_format_parquet_use_native_reader_v3 = '1';

-- Try all 256 1-byte masks to verify the bit shifting nonsense in PlainBooleanDecoder.
INSERT INTO FUNCTION file(current_database() || '03630_parquet_bool_bug.parquet') SELECT
    number AS n,
    arrayMap((i -> toBool(bitShiftRight(number, i) % 2 = 1)), range(8)) AS bits
FROM numbers(256)
SETTINGS engine_file_truncate_on_insert = '1';

SELECT sum(n = arraySum(arrayMap((i -> bitShiftLeft(bits[i + 1], i)), range(8)))) AS ok
FROM file(current_database() || '03630_parquet_bool_bug.parquet')
SETTINGS
    input_format_parquet_use_native_reader_v3 = '1',
    schema_inference_make_columns_nullable = '0';