SELECT CAST('0.1' AS Decimal(38, 38)) AS c;

EXPLAIN SYNTAX
SELECT CAST('0.1' AS Decimal(38, 38)) AS c;

SELECT CAST('[1, 2, 3]' AS Array(UInt32)) AS c;

EXPLAIN SYNTAX
SELECT CAST('[1, 2, 3]' AS Array(UInt32)) AS c;

SELECT 'abc'::FixedString(3) AS c;

EXPLAIN SYNTAX
SELECT 'abc'::FixedString(3) AS c;

SELECT CAST('123' AS String) AS c;

EXPLAIN SYNTAX
SELECT CAST('123' AS String) AS c;

SELECT CAST('1' AS Int8) AS c;

EXPLAIN SYNTAX
SELECT CAST('1' AS Int8) AS c;

SELECT [1, 1 + 1, 1 + 2]::Array(UInt32) AS c;

EXPLAIN SYNTAX
SELECT [1, 1 + 1, 1 + 2]::Array(UInt32) AS c;

SELECT '2010-10-10'::Date AS c;

EXPLAIN SYNTAX
SELECT '2010-10-10'::Date AS c;

SELECT '2010-10-10'::DateTime('UTC') AS c;

EXPLAIN SYNTAX
SELECT '2010-10-10'::DateTime('UTC') AS c;

SELECT CAST('[''2010-10-10'', ''2010-10-10'']' AS Array(Date)) AS c;

EXPLAIN SYNTAX
SELECT CAST('[''2010-10-10'', ''2010-10-10'']' AS Array(Date));

SELECT (1 + 2)::UInt32 AS c;

EXPLAIN SYNTAX
SELECT (1 + 2)::UInt32 AS c;

SELECT (CAST('0.1' AS Decimal(4, 4)) * 5)::Float64 AS c;

EXPLAIN SYNTAX
SELECT (CAST('0.1' AS Decimal(4, 4)) * 5)::Float64 AS c;

SELECT
    number::UInt8 AS c,
    toTypeName(c)
FROM numbers(1);

EXPLAIN SYNTAX
SELECT
    number::UInt8 AS c,
    toTypeName(c)
FROM numbers(1);

SELECT (0 + 1 + 2 + 3 + 4)::Date AS c;

EXPLAIN SYNTAX
SELECT (0 + 1 + 2 + 3 + 4)::Date AS c;

SELECT (CAST('0.1' AS Decimal(4, 4)) + CAST('0.2' AS Decimal(4, 4)) + CAST('0.3' AS Decimal(4, 4)))::Decimal(4, 4) AS c;

EXPLAIN SYNTAX
SELECT (CAST('0.1' AS Decimal(4, 4)) + CAST('0.2' AS Decimal(4, 4)) + CAST('0.3' AS Decimal(4, 4)))::Decimal(4, 4) AS c;

SELECT [[1][1]]::Array(UInt32);

SELECT CAST('[[1, 2, 3], [], [1]]' AS Array(Array(UInt32)));

SELECT CAST('[[], []]' AS Array(Array(UInt32)));