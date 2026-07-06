SELECT CAST(1., 'Decimal(15,2)') > CAST(1 AS Float64);

SELECT CAST(1., 'Decimal(15,2)') = CAST(1 AS Float64);

SELECT CAST(1., 'Decimal(15,2)') < CAST(1 AS Float64);

SELECT CAST(1., 'Decimal(15,2)') != CAST(1 AS Float64);

SELECT CAST(1., 'Decimal(15,2)') > CAST(-1 AS Float64);

SELECT CAST(1., 'Decimal(15,2)') = CAST(-1 AS Float64);

SELECT CAST(1., 'Decimal(15,2)') < CAST(-1 AS Float64);

SELECT CAST(1., 'Decimal(15,2)') != CAST(-1 AS Float64);

SELECT CAST(1., 'Decimal(15,2)') > CAST(1 AS Float32);

SELECT CAST(1., 'Decimal(15,2)') = CAST(1 AS Float32);

SELECT CAST(1., 'Decimal(15,2)') < CAST(1 AS Float32);

SELECT CAST(1., 'Decimal(15,2)') != CAST(1 AS Float32);

SELECT CAST(1., 'Decimal(15,2)') > CAST(-1 AS Float32);

SELECT CAST(1., 'Decimal(15,2)') = CAST(-1 AS Float32);

SELECT CAST(1., 'Decimal(15,2)') < CAST(-1 AS Float32);

SELECT CAST(1., 'Decimal(15,2)') != CAST(-1 AS Float32);

SELECT toDecimal32('11.00', 2) > 1.;

SELECT CAST('0.1000000000000000055511151231257827021181583404541015625' AS Decimal256(70)) = 0.1;

DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    d1 Decimal32(5),
    d2 Decimal64(10),
    d3 Decimal128(30),
    d4 Decimal256(50),
    f1 Float32,
    f2 Float32
)
ENGINE = Memory();

INSERT INTO t;

INSERT INTO t;

SELECT d1 > f1
FROM t
ORDER BY f1 ASC;

SELECT d2 > f1
FROM t
ORDER BY f1 ASC;

SELECT d3 > f1
FROM t
ORDER BY f1 ASC;

SELECT d4 > f1
FROM t
ORDER BY f1 ASC;

SELECT d1 > f2
FROM t
ORDER BY f2 ASC;

SELECT d2 > f2
FROM t
ORDER BY f2 ASC;

SELECT d3 > f2
FROM t
ORDER BY f2 ASC;

SELECT d4 > f2
FROM t
ORDER BY f2 ASC;

DROP TABLE t;