SELECT
    toDecimal32OrDefault(111, 3, CAST('123.456' AS Decimal32(3))) AS x,
    toTypeName(x);

SELECT
    toDecimal64OrDefault(222, 3, CAST('123.456' AS Decimal64(3))) AS x,
    toTypeName(x);

SELECT
    toDecimal128OrDefault(333, 3, CAST('123.456' AS Decimal128(3))) AS x,
    toTypeName(x);

SELECT
    toDecimal256OrDefault(444, 3, CAST('123.456' AS Decimal256(3))) AS x,
    toTypeName(x);

SELECT
    toDecimal32OrDefault('Hello', 3, CAST('123.456' AS Decimal32(3))) AS x,
    toTypeName(x);

SELECT
    toDecimal64OrDefault('Hello', 3, CAST('123.456' AS Decimal64(3))) AS x,
    toTypeName(x);

SELECT
    toDecimal128OrDefault('Hello', 3, CAST('123.456' AS Decimal128(3))) AS x,
    toTypeName(x);

SELECT
    toDecimal256OrDefault('Hello', 3, CAST('123.456' AS Decimal256(3))) AS x,
    toTypeName(x);