SET schema_inference_make_columns_nullable = '1';

SET input_format_json_try_infer_named_tuples_from_objects = '0';

SET input_format_json_read_objects_as_strings = '0';

SET input_format_json_infer_incomplete_types_as_strings = '0';

SET input_format_json_read_numbers_as_strings = '0';

SET input_format_json_infer_array_of_dynamic_from_array_of_different_types = '0';

DESCRIBE TABLE format(JSONEachRow, '{"x" : 1234}, {"x" : "String"}') SETTINGS input_format_json_try_infer_numbers_from_strings = '1'; -- { serverError CANNOT_EXTRACT_TABLE_STRUCTURE }

DESCRIBE TABLE format(JSONEachRow, '{"x" : [null, 1]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : [null, 1]}, {"x" : []}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : [null, 1]}, {"x" : [null]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : [null, 1]}, {"x" : [1, null]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : [null, 1]}, {"x" : ["abc", 1]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : [null, 1]}, {"x" : ["abc", null]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {}}, {"x" : {"a" : 1}}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"a" : null}}, {"x" : {"b" : 1}}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : null}, {"x" : [1, 2]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : [[], [null], [1, 2, 3]]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : [{"a" : null}, {"b" : 1}]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : [["2020-01-01", null, "1234"], ["abcd"]]}');

SET schema_inference_make_columns_nullable = 'auto';

DESCRIBE TABLE format(JSONEachRow, '{"x" : [1, 2]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : [1, 2]}, {"x" : [3]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : [1, 2]}, {"x" : [null]}');

DESCRIBE TABLE format(JSONCompactEachRow, '[1234], ["String"]') SETTINGS input_format_json_try_infer_numbers_from_strings = '1'; -- { serverError CANNOT_EXTRACT_TABLE_STRUCTURE }

DESCRIBE TABLE format(JSONCompactEachRow, '[[null, 1]]');

DESCRIBE TABLE format(JSONCompactEachRow, '[[null, 1]], [[]]');

DESCRIBE TABLE format(JSONCompactEachRow, '[[null, 1]], [[null]]');

DESCRIBE TABLE format(JSONCompactEachRow, '[[null, 1]], [[1, null]]');

DESCRIBE TABLE format(JSONCompactEachRow, '[[null, 1]], [["abc", 1]]');

DESCRIBE TABLE format(JSONCompactEachRow, '[[null, 1]], [["abc", null]]');

DESCRIBE TABLE format(JSONCompactEachRow, '[{}], [{"a" : 1}]');

DESCRIBE TABLE format(JSONCompactEachRow, '[{"a" : null}], [{"b" : 1}]');

DESCRIBE TABLE format(JSONCompactEachRow, '[null], [[1, 2]]');

DESCRIBE TABLE format(JSONCompactEachRow, '[[[], [null], [1, 2, 3]]]');

DESCRIBE TABLE format(JSONCompactEachRow, '[[{"a" : null}, {"b" : 1}]]');

DESCRIBE TABLE format(JSONCompactEachRow, '[[["2020-01-01", null, "1234"], ["abcd"]]]');

DESCRIBE TABLE format(JSONCompactEachRow, '[[1, 2]]');

DESCRIBE TABLE format(JSONCompactEachRow, '[[1, 2]], [[3]]');

DESCRIBE TABLE format(JSONCompactEachRow, '[[1, 2]], [[null]]');

DESCRIBE TABLE format(CSV, '"[null, 1]"');

DESCRIBE TABLE format(CSV, '"[null, 1]"\n"[]"');

DESCRIBE TABLE format(CSV, '"[null, 1]"\n"[null]"');

DESCRIBE TABLE format(CSV, '"[null, 1]"\n"[1, null]"');

DESCRIBE TABLE format(CSV, '"{}"\n"{''a'' : 1}"');

DESCRIBE TABLE format(CSV, '"{''a'' : null}"\n"{''b'' : 1}"');

DESCRIBE TABLE format(CSV, '"[[], [null], [1, 2, 3]]"');

DESCRIBE TABLE format(CSV, '"[{''a'' : null}, {''b'' : 1}]"');

DESCRIBE TABLE format(CSV, '"[[''2020-01-01'', null, ''1234''], [''abcd'']]"');

DESCRIBE TABLE format(CSV, '"[1,2]"');

DESCRIBE TABLE format(CSV, '"[1, 2]"\n"[3]"');

DESCRIBE TABLE format(CSV, '"[1, 2]"\n"[null]"');

SET schema_inference_make_columns_nullable = '0';

DESCRIBE TABLE format(CSV, '\\N,\\N,1\nb,\\N,1');

SET schema_inference_make_columns_nullable = '3';