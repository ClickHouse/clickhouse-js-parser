SET enable_analyzer = '1';

SET session_timezone = 'UTC';

SELECT '1970-01-01 00:00:01.000'::DateTime64(3)
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT CAST('[''1970-01-01 00:00:01.000'']' AS Array(DateTime64(3)))
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT map('a', '1970-01-01 00:00:01.000')::Map(String, DateTime64(3))
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT tuple('1970-01-01 00:00:01.000')::Tuple(d DateTime64(3))
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT '1970-01-01 00:00:01.000'::Variant(DateTime64(3))
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT '1970-01-01 00:00:01.000'::DateTime64(3)::Dynamic
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT '{"a" : "1970-01-01 00:00:01.000"}'::JSON(a DateTime64(3))
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT map('a', [tuple('1970-01-01 00:00:01.000')])::Map(String, Array(Tuple(d Variant(DateTime64(3)))))
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT '1970-01-01'::Date32::Dynamic
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT '1970-01-01'::Date::Dynamic
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT '1970-01-01 00:00:01'::DateTime::Dynamic
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT
    [tuple('1970-01-01')]::Array(Tuple(Date32))::Dynamic AS d,
    dynamicType(d)
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT
    [tuple('1970-01-01')]::Array(Tuple(Date))::Dynamic AS d,
    dynamicType(d)
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT
    [tuple('1970-01-01 00:00:01')]::Array(Tuple(DateTime))::Dynamic AS d,
    dynamicType(d)
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT
    [tuple('1970-01-01 00:00:01.00')]::Array(Tuple(DateTime64(3)))::Dynamic AS d,
    dynamicType(d)
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT
    '{"a" : 42, "b" : "1970-01-01", "c" : "1970-01-01 00:00:01", "d" : "1970-01-01 00:00:01.00"}'::JSON AS json,
    JSONAllPathsWithTypes(json)
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT
    map('a', ['{"a" : 42, "b" : "1970-01-01", "c" : "1970-01-01 00:00:01", "d" : "1970-01-01 00:00:01.00"}'])::Map(String, Array(Variant(JSON))) AS json,
    JSONAllPathsWithTypes(assumeNotNull(variantElement(json['a'][1], 'JSON')))
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT
    '{"a" : [{"aa" : [42]}]}'::JSON AS json,
    JSONAllPathsWithTypes(arrayJoin(json.a.:`Array(JSON)`))
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT
    '{"a" : [{"aa" : ["1970-01-01"]}]}'::JSON AS json,
    JSONAllPathsWithTypes(arrayJoin(json.a.:`Array(JSON)`))
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT
    '{"a" : [{"aa" : ["1970-01-01 00:00:01"]}]}'::JSON AS json,
    JSONAllPathsWithTypes(arrayJoin(json.a.:`Array(JSON)`))
FROM remote('127.0.0.{1,2}', 'system.one');

SELECT
    '{"a" : [{"aa" : ["1970-01-01 00:00:01.000"]}]}'::JSON AS json,
    JSONAllPathsWithTypes(arrayJoin(json.a.:`Array(JSON)`))
FROM remote('127.0.0.{1,2}', 'system.one');