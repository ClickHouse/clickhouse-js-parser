SET allow_experimental_dynamic_type = '1';

SET allow_experimental_variant_type = '1';

SET use_variant_as_common_type = '1';

SELECT
    number::Dynamic AS d,
    dynamicType(d)
FROM numbers(3);

SELECT
    number::Dynamic(max_types = 0) AS d,
    dynamicType(d)
FROM numbers(3);

SELECT number::Dynamic::UInt64 AS v
FROM numbers(3);

SELECT number::Dynamic::String AS v
FROM numbers(3);

SELECT number::Dynamic::Date AS v
FROM numbers(3);

SELECT number::Dynamic::Array(UInt64) AS v
FROM numbers(3); -- {serverError TYPE_MISMATCH}

SELECT
    number::Dynamic::Variant(UInt64, String) AS v,
    variantType(v)
FROM numbers(3);

SELECT
    (number % 2 ? NULL : number)::Dynamic AS d,
    dynamicType(d)
FROM numbers(3);

SELECT
    multiIf(number % 4 = 0, number, number % 4 = 1, 'str_' || toString(number), number % 4 = 2, range(number), NULL)::Dynamic AS d,
    dynamicType(d)
FROM numbers(6);

SELECT
    multiIf(number % 4 = 0, number, number % 4 = 1, 'str_' || toString(number), number % 4 = 2, range(number), NULL)::Dynamic(max_types = 0) AS d,
    dynamicType(d)
FROM numbers(6);

SELECT
    multiIf(number % 4 = 0, number, number % 4 = 1, 'str_' || toString(number), number % 4 = 2, range(number), NULL)::Dynamic(max_types = 1) AS d,
    dynamicType(d)
FROM numbers(6);

SELECT
    multiIf(number % 4 = 0, number, number % 4 = 1, 'str_' || toString(number), number % 4 = 2, range(number), NULL)::Dynamic(max_types = 2) AS d,
    dynamicType(d)
FROM numbers(6);

SELECT number::Dynamic(max_types = 2)::Dynamic(max_types = 3) AS d
FROM numbers(3);

SELECT number::Dynamic(max_types = 2)::Dynamic(max_types = 1) AS d
FROM numbers(3);

SELECT
    multiIf(number % 4 = 0, number, number % 4 = 1, 'str_' || toString(number), number % 4 = 2, range(number), NULL)::Dynamic(max_types = 2)::Dynamic(max_types = 1) AS d,
    dynamicType(d)
FROM numbers(6);

SELECT
    multiIf(number % 4 = 0, number, number % 4 = 1, toDate(number), number % 4 = 2, range(number), NULL)::Dynamic(max_types = 4)::Dynamic(max_types = 3) AS d,
    dynamicType(d)
FROM numbers(6);

CREATE TABLE test
(
    d Dynamic
)
ENGINE = Memory();

INSERT INTO test;

SELECT d::Float64
FROM test;

SELECT d::Nullable(Float64)
FROM test;

SELECT d::String
FROM test;

SELECT d::Nullable(String)
FROM test;

SELECT d::UInt64
FROM test; -- {serverError CANNOT_PARSE_TEXT}

SELECT d::Nullable(UInt64)
FROM test;

SELECT d::Date
FROM test; -- {serverError CANNOT_PARSE_DATE}