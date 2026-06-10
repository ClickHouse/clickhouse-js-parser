SELECT toTypeName(makeDate32(1991, 8));

SELECT toTypeName(makeDate32(CAST(1991 AS Nullable(UInt64)), 8));

SELECT toTypeName(makeDate32(1991, CAST(8 AS Nullable(UInt64))));

SELECT makeDate32(1900, 1);

SELECT makeDate32(2020, 8);

SELECT makeDate32(-1980, 10);

SELECT makeDate32(1980, -10);

SELECT makeDate32(1980., 9);

SELECT makeDate32(-1980., 9);

SELECT makeDate32(CAST(1980.1 AS Decimal(20, 5)), 9);

SELECT makeDate32(CAST('-1980.1' AS Decimal(20, 5)), 9);

SELECT makeDate32(CAST(1980.1 AS Float32), 9);

SELECT makeDate32(CAST(-1980.1 AS Float32), 9);

SELECT makeDate32(CAST(1980 AS Date), 10); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate32(CAST(-1980 AS Date), 10); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate32(CAST(1980 AS Date32), 10); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate32(CAST(-1980 AS Date32), 10); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate32(CAST(1980 AS DateTime), 10); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate32(CAST(-1980 AS DateTime), 10); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate32(CAST(1980 AS DateTime64), 10); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate32(CAST(-1980 AS DateTime64), 10); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate32('1980', '10'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate32('-1980', 3); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate32('aa', 3); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate32(1994, 'aa'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate32(0, 1);

SELECT makeDate32(19800, 12);

SELECT makeDate32(2299, 365);

SELECT makeDate32(2299, 366);

SELECT makeDate32(2300, 1);

SELECT makeDate32(1899, 365);

SELECT makeDate32(1899, 366);

SELECT makeDate32(1899, 367);

SELECT makeDate32(1900, 0);

SELECT makeDate32(1900, 1);

SELECT makeDate32(1900, 2);

SELECT makeDate32(NULL, 3);

SELECT makeDate32(1980, NULL);