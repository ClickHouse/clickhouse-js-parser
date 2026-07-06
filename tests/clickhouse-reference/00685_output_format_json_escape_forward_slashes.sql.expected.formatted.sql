-- Tags: no-fasttest
SET output_format_json_escape_forward_slashes = '1';

SELECT '/some/cool/url' AS url
FORMAT JSONEachRow;

SET output_format_json_escape_forward_slashes = '0';