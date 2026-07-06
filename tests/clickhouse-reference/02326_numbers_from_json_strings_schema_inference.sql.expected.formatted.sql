-- Tags: no-fasttest
SET input_format_json_try_infer_numbers_from_strings = '1';

SET input_format_json_read_numbers_as_strings = '0';

SET input_format_json_infer_array_of_dynamic_from_array_of_different_types = '0';

DESCRIBE TABLE format(JSONEachRow, '{"x" : "123"}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : ["123", 123, 12.3]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"k1" : "123", "k2" : 123}}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"k1" : ["123", "123"], "k2" : [123, 123]}}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : "123"}\n{"x" : 123}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : ["123", "456"]}\n{"x" : [123, 456]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"k1" : "123"}}\n{"x" : {"k2" : 123}}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"k1" : ["123", "123"]}}\n{"x": {"k2" : [123, 123]}}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : ["123", "Some string"]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"k1" : "123", "k2" : "Some string"}}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"k1" : ["123", "123"], "k2" : ["Some string"]}}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : "123"}\n{"x" : "Some string"}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : ["123", "456"]}\n{"x" : ["Some string"]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"k1" : "123"}}\n{"x" : {"k2" : "Some string"}}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"k1" : ["123", "123"]}}\n{"x": {"k2" : ["Some string"]}}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : [123, "Some string"]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"a" : 123, "b" : "Some string"}}');