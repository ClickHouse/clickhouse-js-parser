SELECT toDecimal128(42.42, 5) AS d
FORMAT JSONEachRow
SETTINGS output_format_json_quote_decimals = '1';

INSERT INTO FUNCTION file(`02421_data`.jsonl) SELECT '42.42' AS d
SETTINGS engine_file_truncate_on_insert = '1';

SELECT *
FROM file(`02421_data`.jsonl, auto, 'd Decimal32(3)');