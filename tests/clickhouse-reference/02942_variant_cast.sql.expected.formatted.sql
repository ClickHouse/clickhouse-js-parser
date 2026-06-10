SET allow_experimental_variant_type = '1';

SELECT NULL::Variant(String, UInt64);

SELECT CAST('42' AS UInt64)::Variant(String, UInt64);

SELECT CAST('42' AS UInt32)::Variant(String, UInt64); -- {serverError CANNOT_CONVERT_TYPE}

SELECT now()::Variant(String, UInt64); -- {serverError CANNOT_CONVERT_TYPE}

SELECT CAST(number % 2 ? NULL : number AS Variant(String, UInt64))
FROM numbers(4);

SELECT 'Hello'::LowCardinality(String)::Variant(LowCardinality(String), UInt64);

SELECT 'Hello'::LowCardinality(Nullable(String))::Variant(LowCardinality(String), UInt64);

SELECT 'NULL'::LowCardinality(Nullable(String))::Variant(LowCardinality(String), UInt64);

SELECT CAST(CAST(number % 2 ? NULL : 'Hello' AS LowCardinality(Nullable(String))) AS Variant(LowCardinality(String), UInt64))
FROM numbers(4);

SELECT NULL::Variant(String, UInt64)::UInt64;

SELECT NULL::Variant(String, UInt64)::Nullable(UInt64);

SELECT '42'::Variant(String, UInt64)::UInt64;

SELECT 'str'::Variant(String, UInt64)::UInt64; -- {serverError CANNOT_PARSE_TEXT}

SELECT CAST(multiIf(number % 3 = 0, NULL::Variant(String, UInt64), number % 3 = 1, 'Hello'::Variant(String, UInt64), number::Variant(String, UInt64)) AS Nullable(String))
FROM numbers(6);

SELECT CAST(multiIf(number = 1, NULL::Variant(String, UInt64), number = 2, 'Hello'::Variant(String, UInt64), number::Variant(String, UInt64)) AS UInt64)
FROM numbers(6); -- {serverError CANNOT_PARSE_TEXT}

SELECT number::Variant(UInt64)::Variant(String, UInt64)::Variant(Array(String), String, UInt64)
FROM numbers(2);

SELECT 'str'::Variant(String, UInt64)::Variant(String, Array(UInt64)); -- {serverError CANNOT_CONVERT_TYPE}