SET output_format_pretty_display_footer_column_names = '0';

SET output_format_write_statistics = '0';

SELECT *
FROM numbers(100)
SETTINGS max_result_rows = '1'; -- { serverError TOO_MANY_ROWS_OR_BYTES }

SELECT *
FROM numbers(100)
FORMAT JSON
SETTINGS max_result_rows = '1'; -- { serverError TOO_MANY_ROWS_OR_BYTES }

SELECT *
FROM numbers(100)
FORMAT TSVWithNamesAndTypes
SETTINGS max_result_rows = '1'; -- { serverError TOO_MANY_ROWS_OR_BYTES }

SELECT *
FROM numbers(100)
FORMAT CSVWithNamesAndTypes
SETTINGS max_result_rows = '1'; -- { serverError TOO_MANY_ROWS_OR_BYTES }

SELECT *
FROM numbers(100)
FORMAT JSONCompactEachRowWithNamesAndTypes
SETTINGS max_result_rows = '1'; -- { serverError TOO_MANY_ROWS_OR_BYTES }

SELECT *
FROM numbers(100)
FORMAT XML
SETTINGS max_result_rows = '1'; -- { serverError TOO_MANY_ROWS_OR_BYTES }

SET max_result_rows = '1';

SELECT *
FROM numbers(10); -- { serverError TOO_MANY_ROWS_OR_BYTES }

SELECT *
FROM numbers(10)
SETTINGS
    result_overflow_mode = 'break',
    max_block_size = '1'
FORMAT PrettySpaceNoEscapes;

SELECT *
FROM numbers(10)
SETTINGS max_result_rows = '10';

SELECT *
FROM numbers(10)
FORMAT JSONCompact
SETTINGS max_result_rows = '10', output_format_write_statistics = '0';