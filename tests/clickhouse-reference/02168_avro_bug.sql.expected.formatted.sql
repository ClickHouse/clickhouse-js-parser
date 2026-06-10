-- Tags: no-fasttest, no-parallel
INSERT INTO FUNCTION file('02168_avro_bug.avro', 'Parquet', 'x UInt64') SELECT *
FROM numbers(10)
SETTINGS engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file('02168_avro_bug.avro', 'Parquet', 'x UInt64') SELECT *
FROM numbers(10); -- { serverError CANNOT_APPEND_TO_FILE }