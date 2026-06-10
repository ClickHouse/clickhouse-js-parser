SET allow_suspicious_low_cardinality_types = '0';

SET allow_suspicious_fixed_string_types = '0';

SELECT CAST('[42]' AS Array(LowCardinality(UInt64))); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

SELECT CAST('[[[42]]]' AS Array(Array(Array(LowCardinality(UInt64))))); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

SELECT map('a', 42)::Map(String, LowCardinality(UInt64)); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

SELECT map('a', map('b', [42]))::Map(String, Map(String, Array(LowCardinality(UInt64)))); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

SELECT tuple('a', 42)::Tuple(String, LowCardinality(UInt64)); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

SELECT tuple('a', [map('b', 42)])::Tuple(String, Array(Map(String, LowCardinality(UInt64)))); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

CREATE TABLE test
(
    x Array(LowCardinality(UInt64))
)
ENGINE = Memory(); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

CREATE TABLE test
(
    x Array(Array(LowCardinality(UInt64)))
)
ENGINE = Memory(); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

CREATE TABLE test
(
    x Map(String, LowCardinality(UInt64))
)
ENGINE = Memory(); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

CREATE TABLE test
(
    x Map(String, Map(String, LowCardinality(UInt64)))
)
ENGINE = Memory(); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

CREATE TABLE test
(
    x Tuple(String, LowCardinality(UInt64))
)
ENGINE = Memory(); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

CREATE TABLE test
(
    x Tuple(String, Array(Map(String, LowCardinality(UInt64))))
)
ENGINE = Memory(); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

SELECT CAST('[''42'']' AS Array(FixedString(1000000))); -- {serverError ILLEGAL_COLUMN}

SELECT CAST('[[[''42'']]]' AS Array(Array(Array(FixedString(1000000))))); -- {serverError ILLEGAL_COLUMN}

SELECT map('a', '42')::Map(String, FixedString(1000000)); -- {serverError ILLEGAL_COLUMN}

SELECT map('a', map('b', ['42']))::Map(String, Map(String, Array(FixedString(1000000)))); -- {serverError ILLEGAL_COLUMN}

SELECT tuple('a', '42')::Tuple(String, FixedString(1000000)); -- {serverError ILLEGAL_COLUMN}

SELECT tuple('a', [map('b', '42')])::Tuple(String, Array(Map(String, FixedString(1000000)))); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    x Array(FixedString(1000000))
)
ENGINE = Memory(); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    x Array(Array(FixedString(1000000)))
)
ENGINE = Memory(); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    x Map(String, FixedString(1000000))
)
ENGINE = Memory(); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    x Map(String, Map(String, FixedString(1000000)))
)
ENGINE = Memory(); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    x Tuple(String, FixedString(1000000))
)
ENGINE = Memory(); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    x Tuple(String, Array(Map(String, FixedString(1000000))))
)
ENGINE = Memory(); -- {serverError ILLEGAL_COLUMN}

SELECT CAST('42' AS Variant(String, LowCardinality(UInt64)))
SETTINGS allow_experimental_variant_type = '1'; -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

SELECT tuple('a', [map('b', 42)])::Tuple(String, Array(Map(String, Variant(LowCardinality(UInt64), String)))); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

CREATE TABLE test
(
    x Variant(LowCardinality(UInt64), String)
)
ENGINE = Memory(); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

CREATE TABLE test
(
    x Tuple(String, Array(Map(String, Variant(LowCardinality(UInt64), String))))
)
ENGINE = Memory(); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

SELECT '42'::Variant(UInt64, FixedString(1000000)); -- {serverError ILLEGAL_COLUMN}

SELECT tuple('a', [map('b', '42')])::Tuple(String, Array(Map(String, Variant(UInt32, FixedString(1000000))))); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    x Variant(UInt64, FixedString(1000000))
)
ENGINE = Memory(); -- {serverError ILLEGAL_COLUMN}