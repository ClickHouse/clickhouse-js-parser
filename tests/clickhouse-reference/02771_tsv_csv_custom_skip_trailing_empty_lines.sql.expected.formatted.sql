SELECT *
FROM format(TSV, 'x UInt32, y UInt32', '1\t2\n\n')
SETTINGS input_format_tsv_skip_trailing_empty_lines = '0'; -- {serverError CANNOT_PARSE_INPUT_ASSERTION_FAILED}

SELECT *
FROM format(TSV, 'x UInt32, y UInt32', '1\t2\n\n')
SETTINGS input_format_tsv_skip_trailing_empty_lines = '1';

SELECT *
FROM format(TSV, 'x UInt32, y UInt32', '1\t2\n\n1\t2\n')
SETTINGS input_format_tsv_skip_trailing_empty_lines = '1'; -- {serverError CANNOT_PARSE_INPUT_ASSERTION_FAILED}

SELECT *
FROM format(CSV, 'x UInt32, y UInt32', '1,2\n\n')
SETTINGS input_format_csv_skip_trailing_empty_lines = '0'; -- {serverError CANNOT_PARSE_INPUT_ASSERTION_FAILED}

SELECT *
FROM format(CSV, 'x UInt32, y UInt32', '1,2\n\n')
SETTINGS input_format_csv_skip_trailing_empty_lines = '1';

SELECT *
FROM format(CSV, 'x UInt32, y UInt32', '1,2\n\n1,2\n')
SETTINGS input_format_csv_skip_trailing_empty_lines = '1'; -- {serverError CANNOT_PARSE_INPUT_ASSERTION_FAILED}

SELECT *
FROM format(CustomSeparated, 'x UInt32, y UInt32', '1\t2\n\n\n')
SETTINGS input_format_custom_skip_trailing_empty_lines = '0'; -- {serverError CANNOT_PARSE_INPUT_ASSERTION_FAILED}

SELECT *
FROM format(CustomSeparated, 'x UInt32, y UInt32', '1\t2\n\n\n')
SETTINGS input_format_custom_skip_trailing_empty_lines = '1';

SELECT *
FROM format(CustomSeparated, 'x UInt32, y UInt32', '1\t2\n\n\n1\t2\n\n\n')
SETTINGS input_format_custom_skip_trailing_empty_lines = '1'; -- {serverError CANNOT_PARSE_INPUT_ASSERTION_FAILED}