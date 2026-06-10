--- Some aggregate functions use IColumn::serializeAggregationStateValueIntoArena
--- method for values serialization into aggregation states.
--- Aggregation states should not be changed for compatibility,
--- and this test should fail if something is changed in serializeAggregationStateValueIntoArena method.
SET session_timezone = 'UTC';

SELECT hex(approx_top_sumState(3)(['str'], 1));

SELECT hex(approx_top_kState(3)(['str']));

SELECT hex(topKState(3)(['str']));

SELECT hex(topKWeightedState(3)(['str'], 1));

SELECT hex(maxDistinctState(['str']));

SELECT hex(argMaxDistinctState(['str'], ['str']));

SELECT hex(groupUniqArrayState(['str']));

SELECT hex(groupArrayIntersectState(['str']));

--- Check different data types
SELECT hex(maxDistinctState(tuple('str', true)));

SELECT hex(maxDistinctState(tuple('str', CAST('42' AS Int8))));

SELECT hex(maxDistinctState(tuple('str', CAST('42' AS UInt8))));

SELECT hex(maxDistinctState(tuple('str', CAST('42' AS Int16))));

SELECT hex(maxDistinctState(tuple('str', CAST('42' AS UInt16))));

SELECT hex(maxDistinctState(tuple('str', CAST('42' AS Int32))));

SELECT hex(maxDistinctState(tuple('str', CAST('42' AS UInt32))));

SELECT hex(maxDistinctState(tuple('str', CAST('42' AS Int64))));

SELECT hex(maxDistinctState(tuple('str', CAST('42' AS UInt64))));

SELECT hex(maxDistinctState(tuple('str', CAST('42' AS Int128))));

SELECT hex(maxDistinctState(tuple('str', CAST('42' AS UInt128))));

SELECT hex(maxDistinctState(tuple('str', CAST('42' AS Int256))));

SELECT hex(maxDistinctState(tuple('str', CAST('42' AS UInt256))));

SELECT hex(maxDistinctState(tuple('str', CAST('42.42' AS BFloat16))));

SELECT hex(maxDistinctState(tuple('str', CAST('42.42' AS Float32))));

SELECT hex(maxDistinctState(tuple('str', CAST('42.42' AS Float64))));

SELECT hex(maxDistinctState(tuple('str', CAST('42.42' AS Decimal32(2)))));

SELECT hex(maxDistinctState(tuple('str', CAST('42.42' AS Decimal64(2)))));

SELECT hex(maxDistinctState(tuple('str', CAST('42.42' AS Decimal128(2)))));

SELECT hex(maxDistinctState(tuple('str', CAST('42.42' AS Decimal256(2)))));

SELECT hex(maxDistinctState(tuple('str', 'str'::Nullable(String))));

SELECT hex(maxDistinctState(tuple('str', 'str'::FixedString(3))));

SELECT hex(maxDistinctState(tuple('str', 'str'::Nullable(FixedString(3)))));

SELECT hex(maxDistinctState(tuple('str', 'str'::LowCardinality(String))));

SELECT hex(maxDistinctState(tuple('str', 'str'::LowCardinality(Nullable(String)))));

SELECT hex(maxDistinctState(tuple('str', 'str'::LowCardinality(FixedString(3)))));

SELECT hex(maxDistinctState(tuple('str', 'str'::LowCardinality(Nullable(FixedString(3))))));

SELECT hex(maxDistinctState(tuple('str', ['str'])));

SELECT hex(maxDistinctState(tuple('str', map('str', 'str'))));

SELECT hex(maxDistinctState(tuple('str', tuple('str'))));

SELECT hex(maxDistinctState(tuple('str', '{"str" : "str"}'::JSON)));

SELECT hex(maxDistinctState(tuple('str', '{"str" : "str"}'::JSON(max_dynamic_paths = 0))));

SELECT hex(maxDistinctState(tuple('str', '{"str" : "str"}'::JSON(str String))));

SELECT hex(maxDistinctState(tuple('str', 'str'::Variant(String))));

SELECT hex(maxDistinctState(tuple('str', 'str'::Dynamic)));

SELECT hex(maxDistinctState(tuple('str', 'str'::Dynamic(max_types = 0))));

SELECT hex(maxDistinctState(tuple('str', '59cd9014-8730-444c-95d0-40ed67c54268'::UUID)));

SELECT hex(maxDistinctState(tuple('str', '127.0.0.1'::IPv4)));

SELECT hex(maxDistinctState(tuple('str', '127.0.0.1'::IPv6)));

SELECT hex(maxDistinctState(tuple('str', '2020-01-01'::Date)));

SELECT hex(maxDistinctState(tuple('str', '2020-01-01'::Date32)));

SELECT hex(maxDistinctState(tuple('str', '2020-01-01'::DateTime)));

SELECT hex(maxDistinctState(tuple('str', '2020-01-01'::DateTime64)));

SELECT hex(maxDistinctState(tuple('str', 'a'::Enum8('a' = 1))));

SELECT hex(maxDistinctState(tuple('str', 'a'::Enum16('a' = 1))));