-- Tags: no-fasttest
CREATE TABLE named_tuples
ENGINE = File(JSONEachRow)
SETTINGS output_format_json_named_tuples_as_objects = '1' AS
SELECT CAST(tuple(number, number * 2) AS Tuple(a int, b int)) AS c
FROM numbers(3);

SELECT *
FROM named_tuples
FORMAT JSONEachRow
SETTINGS output_format_json_named_tuples_as_objects = '1';

DROP TABLE named_tuples;