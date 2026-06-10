SELECT toTypeName(makeDate(1991, 8));

SELECT toTypeName(makeDate(CAST(1991 AS Nullable(UInt64)), 8));

SELECT toTypeName(makeDate(1991, CAST(8 AS Nullable(UInt64))));

SELECT makeDate(1970, 1);

SELECT makeDate(2020, 8);

SELECT makeDate(-1980, 10);

SELECT makeDate(1980, -10);

SELECT makeDate(1980., 9);

SELECT makeDate(-1980., 9);

SELECT makeDate(CAST(1980.1 AS Decimal(20, 5)), 9);

SELECT makeDate(CAST('-1980.1' AS Decimal(20, 5)), 9);

SELECT makeDate(CAST(1980.1 AS Float32), 9);

SELECT makeDate(CAST(-1980.1 AS Float32), 9);

SELECT makeDate(CAST(1980 AS Date), 10); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate(CAST(-1980 AS Date), 10); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate(CAST(1980 AS Date32), 10); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate(CAST(-1980 AS Date32), 10); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate(CAST(1980 AS DateTime), 10); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate(CAST(-1980 AS DateTime), 10); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate(CAST(1980 AS DateTime64), 10); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate(CAST(-1980 AS DateTime64), 10); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate('1980', '10'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate('-1980', 3); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate('aa', 3); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate(1994, 'aa'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT makeDate(0, 1);

SELECT makeDate(19800, 12);

SELECT makeDate(2149, 157);

SELECT makeDate(2149, 158);

SELECT makeDate(1969, 355);

SELECT makeDate(1969, 356);

SELECT makeDate(1969, 357);

SELECT makeDate(1970, 0);

SELECT makeDate(1970, 1);

SELECT makeDate(1970, 2);

SELECT makeDate(NULL, 3);

SELECT makeDate(1980, NULL);