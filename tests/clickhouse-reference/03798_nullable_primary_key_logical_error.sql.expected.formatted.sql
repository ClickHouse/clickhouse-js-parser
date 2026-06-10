DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    x FixedString(3),
    y Nullable(Int16)
)
ENGINE = MergeTree()
ORDER BY x
PARTITION BY y
SETTINGS allow_nullable_key = '1';

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

SELECT DISTINCT minDistinct(toDecimalString(77 IS NOT NULL, isZeroOrNull(toNullable(1) IS NOT NULL))) IGNORE NULLS
FROM t;