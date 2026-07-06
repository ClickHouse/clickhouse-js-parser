-- Test that FixedString respects the output_format_values_escape_quote_with_quote setting
-- This was broken: https://github.com/ClickHouse/ClickHouse/issues/73519
-- Default behavior (backslash escaping)
SELECT toFixedString('''', 4)
FORMAT Values;

SELECT toFixedString('foo''bar', 8)
FORMAT Values;

SELECT '\noutput_format_values_escape_quote_with_quote=1'
FORMAT LineAsString;

SET output_format_values_escape_quote_with_quote = '1';

-- Ensure no newline issues at end of file
SELECT ''
FORMAT LineAsString;