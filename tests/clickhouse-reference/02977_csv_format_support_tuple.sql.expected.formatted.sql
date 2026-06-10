SET output_format_csv_serialize_tuple_into_separate_columns = false;

SET input_format_csv_deserialize_separate_columns_into_tuple = false;

SET input_format_csv_try_infer_strings_from_quoted_tuples = false;

INSERT INTO FUNCTION file(currentDatabase() || '02977_1.csv') SELECT
    '20240305',
    1,
    ['s', 'd'],
    map('a', 2),
    tuple('222', 33, map('abc', 5))
SETTINGS engine_file_truncate_on_insert = '1';

DESCRIBE TABLE file(currentDatabase() || '02977_1.csv');

SELECT *
FROM file(currentDatabase() || '02977_1.csv')
SETTINGS max_threads = '1';