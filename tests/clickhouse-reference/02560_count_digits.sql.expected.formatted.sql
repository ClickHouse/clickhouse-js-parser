SELECT countDigits(0);

SELECT countDigits(1);

SELECT countDigits(-1);

SELECT countDigits(12345);

SELECT countDigits(-12345);

SELECT countDigits(18446744073709551615);

SELECT countDigits(CAST(9223372036854775808 AS Int64));

SELECT countDigits(CAST(-1 AS UInt128));

SELECT countDigits(CAST(-1 AS UInt256));

SELECT countDigits(CAST(CAST(-1 AS UInt128) DIV 2 + 1 AS Int128));

SELECT countDigits(CAST(CAST(-1 AS UInt256) DIV 2 + 1 AS Int256));

SELECT countDigits(CAST('-123.45678' AS Decimal32(5)));

SELECT countDigits(CAST('-123.456789' AS Decimal64(6)));

SELECT countDigits(CAST('-123.4567890' AS Decimal128(7)));

SELECT countDigits(CAST('-123.45678901' AS Decimal256(8)));

-- this behavior can be surprising, but actually reasonable:
SELECT countDigits(CAST('-123.456' AS Decimal32(5)));

SELECT countDigits(CAST('-123.4567' AS Decimal64(6)));

SELECT countDigits(CAST('-123.45678' AS Decimal128(7)));

SELECT countDigits(CAST('-123.456789' AS Decimal256(8)));