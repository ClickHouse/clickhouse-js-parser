-- Tags: no-fasttest
-- no-fasttest: json type needs rapidjson library, geo types need s2 geometry
SET enable_json_type = '1';

SET allow_suspicious_low_cardinality_types = '1';

SELECT '-- Const string + non-const arbitrary type';

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('42' AS Int8)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('43' AS Int16)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('44' AS Int32)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('45' AS Int64)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('46' AS Int128)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('47' AS Int256)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('48' AS UInt8)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('49' AS UInt16)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('50' AS UInt32)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('51' AS UInt64)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('52' AS UInt128)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('53' AS UInt256)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('42.42' AS Float32)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('43.43' AS Float64)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('44.44' AS Decimal(2))));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(true::Bool));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(false::Bool));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('foo'::String));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('bar'::FixedString(3)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('foo'::Nullable(String)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('bar'::Nullable(FixedString(3))));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('foo'::LowCardinality(String)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('bar'::LowCardinality(FixedString(3))));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('foo'::LowCardinality(Nullable(String))));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('bar'::LowCardinality(Nullable(FixedString(3)))));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('42' AS LowCardinality(Nullable(UInt32)))));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('42' AS LowCardinality(UInt32))));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('fae310ca-d52a-4923-9e9b-02bf67f4b009'::UUID));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('2023-11-14'::Date));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('2123-11-14'::Date32));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('2023-11-14 05:50:12'::DateTime('Europe/Amsterdam')));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('2023-11-14 05:50:12.123'::DateTime64(3, 'Europe/Amsterdam')));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('hallo'::Enum('hallo' = 1)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('[''foo'', ''bar'']' AS Array(String))));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('{"foo": "bar"}'::JSON));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('(42, ''foo'')' AS Tuple(Int32, String))));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(map(42, 'foo')::Map(Int32, String)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('122.233.64.201'::IPv4));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize('2001:0001:130F:0002:0003:09C0:876A:130B'::IPv6));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('(42, 43)' AS Point)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('[(0,0),(10,0),(10,10),(0,10)]' AS Ring)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('[[(20, 20), (50, 20), (50, 50), (20, 50)], [(30, 30), (50, 50), (50, 30)]]' AS Polygon)));

SELECT format('The {0} to all questions is {1}.', 'answer', materialize(CAST('[[[(0, 0), (10, 0), (10, 10), (0, 10)]], [[(20, 20), (50, 20), (50, 50), (20, 50)],[(30, 30), (50, 50), (50, 30)]]]' AS MultiPolygon)));

DROP TABLE IF EXISTS format_nested;

CREATE TABLE format_nested
(
    attrs Nested(k String, v String)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO format_nested;

SELECT format('The {0} to all questions is {1}.', attrs.k, attrs.v)
FROM format_nested;

DROP TABLE format_nested;

SELECT format('The {0} to all questions is {1}', NULL, NULL);

SELECT format('The {0} to all questions is {1}', NULL, materialize(NULL::Nullable(UInt64)));

SELECT format('The {0} to all questions is {1}', materialize(NULL::Nullable(UInt64)), materialize(NULL::Nullable(UInt64)));

SELECT format('The {0} to all questions is {1}', 42, materialize(NULL::Nullable(UInt64)));

SELECT format('The {0} to all questions is {1}', '42', materialize(NULL::Nullable(UInt64)));

SELECT format('The {0} to all questions is {1}', 42, materialize(NULL::Nullable(UInt64)), materialize(NULL::Nullable(UInt64)));

SELECT format('The {0} to all questions is {1}', '42', materialize(NULL::Nullable(UInt64)), materialize(NULL::Nullable(UInt64)));

SELECT format('The {0} to all questions is {1}', materialize('Non-const'), materialize(' strings'));

SELECT format('The {0} to all questions is {1}', 'Two arguments ', 'test');

SELECT format('The {0} to all questions is {1} and {2}', 'Three ', 'arguments', ' test');

SELECT format('The {0} to all questions is {1} and {2}', materialize(CAST('3' AS Int64)), ' arguments test', ' with int type');

SELECT format('The {0} to all questions is {1}', materialize(CAST('42' AS Int32)), materialize(CAST('144' AS UInt64)));

SELECT format('The {0} to all questions is {1} and {2}', materialize(CAST('42' AS Int32)), materialize(CAST('144' AS UInt64)), materialize(CAST('255' AS UInt32)));

SELECT format('The {0} to all questions is {1}', 42, 144);

SELECT format('The {0} to all questions is {1} and {2}', 42, 144, 255);

SELECT format('The answer to all questions is {0}.', 42);

SELECT format('The answer to all questions is {0}.', materialize(42));

SELECT format('The answer to all questions is {0}.', 'foo');

SELECT format('The answer to all questions is {0}.', materialize('foo'));

SELECT format('The answer to all questions is {0}.', NULL);

SELECT format('The answer to all questions is {0}.', materialize(NULL::Nullable(UInt64)));