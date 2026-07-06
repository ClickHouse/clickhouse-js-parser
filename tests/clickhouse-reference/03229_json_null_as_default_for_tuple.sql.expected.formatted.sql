SET enable_json_type = '1';

SET input_format_json_infer_array_of_dynamic_from_array_of_different_types = '0';

SELECT
    materialize('{"a" : [[1, {}], null]}')::JSON AS json,
    getSubcolumn(json, 'a'),
    dynamicType(getSubcolumn(json, 'a'));