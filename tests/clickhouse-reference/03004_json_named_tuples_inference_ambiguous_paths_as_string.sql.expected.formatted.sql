SET input_format_json_use_string_type_for_ambiguous_paths_in_named_tuples_inference_from_objects = '1';

DESCRIBE TABLE format(JSONEachRow, '{"obj" : {"a" : 42}}, {"obj" : {"a" : {"b" : 42}}}');

SELECT *
FROM format(JSONEachRow, '{"obj" : {"a" : 42}}, {"obj" : {"a" : {"b" : 42}}}');