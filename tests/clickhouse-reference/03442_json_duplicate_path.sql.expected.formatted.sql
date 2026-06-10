SELECT '{"a" : 42, "a" : {"b" : 42}}'::JSON; -- {serverError INCORRECT_DATA}

SELECT '{"a" : {"b" : 42}, "a" : 42}'::JSON; -- {serverError INCORRECT_DATA}

SELECT '{"a" : 42, "a" : {"b" : 42}}'::JSON
SETTINGS type_json_skip_duplicated_paths = '1';

SELECT '{"a" : {"b" : 42}, "a" : 42}'::JSON
SETTINGS type_json_skip_duplicated_paths = '1';