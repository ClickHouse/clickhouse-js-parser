SELECT anyRespectNulls(number)
FROM numbers(5);

SELECT arrayReduce('anyRespectNulls', [NULL, 10]::Array(Nullable(UInt8)));

SELECT anyRespectNullsMerge(t)
FROM (
        SELECT anyRespectNullsState(NULL::Nullable(UInt8)) AS t
        FROM numbers(5)
    );

SELECT finalizeAggregation(CAST(unhex('01') AS AggregateFunction(anyRespectNulls, UInt64)));

SELECT anyRespectNullsIf(number, NOT isNull(number)
    AND assumeNotNull(number) > 5)
FROM numbers(10);

SELECT firstValueRespectNulls(number)
FROM numbers(5);

SELECT arrayReduce('firstValueRespectNulls', [NULL, 10]::Array(Nullable(UInt8)));

SELECT firstValueRespectNullsMerge(t)
FROM (
        SELECT firstValueRespectNullsState(NULL::Nullable(UInt8)) AS t
        FROM numbers(5)
    );

SELECT finalizeAggregation(CAST(unhex('01') AS AggregateFunction(firstValueRespectNulls, UInt64)));

SELECT firstValueRespectNullsIf(number, NOT isNull(number)
    AND assumeNotNull(number) > 5)
FROM numbers(10);

SELECT anyValueRespectNulls(number)
FROM numbers(5);

SELECT arrayReduce('anyValueRespectNulls', [NULL, 10]::Array(Nullable(UInt8)));

SELECT anyValueRespectNullsMerge(t)
FROM (
        SELECT anyValueRespectNullsState(NULL::Nullable(UInt8)) AS t
        FROM numbers(5)
    );

SELECT finalizeAggregation(CAST(unhex('01') AS AggregateFunction(anyValueRespectNulls, UInt64)));

SELECT anyValueRespectNullsIf(number, NOT isNull(number)
    AND assumeNotNull(number) > 5)
FROM numbers(10);

SELECT lastValueRespectNulls(number)
FROM numbers(5);

SELECT arrayReduce('lastValueRespectNulls', [10, NULL]::Array(Nullable(UInt8)));

SELECT lastValueRespectNullsMerge(t)
FROM (
        SELECT lastValueRespectNullsState(NULL::Nullable(UInt8)) AS t
        FROM numbers(5)
    );

SELECT finalizeAggregation(CAST(unhex('01') AS AggregateFunction(lastValueRespectNulls, UInt64)));

SELECT lastValueRespectNullsIf(number, NOT isNull(number)
    AND assumeNotNull(number) > 5)
FROM numbers(10);

SELECT anyLastRespectNulls(number)
FROM numbers(5);

SELECT arrayReduce('anyLastRespectNulls', [10, NULL]::Array(Nullable(UInt8)));

SELECT anyLastRespectNullsMerge(t)
FROM (
        SELECT anyLastRespectNullsState(NULL::Nullable(UInt8)) AS t
        FROM numbers(5)
    );

SELECT finalizeAggregation(CAST(unhex('01') AS AggregateFunction(anyLastRespectNulls, UInt64)));

SELECT anyLastRespectNullsIf(number, NOT isNull(number)
    AND assumeNotNull(number) > 5)
FROM numbers(10);