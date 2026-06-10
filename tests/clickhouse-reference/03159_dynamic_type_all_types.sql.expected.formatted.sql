-- Tags: no-random-settings
SET allow_experimental_dynamic_type = '1';

SET allow_experimental_variant_type = '1';

SET allow_suspicious_low_cardinality_types = '1';

SET allow_suspicious_types_in_order_by = '1';

CREATE TABLE t
(
    d Dynamic(max_types = 254)
)
ENGINE = Memory();

-- Integer types: signed and unsigned integers (UInt8, UInt16, UInt32, UInt64, UInt128, UInt256, Int8, Int16, Int32, Int64, Int128, Int256)
INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

-- Floating-point numbers: floats(Float32 and Float64) and Decimal values
INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

-- Strings: String and FixedString
INSERT INTO t; --(''::String),

-- Boolean
INSERT INTO t;

-- Dates: use Date and Date32 for days, and DateTime and DateTime64 for instances in time
INSERT INTO t;

-- UUID
INSERT INTO t;

INSERT INTO t;

-- LowCardinality
INSERT INTO t;

-- Arrays
INSERT INTO t;

-- Tuple
INSERT INTO t;

-- Map.
INSERT INTO t;

-- SimpleAggregateFunction
INSERT INTO t;

-- IPs
INSERT INTO t;

-- Geo
INSERT INTO t;

INSERT INTO t;

-- Interval
INSERT INTO t;

-- Nested
INSERT INTO t;

INSERT INTO t;

SELECT
    dynamicType(d),
    d
FROM t
ORDER BY
    substring(dynamicType(d), 1, 1) ASC,
    length(dynamicType(d)) ASC,
    d ASC;

CREATE TABLE t2
(
    d Dynamic(max_types = 254)
)
ENGINE = Memory();

INSERT INTO t2 SELECT *
FROM t;

SELECT
    dynamicType(d),
    d
FROM t2
ORDER BY
    substring(dynamicType(d), 1, 1) ASC,
    length(dynamicType(d)) ASC,
    d ASC;

SELECT uniqExact(dynamicType(d)) AS t_
FROM t;

SELECT uniqExact(dynamicType(d)) AS t_
FROM t2;