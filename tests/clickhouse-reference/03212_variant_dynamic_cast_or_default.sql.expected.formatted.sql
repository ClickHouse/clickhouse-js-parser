SET allow_experimental_variant_type = '1';

SET use_variant_as_common_type = '1';

SET allow_experimental_dynamic_type = '1';

SET allow_suspicious_low_cardinality_types = '1';

SET session_timezone = 'UTC';

SELECT
    accurateCastOrDefault(variant, 'UInt32'),
    multiIf(number % 4 = 0, NULL, number % 4 = 1, number, number % 4 = 2, 'str_' || toString(number), range(number)) AS variant
FROM numbers(8);

SELECT
    accurateCastOrNull(variant, 'UInt32'),
    multiIf(number % 4 = 0, NULL, number % 4 = 1, number, number % 4 = 2, 'str_' || toString(number), range(number)) AS variant
FROM numbers(8);

SELECT
    accurateCastOrDefault(dynamic, 'UInt32'),
    multiIf(number % 4 = 0, NULL, number % 4 = 1, number, number % 4 = 2, 'str_' || toString(number), range(number))::Dynamic AS dynamic
FROM numbers(8);

SELECT
    accurateCastOrNull(dynamic, 'UInt32'),
    multiIf(number % 4 = 0, NULL, number % 4 = 1, number, number % 4 = 2, 'str_' || toString(number), range(number))::Dynamic AS dynamic
FROM numbers(8);

DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    id UInt64 DEFAULT generateSerialID('03212_variant_seq'),
    d Dynamic
)
ENGINE = MergeTree()
ORDER BY id;

-- Integer types: signed and unsigned integers (UInt8, UInt16, UInt32, UInt64, UInt128, UInt256, Int8, Int16, Int32, Int64, Int128, Int256)
INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

-- Floating-point numbers: floats(Float32 and Float64) values
INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

INSERT INTO t (d);

-- Strings: String and FixedString
INSERT INTO t (d); --(''::String),

-- Boolean
INSERT INTO t (d);

-- UUID
INSERT INTO t (d);

INSERT INTO t (d);

-- LowCardinality
INSERT INTO t (d);

-- Arrays
INSERT INTO t (d);

-- Tuple
INSERT INTO t (d);

-- Map.
INSERT INTO t (d);

-- SimpleAggregateFunction
INSERT INTO t (d);

-- IPs
INSERT INTO t (d);

-- Geo
INSERT INTO t (d);

INSERT INTO t (d);

-- Interval
INSERT INTO t (d);

-- Nested
INSERT INTO t (d);

INSERT INTO t (d);

OPTIMIZE TABLE t FINAL;

WITH (
        SELECT count()
        FROM t
        WHERE accurateCastOrNull(d, 'IPv4') IS NOT NULL
            AND toIPv4(accurateCastOrNull(d, 'IPv4')) NOT IN (toIPv4('0.0.0.0'), toIPv4('192.168.0.1'))
    ) AS bad_v4,

(
        SELECT count()
        FROM t
        WHERE accurateCastOrNull(d, 'IPv6') IS NOT NULL
            AND toIPv6(accurateCastOrNull(d, 'IPv6')) NOT IN (toIPv6('::'), toIPv6('::1'), toIPv6('::ffff:192.168.0.1'))
    ) AS bad_v6,

bad_v4 + bad_v6 AS bad_cnt

SELECT
    'ch_dbg_summary' AS tag,
    (
        SELECT count()
        FROM t
    ) AS total,
    (
        SELECT count()
        FROM t
        WHERE accurateCastOrNull(d, 'IPv4') IS NOT NULL
    ) AS typed_v4,
    (
        SELECT count()
        FROM t
        WHERE accurateCastOrNull(d, 'IPv6') IS NOT NULL
    ) AS typed_v6,
    bad_v4,
    bad_v6,
    version() AS ver,
    getSetting('session_timezone') AS tz
WHERE bad_cnt > 0;

WITH (
        SELECT count()
        FROM t
        WHERE accurateCastOrNull(d, 'IPv4') IS NOT NULL
            AND toIPv4(accurateCastOrNull(d, 'IPv4')) NOT IN (toIPv4('0.0.0.0'), toIPv4('192.168.0.1'))
    ) + (
        SELECT count()
        FROM t
        WHERE accurateCastOrNull(d, 'IPv6') IS NOT NULL
            AND toIPv6(accurateCastOrNull(d, 'IPv6')) NOT IN (toIPv6('::'), toIPv6('::1'), toIPv6('::ffff:192.168.0.1'))
    ) AS bad_cnt

SELECT
    'ch_dbg_offenders' AS tag,
    id,
    toTypeName(d) AS src_type,
    toIPv4(accurateCastOrNull(d, 'IPv4')) AS v4,
    toIPv6(accurateCastOrNull(d, 'IPv6')) AS v6,
    toString(d) AS raw_d
FROM t
WHERE bad_cnt > 0
    AND (accurateCastOrNull(d, 'IPv4') IS NOT NULL
    AND toIPv4(accurateCastOrNull(d, 'IPv4')) NOT IN (toIPv4('0.0.0.0'), toIPv4('192.168.0.1'))
    OR accurateCastOrNull(d, 'IPv6') IS NOT NULL
    AND toIPv6(accurateCastOrNull(d, 'IPv6')) NOT IN (toIPv6('::'), toIPv6('::1'), toIPv6('::ffff:192.168.0.1')))
ORDER BY id ASC
LIMIT 20;

SELECT DISTINCT toInt8OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toUInt8OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toInt16OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toUInt16OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toInt32OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toUInt32OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toInt64OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toUInt64OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toInt128OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toUInt128OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toInt256OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toUInt256OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toFloat32OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toFloat64OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toDecimal32OrDefault(d, 3) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toDecimal64OrDefault(d, 3) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toDecimal128OrDefault(d, 3) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toDecimal256OrDefault(d, 3) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toDateOrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toDate32OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toDateTimeOrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toIPv4OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toIPv6OrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT DISTINCT toUUIDOrDefault(d) AS res
FROM t
ORDER BY res ASC;

SELECT d
FROM t
ORDER BY id ASC;

DROP TABLE t;