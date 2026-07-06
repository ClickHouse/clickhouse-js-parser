SET enable_analyzer = '1';

DESCRIBE TABLE format(JSONEachRow, '{"a" : [42, "hello", [1, 2, 3]]}');

SELECT
    a,
    toTypeName(a),
    arrayMap((x -> dynamicType(x)), a)
FROM format(JSONEachRow, '{"a" : [42, "hello", [1, 2, 3]]}');

DESCRIBE TABLE format(JSONEachRow, '{"a" : [42, "hello"]}');

SELECT
    a,
    toTypeName(a),
    arrayMap((x -> dynamicType(x)), a)
FROM format(JSONEachRow, '{"a" : [42, "hello"]}');

DESCRIBE TABLE format(JSONEachRow, '{"a" : [42, "hello", {"b" : 42}]}');

SELECT
    a,
    toTypeName(a),
    arrayMap((x -> dynamicType(x)), a)
FROM format(JSONEachRow, '{"a" : [42, "hello", {"b" : 42}]}');

SELECT
    '{"a" : [42, "hello", [1, 2, 3]]}'::JSON AS json,
    JSONAllPathsWithTypes(json),
    dynamicType(json.a),
    json.a.:`Array(Dynamic)`.Int64,
    json.a.:`Array(Dynamic)`.String,
    json.a.:`Array(Dynamic)`.`Array(Nullable(Int64))`;

SELECT
    '{"a" : [42, "hello", [1, 2, 3], {"b" : 42}]}'::JSON AS json,
    JSONAllPathsWithTypes(json),
    dynamicType(json.a),
    json.a.:`Array(Dynamic)`.Int64,
    json.a.:`Array(Dynamic)`.String,
    json.a.:`Array(Dynamic)`.`Array(Nullable(Int64))`,
    json.a.:`Array(Dynamic)`.JSON.b.:Int64;

SELECT
    '{"a" : [42, "hello", [1, 2, 3]]}'::JSON::JSON(a Array(String)) AS json,
    JSONAllPathsWithTypes(json);