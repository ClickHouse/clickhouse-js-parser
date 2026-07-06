-- Tags: no-fasttest
SET input_format_json_try_infer_named_tuples_from_objects = '0';

SET input_format_json_read_objects_as_strings = '0';

SELECT *
FROM format(JSONEachRow, '{"a" : {}}, {"a" : {"b" : 1}}');