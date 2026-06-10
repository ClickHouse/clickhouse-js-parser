-- Tags: no-fasttest
CREATE TABLE test_02902
ENGINE = File(JSONEachRow)
SETTINGS output_format_json_named_tuples_as_objects = '1', output_format_json_skip_null_value_in_named_tuples = '1' AS
SELECT CAST((number::String, NULL, (number::String, NULL)) AS Tuple(a Nullable(String), b Nullable(Int64), c Tuple(x Nullable(String), y Nullable(Float64)))) AS c
FROM numbers(3);

SELECT *
FROM test_02902
FORMAT JSONEachRow
SETTINGS output_format_json_named_tuples_as_objects = '1', output_format_json_skip_null_value_in_named_tuples = '1';

SELECT *
FROM test_02902
FORMAT JSONEachRow
SETTINGS output_format_json_named_tuples_as_objects = '1', output_format_json_skip_null_value_in_named_tuples = '0';

DROP TABLE test_02902;

SELECT toJSONString(c)
FROM (
        SELECT CAST((number::String, NULL, (number::String, NULL)) AS Tuple(a Nullable(String), b Nullable(Int64), c Tuple(x Nullable(String), y Nullable(Float64)))) AS c
        FROM numbers(3)
    )
SETTINGS
    output_format_json_named_tuples_as_objects = '1',
    output_format_json_skip_null_value_in_named_tuples = '0';

SELECT toJSONString(c)
FROM (
        SELECT CAST((number::String, NULL, (number::String, NULL)) AS Tuple(a Nullable(String), b Nullable(Int64), c Tuple(x Nullable(String), y Nullable(Float64)))) AS c
        FROM numbers(3)
    )
SETTINGS
    output_format_json_named_tuples_as_objects = '1',
    output_format_json_skip_null_value_in_named_tuples = '1';