SET enable_analyzer = '1';

SELECT
    '{"a" : [{"b" : 42}]}'::JSON(a Array(JSON)) AS json,
    json.a.b,
    json::JSON AS json2,
    dynamicType(json2.a),
    json2.a.:`Array(JSON)`.b;

SELECT '{"transaction": {"date": "2025-03-13 22:20:29.751999"}}'::JSON::JSON(transaction Nullable(JSON(date DateTime64(6, 'UTC'))));