SET allow_experimental_dynamic_type = '1';

SELECT 'Hello'::Dynamic(max_types = 1) AS d
FORMAT PrettyJSONEachRow;

SELECT 'Hello'::Dynamic(max_types = 0) AS d
FORMAT PrettyJSONEachRow;