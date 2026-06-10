SELECT
    toTypeName(first_value_respect_nullsState(dummy)),
    toTypeName(last_value_respect_nullsState(dummy))
FROM `system`.one;

SELECT first_value_respect_nullsMerge(t)
FROM (
        SELECT first_value_respect_nullsState(dummy) AS t
        FROM `system`.one
    );

SELECT first_value_respect_nullsMerge(t)
FROM (
        SELECT first_value_respect_nullsState(NULL::Nullable(UInt8)) AS t
        FROM `system`.one
    );

SELECT first_value_respect_nullsMerge(t)
FROM (
        SELECT first_value_respect_nullsState(number) AS t
        FROM numbers(5)
    );

SELECT first_value_respect_nullsMerge(t)
FROM (
        SELECT first_value_respect_nullsState(NULL::Nullable(UInt8)) AS t
        FROM numbers(5)
    );

SELECT last_value_respect_nullsMerge(t)
FROM (
        SELECT last_value_respect_nullsState(dummy) AS t
        FROM `system`.one
    );

SELECT last_value_respect_nullsMerge(t)
FROM (
        SELECT last_value_respect_nullsState(NULL::Nullable(UInt8)) AS t
        FROM `system`.one
    );

SELECT last_value_respect_nullsMerge(t)
FROM (
        SELECT last_value_respect_nullsState(number) AS t
        FROM numbers(5)
    );

SELECT last_value_respect_nullsMerge(t)
FROM (
        SELECT last_value_respect_nullsState(NULL::Nullable(UInt8)) AS t
        FROM numbers(5)
    );

SELECT first_value_respect_nullsMerge(t)
FROM (
        SELECT first_valueState(number) AS t
        FROM numbers(1)
    ); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT first_value_respect_nullsMerge(t)
FROM (
        SELECT last_value_respect_nullsState(number) AS t
        FROM numbers(1)
    ); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT last_value_respect_nullsMerge(t)
FROM (
        SELECT first_value_respect_nullsState(number) AS t
        FROM numbers(1)
    ); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT first_value_respect_nullsMerge(CAST(unhex('00') AS AggregateFunction(any, UInt64))); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

-- Invalid (starts at 1)
SELECT first_value_respect_nullsMerge(CAST(unhex('00') AS AggregateFunction(any_respect_nulls, UInt64))); -- { serverError INCORRECT_DATA }

-- Not set (Default value)
SELECT first_value_respect_nullsMerge(CAST(unhex('01') AS AggregateFunction(any_respect_nulls, UInt64)));

SELECT finalizeAggregation(CAST(unhex('01') AS AggregateFunction(any_respect_nulls, UInt64)));

-- Set to NULL
SELECT first_value_respect_nullsMerge(CAST(unhex('02') AS AggregateFunction(any_respect_nulls, UInt64))); -- { serverError INCORRECT_DATA }

SELECT first_value_respect_nullsMerge(CAST(unhex('02') AS AggregateFunction(any_respect_nulls, Nullable(UInt64))));

SELECT finalizeAggregation(CAST(unhex('02') AS AggregateFunction(any_respect_nulls, Nullable(UInt64))));

-- Set to other value, but without providing value
SELECT first_value_respect_nullsMerge(CAST(unhex('03') AS AggregateFunction(any_respect_nulls, UInt64))); -- { serverError CANNOT_READ_ALL_DATA }