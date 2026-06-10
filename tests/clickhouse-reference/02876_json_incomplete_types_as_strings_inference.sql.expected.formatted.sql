SET input_format_json_infer_incomplete_types_as_strings = '1';

DESCRIBE TABLE format(JSONEachRow, '{"a" : null, "b" : {}, "c" : []}');

SELECT *
FROM format(JSONEachRow, '{"a" : null, "b" : {}, "c" : []}');

DESCRIBE TABLE format(JSONEachRow, '{"a" : {"b" : null, "c" : [[], []]}, "d" : {"e" : [{}, {}], "f" : null}}');

SELECT *
FROM format(JSONEachRow, '{"a" : {"b" : null, "c" : [[], []]}, "d" : {"e" : [{}, {}], "f" : null}}');