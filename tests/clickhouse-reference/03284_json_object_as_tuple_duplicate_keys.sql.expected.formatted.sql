SELECT *
FROM format(JSONEachRow, 'a Tuple(b UInt32)', '{"a" : {"b" : 1, "b" : 2}}'); -- {serverError INCORRECT_DATA}

SELECT *
FROM format(JSONEachRow, '{"a" : {"b" : 1, "b" : 2}}'); -- {serverError INCORRECT_DATA}

SELECT *
FROM format(JSONEachRow, '{"a" : {"b" : 1, "b" : 2, "b" : 3}, "c" : 42}'); -- {serverError INCORRECT_DATA}

SET input_format_json_use_string_type_for_ambiguous_paths_in_named_tuples_inference_from_objects = '1';

DESCRIBE TABLE format(JSONEachRow, '{"a" : {"b" : 1, "b" : "Hello"}}');

SELECT *
FROM format(JSONEachRow, '{"a" : {"b" : 1, "b" : "Hello"}}'); -- {serverError INCORRECT_DATA}

DESCRIBE TABLE format(JSONEachRow, '{"a" : {"b" : 1, "b" : {"c" : "Hello"}}}');

SELECT *
FROM format(JSONEachRow, '{"a" : {"b" : 1, "b" : {"c" : "Hello"}}}'); -- {serverError INCORRECT_DATA}