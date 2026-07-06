SET enable_variant_type = '1';

SET allow_suspicious_variant_types = '1';

DROP TABLE IF EXISTS vf_null_only;

DROP TABLE IF EXISTS vf_one_variant_no_nulls;

DROP TABLE IF EXISTS vf_one_variant_with_nulls;

DROP TABLE IF EXISTS vf_multi_variant;

DROP TABLE IF EXISTS vf_array_one_variant_no_nulls;

DROP TABLE IF EXISTS vf_array_one_variant_with_nulls;

DROP TABLE IF EXISTS vf_array_multi_variant;

DROP TABLE IF EXISTS vf_equals;

DROP TABLE IF EXISTS vf_variant_nullable;

DROP TABLE IF EXISTS vf_two_variants_all_nulls;

DROP TABLE IF EXISTS vf_two_variants_single_no_nulls;

DROP TABLE IF EXISTS vf_two_variants_single_with_nulls;

DROP TABLE IF EXISTS vf_two_variants_multiple;

CREATE TABLE vf_null_only
(
    v Variant(UInt64, String)
)
ENGINE = Memory();

INSERT INTO vf_null_only;

SELECT toString(v)
FROM vf_null_only;

SELECT toTypeName(toString(v))
FROM vf_null_only
LIMIT 1;

CREATE TABLE vf_one_variant_no_nulls
(
    v Variant(UInt64, String)
)
ENGINE = Memory();

INSERT INTO vf_one_variant_no_nulls;

SELECT toString(v)
FROM vf_one_variant_no_nulls;

SELECT toTypeName(toString(v))
FROM vf_one_variant_no_nulls
LIMIT 1;

CREATE TABLE vf_one_variant_with_nulls
(
    v Variant(UInt64, String)
)
ENGINE = Memory();

INSERT INTO vf_one_variant_with_nulls;

SELECT toString(v)
FROM vf_one_variant_with_nulls;

SELECT toTypeName(toString(v))
FROM vf_one_variant_with_nulls
LIMIT 1;

CREATE TABLE vf_multi_variant
(
    v Variant(UInt64, String)
)
ENGINE = Memory();

INSERT INTO vf_multi_variant;

SELECT toString(v)
FROM vf_multi_variant;

SELECT toTypeName(toString(v))
FROM vf_multi_variant
LIMIT 1;

SELECT toString(v)
FROM vf_multi_variant
WHERE 0;

CREATE TABLE vf_array_one_variant_no_nulls
(
    v Variant(Array(UInt64), Array(String))
)
ENGINE = Memory();

INSERT INTO vf_array_one_variant_no_nulls;

SELECT arrayElement(v, 1)
FROM vf_array_one_variant_no_nulls;

SELECT toTypeName(arrayElement(v, 1))
FROM vf_array_one_variant_no_nulls
LIMIT 1;

CREATE TABLE vf_array_one_variant_with_nulls
(
    v Variant(Array(UInt64), Array(String))
)
ENGINE = Memory();

INSERT INTO vf_array_one_variant_with_nulls;

SELECT arrayElement(v, 1)
FROM vf_array_one_variant_with_nulls;

SELECT toTypeName(arrayElement(v, 1))
FROM vf_array_one_variant_with_nulls
LIMIT 1;

CREATE TABLE vf_array_multi_variant
(
    v Variant(Array(UInt64), Array(String))
)
ENGINE = Memory();

INSERT INTO vf_array_multi_variant;

SELECT arrayElement(v, 1)
FROM vf_array_multi_variant;

SELECT toTypeName(arrayElement(v, 1))
FROM vf_array_multi_variant
LIMIT 1;

-- equals with compatible types only (strict behavior)
CREATE TABLE vf_equals
(
    v Variant(UInt64, UInt32)
)
ENGINE = Memory();

INSERT INTO vf_equals;

SELECT
    toString(v),
    v = CAST(42 AS UInt64) AS is_42
FROM vf_equals;

SELECT
    toString(v),
    CAST(42 AS UInt64) = v AS is_42
FROM vf_equals;

CREATE TABLE vf_variant_nullable
(
    v Variant(Float32, UInt32),
    x Nullable(UInt32)
)
ENGINE = Memory();

INSERT INTO vf_variant_nullable;

SELECT v + x
FROM vf_variant_nullable;

SELECT toTypeName(v + x)
FROM vf_variant_nullable
LIMIT 1;

-- Multiple Variant arguments with nested Variant result
-- Test: Variant(UInt64, Decimal64(3)) + Variant(UInt64, Float64) -> Variant(UInt64, Decimal64(3), Float64)
CREATE TABLE vf_two_variants_all_nulls
(
    v1 Variant(UInt64, Decimal64(3)),
    v2 Variant(UInt64, Float64)
)
ENGINE = Memory();

INSERT INTO vf_two_variants_all_nulls;

SELECT v1 + v2
FROM vf_two_variants_all_nulls;

SELECT toTypeName(v1 + v2)
FROM vf_two_variants_all_nulls
LIMIT 1;

CREATE TABLE vf_two_variants_single_no_nulls
(
    v1 Variant(UInt64, Decimal64(3)),
    v2 Variant(UInt64, Float64)
)
ENGINE = Memory();

INSERT INTO vf_two_variants_single_no_nulls;

SELECT v1 + v2
FROM vf_two_variants_single_no_nulls;

SELECT toTypeName(v1 + v2)
FROM vf_two_variants_single_no_nulls
LIMIT 1;

CREATE TABLE vf_two_variants_single_with_nulls
(
    v1 Variant(UInt64, Decimal64(3)),
    v2 Variant(UInt64, Float64)
)
ENGINE = Memory();

INSERT INTO vf_two_variants_single_with_nulls;

SELECT v1 + v2
FROM vf_two_variants_single_with_nulls;

SELECT toTypeName(v1 + v2)
FROM vf_two_variants_single_with_nulls
LIMIT 1;

CREATE TABLE vf_two_variants_multiple
(
    v1 Variant(UInt64, Decimal64(3)),
    v2 Variant(UInt64, Float64)
)
ENGINE = Memory();

INSERT INTO vf_two_variants_multiple;

SELECT v1 + v2
FROM vf_two_variants_multiple;

SELECT toTypeName(v1 + v2)
FROM vf_two_variants_multiple
LIMIT 1;

DROP TABLE vf_null_only;

DROP TABLE vf_one_variant_no_nulls;

DROP TABLE vf_one_variant_with_nulls;

DROP TABLE vf_multi_variant;

DROP TABLE vf_array_one_variant_no_nulls;

DROP TABLE vf_array_one_variant_with_nulls;

DROP TABLE vf_array_multi_variant;

DROP TABLE vf_equals;

DROP TABLE vf_variant_nullable;

DROP TABLE vf_two_variants_all_nulls;

DROP TABLE vf_two_variants_single_no_nulls;

DROP TABLE vf_two_variants_single_with_nulls;

DROP TABLE vf_two_variants_multiple;