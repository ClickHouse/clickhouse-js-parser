SELECT CAST('1.5' AS Decimal32(5)) + 1.5;

SELECT CAST('1.5' AS Decimal32(5)) - 1.5;

SELECT CAST('1.5' AS Decimal32(5)) * 1.5;

SELECT CAST('1.5' AS Decimal32(5)) / 1.5;

SELECT 1.5 + CAST('1.5' AS Decimal32(5));

SELECT 1.5 - CAST('1.5' AS Decimal32(5));

SELECT 1.5 * CAST('1.5' AS Decimal32(5));

SELECT 1.5 / CAST('1.5' AS Decimal32(5));

SELECT CAST('1.0' AS Decimal32(5)) / 0.;

SELECT least(1.5, CAST('1.0' AS Decimal32(5)));

SELECT greatest(1.5, CAST('1.0' AS Decimal32(5)));

DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    d1 Decimal32(5),
    d2 Decimal64(10),
    d3 Decimal128(20),
    d4 Decimal256(40),
    f1 Float32,
    f2 Float64
)
ENGINE = Memory();

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;

SELECT
    d1,
    f1,
    d1 + f1
FROM t
ORDER BY f1 ASC;

SELECT
    d2,
    f1,
    d2 + f1
FROM t
ORDER BY f1 ASC;

SELECT
    d3,
    f1,
    d3 + f1
FROM t
ORDER BY f1 ASC;

SELECT
    d4,
    f1,
    d4 + f1
FROM t
ORDER BY f1 ASC;

SELECT
    d1,
    f2,
    d1 + f2
FROM t
ORDER BY f2 ASC;

SELECT
    d2,
    f2,
    d2 + f2
FROM t
ORDER BY f2 ASC;

SELECT
    d3,
    f2,
    d3 + f2
FROM t
ORDER BY f2 ASC;

SELECT
    d4,
    f2,
    d4 + f2
FROM t
ORDER BY f2 ASC;

SELECT
    d1,
    f1,
    d1 - f1
FROM t
ORDER BY f1 ASC;

SELECT
    d2,
    f1,
    d2 - f1
FROM t
ORDER BY f1 ASC;

SELECT
    d3,
    f1,
    d3 - f1
FROM t
ORDER BY f1 ASC;

SELECT
    d4,
    f1,
    d4 - f1
FROM t
ORDER BY f1 ASC;

SELECT
    d1,
    f2,
    d1 - f2
FROM t
ORDER BY f2 ASC;

SELECT
    d2,
    f2,
    d2 - f2
FROM t
ORDER BY f2 ASC;

SELECT
    d3,
    f2,
    d3 - f2
FROM t
ORDER BY f2 ASC;

SELECT
    d4,
    f2,
    d4 - f2
FROM t
ORDER BY f2 ASC;

SELECT
    d1,
    f1,
    d1 * f1
FROM t
ORDER BY f1 ASC;

SELECT
    d2,
    f1,
    d2 * f1
FROM t
ORDER BY f1 ASC;

SELECT
    d3,
    f1,
    d3 * f1
FROM t
ORDER BY f1 ASC;

SELECT
    d4,
    f1,
    d4 * f1
FROM t
ORDER BY f1 ASC;

SELECT
    d1,
    f2,
    d1 * f2
FROM t
ORDER BY f2 ASC;

SELECT
    d2,
    f2,
    d2 * f2
FROM t
ORDER BY f2 ASC;

SELECT
    d3,
    f2,
    d3 * f2
FROM t
ORDER BY f2 ASC;

SELECT
    d4,
    f2,
    d4 * f2
FROM t
ORDER BY f2 ASC;

SELECT
    d1,
    f1,
    d1 / f1
FROM t
ORDER BY f1 ASC;

SELECT
    d2,
    f1,
    d2 / f1
FROM t
ORDER BY f1 ASC;

SELECT
    d3,
    f1,
    d3 / f1
FROM t
ORDER BY f1 ASC;

SELECT
    d4,
    f1,
    d4 / f1
FROM t
ORDER BY f1 ASC;

SELECT
    d1,
    f2,
    d1 / f2
FROM t
ORDER BY f2 ASC;

SELECT
    d2,
    f2,
    d2 / f2
FROM t
ORDER BY f2 ASC;

SELECT
    d3,
    f2,
    d3 / f2
FROM t
ORDER BY f2 ASC;

SELECT
    d4,
    f2,
    d4 / f2
FROM t
ORDER BY f2 ASC;

SELECT
    d1,
    f1,
    least(d1, f1)
FROM t
ORDER BY f1 ASC;

SELECT
    d2,
    f1,
    least(d2, f1)
FROM t
ORDER BY f1 ASC;

SELECT
    d3,
    f1,
    least(d3, f1)
FROM t
ORDER BY f1 ASC;

SELECT
    d4,
    f1,
    least(d4, f1)
FROM t
ORDER BY f1 ASC;

SELECT
    d1,
    f2,
    least(d1, f2)
FROM t
ORDER BY f2 ASC;

SELECT
    d2,
    f2,
    least(d2, f2)
FROM t
ORDER BY f2 ASC;

SELECT
    d3,
    f2,
    least(d3, f2)
FROM t
ORDER BY f2 ASC;

SELECT
    d4,
    f2,
    least(d4, f2)
FROM t
ORDER BY f2 ASC;

SELECT
    d1,
    f1,
    greatest(d1, f1)
FROM t
ORDER BY f1 ASC;

SELECT
    d2,
    f1,
    greatest(d2, f1)
FROM t
ORDER BY f1 ASC;

SELECT
    d3,
    f1,
    greatest(d3, f1)
FROM t
ORDER BY f1 ASC;

SELECT
    d4,
    f1,
    greatest(d4, f1)
FROM t
ORDER BY f1 ASC;

SELECT
    d1,
    f2,
    greatest(d1, f2)
FROM t
ORDER BY f2 ASC;

SELECT
    d2,
    f2,
    greatest(d2, f2)
FROM t
ORDER BY f2 ASC;

SELECT
    d3,
    f2,
    greatest(d3, f2)
FROM t
ORDER BY f2 ASC;

SELECT
    d4,
    f2,
    greatest(d4, f2)
FROM t
ORDER BY f2 ASC;

DROP TABLE t;