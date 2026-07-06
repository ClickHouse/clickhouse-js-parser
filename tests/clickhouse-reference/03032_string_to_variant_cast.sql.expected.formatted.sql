SET allow_experimental_variant_type = '1';

SELECT
    CAST('42' AS Variant(String, UInt64)) AS v,
    variantType(v);

SELECT
    CAST('abc' AS Variant(String, UInt64)) AS v,
    variantType(v);

SELECT
    CAST('null' AS Variant(String, UInt64)) AS v,
    variantType(v);

SELECT
    CAST('[1, 2, 3]' AS Variant(String, Array(UInt64))) AS v,
    variantType(v);

SELECT
    CAST('[1, 2, 3' AS Variant(String, Array(UInt64))) AS v,
    variantType(v);

SELECT
    CAST('42' AS Variant(Date)) AS v,
    variantType(v); -- {serverError INCORRECT_DATA}

SELECT
    accurateCastOrNull('42', 'Variant(Date)') AS v,
    variantType(v);

SELECT
    CAST('42'::FixedString(2) AS Variant(String, UInt64)) AS v,
    variantType(v);

SELECT
    CAST('42'::LowCardinality(String) AS Variant(String, UInt64)) AS v,
    variantType(v);

SELECT
    CAST('42'::Nullable(String) AS Variant(String, UInt64)) AS v,
    variantType(v);

SELECT
    CAST(NULL::Nullable(String) AS Variant(String, UInt64)) AS v,
    variantType(v);

SELECT
    CAST('42'::LowCardinality(Nullable(String)) AS Variant(String, UInt64)) AS v,
    variantType(v);

SELECT
    CAST(NULL::LowCardinality(Nullable(String)) AS Variant(String, UInt64)) AS v,
    variantType(v);

SELECT
    CAST(NULL::LowCardinality(Nullable(FixedString(2))) AS Variant(String, UInt64)) AS v,
    variantType(v);