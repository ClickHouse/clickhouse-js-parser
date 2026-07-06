SELECT
    CAST('42424.4242424242' AS Float64) AS x,
    [CAST('42.42' AS Float64), CAST('42.42' AS Float64)] AS arr,
    tuple(CAST('42.42' AS Float64)) AS tuple
FORMAT JSONEachRow
SETTINGS output_format_json_quote_64bit_floats = '1';

SELECT
    CAST('42424.4242424242' AS Float64) AS x,
    [CAST('42.42' AS Float64), CAST('42.42' AS Float64)] AS arr,
    tuple(CAST('42.42' AS Float64)) AS tuple
FORMAT JSONEachRow
SETTINGS output_format_json_quote_64bit_floats = '0';