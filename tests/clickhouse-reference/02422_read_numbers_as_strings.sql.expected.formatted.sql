-- Tags: no-fasttest
SET input_format_json_read_numbers_as_strings = '1';

SET input_format_json_infer_array_of_dynamic_from_array_of_different_types = '0';

SELECT *
FROM format(JSONEachRow, '{"x" : 123}\n{"x" : "str"}');

SELECT *
FROM format(JSONEachRow, '{"x" : [123, "str"]}');

SELECT *
FROM format(JSONEachRow, '{"x" : [123, "456"]}\n{"x" : ["str", "rts"]}');