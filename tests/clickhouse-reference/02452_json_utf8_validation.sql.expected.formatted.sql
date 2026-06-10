SET output_format_write_statistics = '0';

SET output_format_json_validate_utf8 = '1';

SELECT '� �' AS s
FORMAT JSONCompact;

SELECT '� �' AS s
FORMAT JSON;

SELECT '� �' AS s
FORMAT XML;

SELECT '� �' AS s
FORMAT JSONColumnsWithMetadata;

SELECT '� �' AS s
FORMAT JSONEachRow;

SELECT '� �' AS s
FORMAT JSONCompactEachRow;

SELECT '� �' AS s
FORMAT JSONColumns;

SELECT '� �' AS s
FORMAT JSONCompactColumns;

SELECT '� �' AS s
FORMAT JSONObjectEachRow;

SET output_format_json_validate_utf8 = '0';