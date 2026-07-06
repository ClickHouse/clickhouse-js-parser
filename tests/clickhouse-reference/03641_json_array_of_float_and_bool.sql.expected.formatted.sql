SET enable_analyzer = '1';

SELECT
    '{"a" : [42.42, false]}'::JSON AS json,
    dynamicType(json.a)
SETTINGS input_format_json_read_bools_as_numbers = '1';

SELECT
    '{"a" : [42.42, false]}'::JSON AS json,
    dynamicType(json.a)
SETTINGS input_format_json_read_bools_as_numbers = '0';