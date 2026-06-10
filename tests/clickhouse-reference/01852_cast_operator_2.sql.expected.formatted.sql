SELECT CAST('(0.1, 0.2)' AS Tuple(Decimal(75, 70), Decimal(75, 70)));

EXPLAIN SYNTAX
SELECT CAST('(0.1, 0.2)' AS Tuple(Decimal(75, 70), Decimal(75, 70)));

SELECT CAST('0.1' AS Decimal(4, 4));

EXPLAIN SYNTAX
SELECT CAST('0.1' AS Decimal(4, 4));

SELECT CAST('[1, 2, 3]' AS Array(Int32));

EXPLAIN SYNTAX
SELECT CAST('[1, 2, 3]' AS Array(Int32));

SELECT [CAST('1' AS UInt32), CAST('2' AS UInt32)]::Array(UInt64);

EXPLAIN SYNTAX
SELECT [CAST('1' AS UInt32), CAST('2' AS UInt32)]::Array(UInt64);

SELECT [CAST('[1, 2]' AS Array(UInt32)), [3]]::Array(Array(UInt64));

EXPLAIN SYNTAX
SELECT [CAST('[1, 2]' AS Array(UInt32)), [3]]::Array(Array(UInt64));

SELECT [[CAST('1' AS UInt16), CAST('2' AS UInt16)]::Array(UInt32), [3]]::Array(Array(UInt64));

EXPLAIN SYNTAX
SELECT [[CAST('1' AS UInt16), CAST('2' AS UInt16)]::Array(UInt32), [3]]::Array(Array(UInt64));

SELECT
    CAST('[(1, ''a''), (3, ''b'')]' AS Nested(u UInt8, s String)) AS t,
    toTypeName(t);