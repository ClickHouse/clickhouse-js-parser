SET allow_suspicious_low_cardinality_types = '1';

INSERT INTO FUNCTION file(concat(currentDatabase(), '.03004_data.bsonEachRow'), auto, 'null Nullable(UInt32)') SELECT number % 2 ? NULL : number
FROM numbers(5)
SETTINGS engine_file_truncate_on_insert = '1';

SELECT *
FROM file(concat(currentDatabase(), '.03004_data.bsonEachRow'), auto, 'null UInt32, foo UInt32');

SELECT *
FROM file(concat(currentDatabase(), '.03004_data.bsonEachRow'), auto, 'null UInt32, foo UInt32')
SETTINGS input_format_force_null_for_omitted_fields = '1'; -- { serverError TYPE_MISMATCH }

SELECT *
FROM file(concat(currentDatabase(), '.03004_data.bsonEachRow'), auto, 'null UInt32, foo Nullable(UInt32)');

SELECT *
FROM file(concat(currentDatabase(), '.03004_data.bsonEachRow'), auto, 'null UInt32, foo Nullable(UInt32)')
SETTINGS input_format_force_null_for_omitted_fields = '1';

SELECT *
FROM file(concat(currentDatabase(), '.03004_data.bsonEachRow'), auto, 'null UInt32, foo LowCardinality(Nullable(UInt32))');

SELECT *
FROM file(concat(currentDatabase(), '.03004_data.bsonEachRow'), auto, 'null UInt32, foo LowCardinality(Nullable(UInt32))')
SETTINGS input_format_force_null_for_omitted_fields = '1';

SELECT *
FROM format(JSONEachRow, 'foo UInt32', '{}');

SELECT *
FROM format(JSONEachRow, 'foo UInt32', '{}')
SETTINGS input_format_force_null_for_omitted_fields = '1'; -- { serverError TYPE_MISMATCH }

SELECT *
FROM format(JSONEachRow, 'foo UInt32, bar Nullable(UInt32)', '{}');

SELECT *
FROM format(JSONEachRow, 'foo UInt32, bar Nullable(UInt32)', '{"foo":1}');

SELECT *
FROM format(JSONEachRow, 'foo UInt32, bar Nullable(UInt32)', '{}')
SETTINGS input_format_force_null_for_omitted_fields = '1'; -- { serverError TYPE_MISMATCH }

SELECT *
FROM format(JSONEachRow, 'foo UInt32, bar Nullable(UInt32)', '{"foo":1}')
SETTINGS input_format_force_null_for_omitted_fields = '1';

SELECT *
FROM format(JSONEachRow, 'foo UInt32, bar LowCardinality(Nullable(UInt32))', '{"foo":1}');

SELECT *
FROM format(JSONEachRow, 'foo UInt32, bar LowCardinality(Nullable(UInt32))', '{"foo":1}')
SETTINGS input_format_force_null_for_omitted_fields = '1';

SELECT *
FROM format(CSVWithNamesAndTypes, 'foo UInt32, bar UInt32', 'foo\nUInt32\n1');

SELECT *
FROM format(CSVWithNamesAndTypes, 'foo UInt32, bar UInt32', 'foo\nUInt32\n1')
SETTINGS input_format_force_null_for_omitted_fields = '1'; -- { serverError TYPE_MISMATCH }

SELECT *
FROM format(CSVWithNamesAndTypes, 'foo UInt32, bar Nullable(UInt32)', 'foo\nUInt32\n1')
SETTINGS input_format_force_null_for_omitted_fields = '1';

SELECT *
FROM format(CSVWithNamesAndTypes, 'foo UInt32, bar LowCardinality(Nullable(UInt32))', 'foo\nUInt32\n1')
SETTINGS input_format_force_null_for_omitted_fields = '1';

SELECT *
FROM format(CSVWithNamesAndTypes, 'foo UInt32, bar UInt32', 'foo,bar\nUInt32,UInt32\n1,2\n3\n')
SETTINGS input_format_csv_allow_variable_number_of_columns = '1';

SELECT *
FROM format(CSVWithNamesAndTypes, 'foo UInt32, bar UInt32', 'foo,bar\nUInt32,UInt32\n1,2\n3\n')
SETTINGS
    input_format_csv_allow_variable_number_of_columns = '1',
    input_format_force_null_for_omitted_fields = '1'; -- { serverError TYPE_MISMATCH }

SELECT *
FROM format(TSVWithNamesAndTypes, 'foo UInt32, bar UInt32', 'foo\nUInt32\n1');

SELECT *
FROM format(TSVWithNamesAndTypes, 'foo UInt32, bar UInt32', 'foo\nUInt32\n1')
SETTINGS input_format_force_null_for_omitted_fields = '1'; -- { serverError TYPE_MISMATCH }

SELECT *
FROM format(TSVWithNamesAndTypes, 'foo UInt32, bar Nullable(UInt32)', 'foo\nUInt32\n1')
SETTINGS input_format_force_null_for_omitted_fields = '1';

SELECT *
FROM format(TSVWithNamesAndTypes, 'foo UInt32, bar LowCardinality(Nullable(UInt32))', 'foo\nUInt32\n1')
SETTINGS input_format_force_null_for_omitted_fields = '1';

SELECT *
FROM format(TSVWithNamesAndTypes, 'foo UInt32, bar UInt32', 'foo\tbar\nUInt32\tUInt32\n1\t2\n3\n')
SETTINGS input_format_tsv_allow_variable_number_of_columns = '1';

SELECT *
FROM format(TSVWithNamesAndTypes, 'foo UInt32, bar UInt32', 'foo\tbar\nUInt32\tUInt32\n1\t2\n3\n')
SETTINGS
    input_format_tsv_allow_variable_number_of_columns = '1',
    input_format_force_null_for_omitted_fields = '1'; -- { serverError TYPE_MISMATCH }

SELECT *
FROM format(TSKV, 'foo UInt32, bar UInt32', 'foo=1\n');

SELECT *
FROM format(TSKV, 'foo UInt32, bar UInt32', 'foo=1\n')
SETTINGS input_format_force_null_for_omitted_fields = '1'; -- { serverError TYPE_MISMATCH }

SELECT *
FROM format(TSKV, 'foo UInt32, bar Nullable(UInt32)', 'foo=1\n')
SETTINGS input_format_force_null_for_omitted_fields = '1';

SELECT *
FROM format(TSKV, 'foo UInt32, bar LowCardinality(Nullable(UInt32))', 'foo=1\n')
SETTINGS input_format_force_null_for_omitted_fields = '1';