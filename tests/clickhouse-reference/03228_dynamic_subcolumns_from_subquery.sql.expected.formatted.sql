SET allow_experimental_dynamic_type = '1';

SET enable_json_type = '1';

SET enable_analyzer = '1';

SELECT d.String
FROM (
        SELECT 'str'::Dynamic AS d
    );

SELECT json.a
FROM (
        SELECT '{"a" : 42}'::JSON AS json
    );

SELECT json.a
FROM (
        SELECT '{"a" : 42}'::JSON(a UInt32) AS json
    );

SELECT json.a.:Int64
FROM (
        SELECT materialize('{"a" : 42}')::JSON AS json
    );