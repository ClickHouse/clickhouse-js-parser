-- Tags: no-fasttest, no-parallel
SET format_json_object_each_row_column_for_object_name = 'name';

SET input_format_json_try_infer_numbers_from_strings = '1';

SELECT
    number,
    concat('name_', toString(number)) AS name
FROM numbers(3)
FORMAT JSONObjectEachRow;

SELECT
    number,
    concat('name_', toString(number)) AS name,
    number + 1 AS x
FROM numbers(3)
FORMAT JSONObjectEachRow;

SELECT
    concat('name_', toString(number)) AS name,
    number
FROM numbers(3)
FORMAT JSONObjectEachRow;

INSERT INTO FUNCTION file(`02454_data`.jsonobjecteachrow) SELECT
    number,
    concat('name_', toString(number)) AS name
FROM numbers(3)
SETTINGS engine_file_truncate_on_insert = '1';

DESCRIBE TABLE file(`02454_data`.jsonobjecteachrow);

SELECT *
FROM file(`02454_data`.jsonobjecteachrow);