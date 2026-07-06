SELECT '{"a": "not_an_int", "b": "valid", "c": 123}'::JSON(a Int64, b String, c Int32)
SETTINGS type_json_skip_invalid_typed_paths = '1';

SELECT '{"a": "not_an_int", "b": "valid", "c": 123}'::JSON(a Int64, b String, c Int32)
SETTINGS type_json_skip_invalid_typed_paths = '0'; -- { serverError INCORRECT_DATA }