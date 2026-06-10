-- Tags: no-fasttest
SET enable_json_type = '1';

SELECT materialize('{}')::JSON;

SELECT materialize('{"a" : 42, "b" : "Hello"}')::JSON;

SELECT materialize('{"a" : {"b" : {"c" : {"d" : 42}, "e" : 43}, "f" : 44}, "g" : 44}')::JSON;

SELECT materialize('{"a" : {"b" : {"c" : {"d" : 42}, "e" : 43}, "f" : 44}, "g" : 44}')::JSON(`a.b.c.d` Bool);

SELECT materialize('{"a" : {"b" : {"c" : {"d" : 42}, "e" : 43}, "f" : 44}, "g" : 44}')::JSON(SKIP a.b.c.d);

SELECT materialize('{"a" : {"b" : {"c" : {"d" : 42}, "e" : 43}, "f" : 44}, "g" : 44}')::JSON(SKIP a.b.c);

SELECT materialize('{"a" : {"b" : {"c" : {"d" : 42}, "e" : 43}, "f" : 44}, "g" : 44}')::JSON(SKIP a.b);

SELECT materialize('{"a" : {"b" : {"c" : {"d" : 42}, "e" : 43}, "f" : 44}, "g" : 44}')::JSON(SKIP a);

SELECT materialize('{"a" : {"b" : {"c" : {"d" : 42}, "e" : 43}, "f" : 44}, "g" : 44}')::JSON(SKIP REGEXP '.*a.*b');

SELECT materialize('{"a" : {"b" : {"c" : {"d" : 42}, "e" : 43}, "f" : 44}, "g" : 44}')::JSON(SKIP REGEXP '.*a.*');

SELECT materialize('{"a" : {"b" : {"c" : {"d" : 42}, "e" : 43}, "f" : 44}, "g" : 44}')::JSON(SKIP REGEXP '.*');

SELECT
    materialize('{"a" : {"b" : {"c" : {"d" : 42}, "e" : 43}, "f" : 44}, "g" : 44}')::JSON AS json,
    JSONAllPathsWithTypes(json),
    JSONDynamicPathsWithTypes(json),
    JSONSharedDataPathsWithTypes(json);

SELECT
    materialize('{"a" : {"b" : {"c" : {"d" : 42}, "e" : 43}, "f" : 44}, "g" : 44}')::JSON(max_dynamic_paths = 2) AS json,
    JSONAllPathsWithTypes(json),
    JSONDynamicPathsWithTypes(json),
    JSONSharedDataPathsWithTypes(json);

SELECT
    materialize('{"a" : {"b" : {"c" : {"d" : 42}, "e" : 43}, "f" : 44}, "g" : 44}')::JSON(max_dynamic_paths = 1) AS json,
    JSONAllPathsWithTypes(json),
    JSONDynamicPathsWithTypes(json),
    JSONSharedDataPathsWithTypes(json);

SELECT
    materialize('{"a" : {"b" : {"c" : {"d" : 42}, "e" : 43}, "f" : 44}, "g" : 44}')::JSON(max_dynamic_paths = 0) AS json,
    JSONAllPathsWithTypes(json),
    JSONDynamicPathsWithTypes(json),
    JSONSharedDataPathsWithTypes(json);

SELECT
    materialize('{"a" : {"b" : {"c" : {"d" : 42}, "e" : 43}, "f" : 44}, "g" : 44}')::JSON(max_dynamic_paths = 2, max_dynamic_types = 0) AS json,
    JSONAllPathsWithTypes(json),
    JSONDynamicPathsWithTypes(json),
    JSONSharedDataPathsWithTypes(json);

SELECT
    materialize('{"a" : {"b" : {"c" : {"d" : 42}, "e" : 43}, "f" : 44}, "g" : 44}')::JSON(max_dynamic_paths = 1, max_dynamic_types = 0) AS json,
    JSONAllPathsWithTypes(json),
    JSONDynamicPathsWithTypes(json),
    JSONSharedDataPathsWithTypes(json);

SELECT
    materialize('{"a" : {"b" : {"c" : {"d" : 42}, "e" : 43}, "f" : 44}, "g" : 44}')::JSON(max_dynamic_paths = 0, max_dynamic_types = 0) AS json,
    JSONAllPathsWithTypes(json),
    JSONDynamicPathsWithTypes(json),
    JSONSharedDataPathsWithTypes(json);