SET input_format_json_read_bools_as_strings = '1';

SELECT *
FROM format(JSONEachRow, 'x String', '{"x" : true}, {"x" : false}, {"x" : "str"}');

SELECT *
FROM format(JSONEachRow, '{"x" : true}, {"x" : false}, {"x" : "str"}');

SELECT *
FROM format(JSONEachRow, 'x String', '{"x" : tru}'); -- {serverError CANNOT_PARSE_INPUT_ASSERTION_FAILED}

SELECT *
FROM format(JSONEachRow, 'x String', '{"x" : fals}'); -- {serverError CANNOT_PARSE_INPUT_ASSERTION_FAILED}

SELECT *
FROM format(JSONEachRow, 'x String', '{"x" : atru}'); -- {serverError INCORRECT_DATA}

SELECT *
FROM format(JSONEachRow, 'x Array(String)', '{"x" : [true, false]}, {"x" : [false, true]}, {"x" : ["str1", "str2"]}');

SELECT *
FROM format(JSONEachRow, '{"x" : [true, false]}, {"x" : [false, true]}, {"x" : ["str1", "str2"]}');