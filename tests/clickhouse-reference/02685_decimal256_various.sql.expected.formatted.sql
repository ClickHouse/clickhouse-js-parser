-- { echoOn }
SELECT CAST('1.1' AS Decimal(60, 30));

SELECT round(CAST('1.1' AS Decimal(60, 30)));

SELECT round(CAST('1.1' AS Decimal(60, 30)), 1);

SELECT round(CAST('1.234567890123456789012345678901' AS Decimal(60, 30)), 1);

SELECT round(CAST('1.234567890123456789012345678901' AS Decimal(60, 30)), 30);

SELECT round(CAST('1.234567890123456789012345678901' AS Decimal(60, 30)), 31);

SELECT round(CAST('1.234567890123456789012345678901' AS Decimal(60, 30)), 20);

SELECT hex(CAST('1.234567890123456789012345678901' AS Decimal(60, 30)));

SELECT bin(CAST('1.234567890123456789012345678901' AS Decimal(60, 30)));

SELECT reinterpret(unhex(hex(CAST('1.234567890123456789012345678901' AS Decimal(60, 30)))), 'Decimal(60, 30)');

SELECT arraySum([CAST('1.2' AS Decimal(60, 30)), CAST('3.45' AS Decimal(61, 29))]);

SELECT arraySum([CAST('1.2' AS Decimal(60, 30)), CAST('3.45' AS Decimal(3, 2))]);

SELECT arrayMin([CAST('1.2' AS Decimal(60, 30)), CAST('3.45' AS Decimal(61, 29))]);

SELECT arrayMax([CAST('1.2' AS Decimal(60, 30)), CAST('3.45' AS Decimal(61, 29))]);

SELECT arrayAvg([CAST('1.2' AS Decimal(60, 30)), CAST('3.45' AS Decimal(61, 29))]);

SELECT round(arrayProduct([CAST('1.2' AS Decimal(60, 30)), CAST('3.45' AS Decimal(61, 29))]), 6);

SELECT toTypeName(arrayProduct([CAST('1.2' AS Decimal(60, 30)), CAST('3.45' AS Decimal(61, 29))]));

SELECT arrayCumSum([CAST('1.2' AS Decimal(60, 30)), CAST('3.45' AS Decimal(61, 29))]);

SELECT arrayCumSumNonNegative([CAST('1.2' AS Decimal(60, 30)), CAST('3.45' AS Decimal(61, 29))]);

SELECT arrayDifference([CAST('1.2' AS Decimal(60, 30)), CAST('3.45' AS Decimal(61, 29))]);

SELECT arrayCompact([CAST('1.2' AS Decimal(60, 30)) AS x, x, x, x, CAST('3.45' AS Decimal(3, 2)) AS y, y, x, x]);

SELECT CAST('1.2' AS Decimal(2, 1)) IN (CAST('1.2' AS Decimal(60, 30)), CAST('3.4' AS Decimal(60, 30)));

SELECT CAST('1.23' AS Decimal(3, 2)) IN (CAST('1.2' AS Decimal(60, 30)), CAST('3.4' AS Decimal(60, 30)));

SELECT CAST('1.2' AS Decimal(60, 30)) IN (CAST('1.2' AS Decimal(2, 1)));

SELECT toTypeName([CAST('1.2' AS Decimal(60, 30)), CAST('3.45' AS Decimal(3, 2))]);

SELECT toTypeName(arraySum([CAST('1.2' AS Decimal(60, 30)), CAST('3.45' AS Decimal(3, 2))]));

SELECT arrayJoin(sumMap(x))
FROM (
        SELECT [('Hello', CAST('1.2' AS Decimal256(30))), ('World', CAST('3.4' AS Decimal256(30)))]::Map(String, Decimal256(30)) AS x
        UNION ALL
        SELECT [('World', CAST('5.6' AS Decimal256(30))), ('GoodBye', CAST('-111.222' AS Decimal256(30)))]::Map(String, Decimal256(30))
    )
ORDER BY 1 ASC;

SELECT mapAdd(map('Hello', CAST('1.2' AS Decimal128(30)), 'World', CAST('3.4' AS Decimal128(30))), map('World', CAST('5.6' AS Decimal128(30)), 'GoodBye', CAST('-111.222' AS Decimal128(30))));

SELECT mapSubtract(map('Hello', CAST('1.2' AS Decimal128(30)), 'World', CAST('3.4' AS Decimal128(30))), map('World', CAST('5.6' AS Decimal128(30)), 'GoodBye', CAST('-111.222' AS Decimal128(30))));

SELECT arraySort(arrayIntersect(CAST('[1, 2, 3]' AS Array(UInt256)), CAST('[2, 3, 4]' AS Array(UInt256))));

SELECT toTypeName(arraySort(arrayIntersect(CAST('[1, 2, 3]' AS Array(UInt256)), CAST('[2, 3, 4]' AS Array(UInt128)))));

SELECT toTypeName(arraySort(arrayIntersect(CAST('[1, 2, 3]' AS Array(UInt256)), CAST('[2, 3, 4]' AS Array(Int128)))));

SELECT arraySort(arrayIntersect(CAST('[1, 2, 3]' AS Array(UInt256)), CAST('[2, 3, 4]' AS Array(Int128))));

SELECT arraySort(arrayIntersect(CAST('[1, 2, 3]' AS Array(UInt256)), CAST('[2, 3, 4]' AS Array(Int8))));

SELECT toTypeName(arraySort(arrayIntersect(CAST('[1, 2, 3]' AS Array(UInt256)), CAST('[2, 3, 4]' AS Array(Int8)))));

SELECT arraySort(arrayIntersect([CAST('1.1' AS Decimal256(70)), CAST('2.34' AS Decimal256(60)), CAST('3.456' AS Decimal256(50))], [CAST('2.34' AS Decimal256(65)), CAST('3.456' AS Decimal256(55)), CAST('4.5678' AS Decimal256(45))]));

SELECT arraySort(arrayIntersect([CAST('1.1' AS Decimal256(1))], [CAST('1.12' AS Decimal256(2))])); -- Note: this is correct but the semantics has to be clarified in the docs.

SELECT arraySort(arrayIntersect([CAST('1.1' AS Decimal256(2))], [CAST('1.12' AS Decimal256(2))]));

SELECT arraySort(arrayIntersect([CAST('1.1' AS Decimal128(1))], [CAST('1.12' AS Decimal128(2))])); -- Note: this is correct but the semantics has to be clarified in the docs.

SELECT arraySort(arrayIntersect([CAST('1.1' AS Decimal128(2))], [CAST('1.12' AS Decimal128(2))]));

SELECT coalesce(CAST('123' AS Nullable(Decimal(20, 10))), 0);

SELECT coalesce(CAST('123' AS Nullable(Decimal(40, 10))), 0);

SELECT coalesce(CAST('123' AS Decimal(40, 10)), 0);

DROP TABLE IF EXISTS decimal_insert_cast_issue;

CREATE TABLE decimal_insert_cast_issue
(
    a Decimal(76, 0)
)
ENGINE = TinyLog();

SET param_param = '1';

INSERT INTO decimal_insert_cast_issue;

SELECT *
FROM decimal_insert_cast_issue;

DROP TABLE decimal_insert_cast_issue;