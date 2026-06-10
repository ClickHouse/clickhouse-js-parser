-- Tags: no-parallel, no-fasttest
SET input_format_json_try_infer_numbers_from_strings = '1';

SELECT
    number,
    'Hello' AS str,
    range(number) AS arr
FROM numbers(3)
FORMAT JSONObjectEachRow;

INSERT INTO FUNCTION file(`02417_data`.jsonObjectEachRow) SELECT
    number,
    'Hello' AS str,
    range(number) AS arr
FROM numbers(3)
SETTINGS engine_file_truncate_on_insert = '1';

DESCRIBE TABLE file(`02417_data`.jsonObjectEachRow);

SELECT *
FROM file(`02417_data`.jsonObjectEachRow);