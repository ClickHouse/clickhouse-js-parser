SET input_format_json_infer_array_of_dynamic_from_array_of_different_types = '0';

DESCRIBE TABLE format(JSONEachRow, '{"x" : [[42, null], [24, null]]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : [[[42, null], []], 24]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"key" : [42, null]}}');