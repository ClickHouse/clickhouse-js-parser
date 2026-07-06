INSERT INTO FUNCTION file(`02453_data`.jsonl, TSV) SELECT 1
SETTINGS engine_file_truncate_on_insert = '1';

SELECT *
FROM file(`02453_data`.jsonl, auto, 'x UInt32')
SETTINGS
    input_format_allow_errors_num = '1',
    input_format_record_errors_file_path = '../error_file'; -- {serverError DATABASE_ACCESS_DENIED}