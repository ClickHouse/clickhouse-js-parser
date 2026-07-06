SET input_format_json_try_infer_numbers_from_strings = '1';

DESCRIBE TABLE format(JSONEachRow, '{"x" : "20000101"}');

SELECT *
FROM format(JSONEachRow, '{"x" : "20000101"}');

SELECT *
FROM format(JSONEachRow, '{"x" : "19000101"}');