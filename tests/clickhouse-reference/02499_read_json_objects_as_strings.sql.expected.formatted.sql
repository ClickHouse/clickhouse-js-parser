-- Tags: no-fasttest
SET input_format_json_read_objects_as_strings = '1';

SET input_format_json_try_infer_named_tuples_from_objects = '0';

DESCRIBE TABLE format(JSONEachRow, '{"x" : "abc"}, {"x" : {"a" : 10, "b" : "abc"}}');

SELECT *
FROM format(JSONEachRow, '{"x" : "abc"}, {"x" : {"a" : 10, "b" : "abc"}}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"a" : "b"}}, {"x" : {"a" : 1, "b" : [1,2,3]}}');

SELECT *
FROM format(JSONEachRow, '{"x" : {"a" : "b"}}, {"x" : {"a" : 1, "b" : [1,2,3]}}');