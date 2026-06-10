SET enable_analyzer = '1';

SET type_json_allow_duplicated_key_with_literal_and_nested_object = '1';

SELECT
    '{"a" : 42, "a" : {"b" : 42}}'::JSON AS json,
    json.a,
    json.a.b,
    json.^a;

SELECT
    '{"a" : {"b" : 42}, "a" : 42}'::JSON AS json,
    json.a,
    json.a.b,
    json.^a;

SELECT '{"a" : 42, "a" : {"b" : 42}, "a" : 42}'::JSON; -- {serverError INCORRECT_DATA}

SELECT '{"a" : 42, "a" : {"b" : 42}, "a" : {"c" : 42}}'::JSON; -- {serverError INCORRECT_DATA}