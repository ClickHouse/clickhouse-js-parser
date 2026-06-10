SELECT toDecimal32(1.1, 2) AS x
GROUP BY x;

SELECT toDecimal64(2.1, 4) AS x
GROUP BY x;

SELECT toDecimal128(3.1, 12) AS x
GROUP BY x;

SELECT materialize(toDecimal32(1.2, 2)) AS x
GROUP BY x;

SELECT materialize(toDecimal64(2.2, 4)) AS x
GROUP BY x;

SELECT materialize(toDecimal128(3.2, 12)) AS x
GROUP BY x;

SELECT x
FROM (
        SELECT toDecimal32(1.3, 2) AS x
    )
GROUP BY x;

SELECT x
FROM (
        SELECT toDecimal64(2.3, 4) AS x
    )
GROUP BY x;

SELECT x
FROM (
        SELECT toDecimal128(3.3, 12) AS x
    )
GROUP BY x;

DROP TABLE IF EXISTS decimal;

CREATE TABLE IF NOT EXISTS decimal
(
    A UInt64,
    B Decimal128(18),
    C Decimal128(18)
)
ENGINE = Memory();

INSERT INTO decimal;

SELECT
    A,
    toString(B) AS B_str,
    toString(SUM(C)) AS c_str
FROM decimal
GROUP BY
    A,
    B_str;

SELECT
    A,
    B_str,
    toString(cc)
FROM (
        SELECT
            A,
            toString(B) AS B_str,
            SUM(C) AS cc
        FROM decimal
        GROUP BY
            A,
            B_str
    );

DROP TABLE decimal;