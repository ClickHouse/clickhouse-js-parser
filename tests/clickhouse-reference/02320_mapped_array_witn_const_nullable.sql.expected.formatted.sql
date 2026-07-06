SELECT arrayMap((x -> toNullable(1)), range(number))
FROM numbers(3);

SELECT arrayFilter((x -> toNullable(1)), range(number))
FROM numbers(3);

SELECT arrayMap((x -> toNullable(0)), range(number))
FROM numbers(3);

SELECT arrayFilter((x -> toNullable(0)), range(number))
FROM numbers(3);

SELECT arrayMap((x -> NULL::Nullable(UInt8)), range(number))
FROM numbers(3);

SELECT arrayFilter((x -> NULL::Nullable(UInt8)), range(number))
FROM numbers(3);