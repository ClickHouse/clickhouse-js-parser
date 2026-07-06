SELECT range(NULL);

SELECT range(10, NULL);

SELECT range(10, 2, NULL);

SELECT range('string', NULL);

SELECT range(toNullable(1));

SELECT range(CAST('0' AS Nullable(UInt64)), CAST('10' AS Nullable(UInt64)), CAST('2' AS Nullable(UInt64)));

SELECT range(CAST('0' AS Nullable(Int64)), CAST('10' AS Nullable(Int64)), CAST('2' AS Nullable(Int64)));

SELECT range(materialize(0), CAST('10' AS Nullable(UInt64)), CAST('2' AS Nullable(UInt64)));

SELECT range(NULL::Nullable(UInt64), CAST('10' AS Nullable(UInt64)), CAST('2' AS Nullable(UInt64))); -- { serverError BAD_ARGUMENTS }

SELECT range(CAST('0' AS Nullable(UInt64)), NULL::Nullable(UInt64), CAST('2' AS Nullable(UInt64))); -- { serverError BAD_ARGUMENTS }

SELECT range(CAST('0' AS Nullable(UInt64)), CAST('10' AS Nullable(UInt64)), NULL::Nullable(UInt64)); -- { serverError BAD_ARGUMENTS }

SELECT range(NULL::Nullable(UInt8), materialize(1)); -- { serverError BAD_ARGUMENTS }