-- this test is just like 02944_variant_as_common_type, but with different expected output, because
-- analyzer changes some return types. Specifically, if(c, x, y) always casts to the common type of
-- x and y, even if c is constant.
SET enable_analyzer = '1';

SET allow_experimental_variant_type = '1';

SET use_variant_as_common_type = '1';

SELECT
    toTypeName(res),
    if(1, [1, 2, 3], 'str_1') AS res;

SELECT
    toTypeName(res),
    if(1, [1, 2, 3], 'str_1'::Nullable(String)) AS res;

SELECT
    toTypeName(res),
    if(0, [1, 2, 3], 'str_1') AS res;

SELECT
    toTypeName(res),
    if(0, [1, 2, 3], 'str_1'::Nullable(String)) AS res;

SELECT
    toTypeName(res),
    if(NULL, [1, 2, 3], 'str_1') AS res;

SELECT
    toTypeName(res),
    if(NULL, [1, 2, 3], 'str_1'::Nullable(String)) AS res;

SELECT
    toTypeName(res),
    if(materialize(NULL::Nullable(UInt8)), [1, 2, 3], 'str_1') AS res;

SELECT
    toTypeName(res),
    if(materialize(NULL::Nullable(UInt8)), [1, 2, 3], 'str_1'::Nullable(String)) AS res;

SELECT
    toTypeName(res),
    if(1, materialize([1, 2, 3]), 'str_1') AS res;

SELECT
    toTypeName(res),
    if(1, materialize([1, 2, 3]), 'str_1'::Nullable(String)) AS res;

SELECT
    toTypeName(res),
    if(0, materialize([1, 2, 3]), 'str_1') AS res;

SELECT
    toTypeName(res),
    if(0, materialize([1, 2, 3]), 'str_1'::Nullable(String)) AS res;

SELECT
    toTypeName(res),
    if(NULL, materialize([1, 2, 3]), 'str_1') AS res;

SELECT
    toTypeName(res),
    if(NULL, materialize([1, 2, 3]), 'str_1'::Nullable(String)) AS res;

SELECT
    toTypeName(res),
    if(materialize(NULL::Nullable(UInt8)), materialize([1, 2, 3]), 'str_1') AS res;

SELECT
    toTypeName(res),
    if(materialize(NULL::Nullable(UInt8)), materialize([1, 2, 3]), 'str_1'::Nullable(String)) AS res;

SELECT
    toTypeName(res),
    if(1, [1, 2, 3], materialize('str_1')) AS res;

SELECT
    toTypeName(res),
    if(1, [1, 2, 3], materialize('str_1')::Nullable(String)) AS res;

SELECT
    toTypeName(res),
    if(0, [1, 2, 3], materialize('str_1')) AS res;

SELECT
    toTypeName(res),
    if(0, [1, 2, 3], materialize('str_1')::Nullable(String)) AS res;

SELECT
    toTypeName(res),
    if(NULL, [1, 2, 3], materialize('str_1')) AS res;

SELECT
    toTypeName(res),
    if(NULL, [1, 2, 3], materialize('str_1')::Nullable(String)) AS res;

SELECT
    toTypeName(res),
    if(materialize(NULL::Nullable(UInt8)), [1, 2, 3], materialize('str_1')) AS res;

SELECT
    toTypeName(res),
    if(materialize(NULL::Nullable(UInt8)), [1, 2, 3], materialize('str_1')::Nullable(String)) AS res;

SELECT
    toTypeName(res),
    if(0, range(number + 1), 'str_' || toString(number)) AS res
FROM numbers(4);

SELECT
    toTypeName(res),
    if(0, range(number + 1), ('str_' || toString(number))::Nullable(String)) AS res
FROM numbers(4);

SELECT
    toTypeName(res),
    if(1, range(number + 1), 'str_' || toString(number)) AS res
FROM numbers(4);

SELECT
    toTypeName(res),
    if(1, range(number + 1), ('str_' || toString(number))::Nullable(String)) AS res
FROM numbers(4);

SELECT
    toTypeName(res),
    if(NULL, range(number + 1), 'str_' || toString(number)) AS res
FROM numbers(4);

SELECT
    toTypeName(res),
    if(NULL, range(number + 1), ('str_' || toString(number))::Nullable(String)) AS res
FROM numbers(4);

SELECT
    toTypeName(res),
    if(materialize(NULL::Nullable(UInt8)), range(number + 1), 'str_' || toString(number)) AS res
FROM numbers(4);

SELECT
    toTypeName(res),
    if(materialize(NULL::Nullable(UInt8)), range(number + 1), ('str_' || toString(number))::Nullable(String)) AS res
FROM numbers(4);

SELECT
    toTypeName(res),
    if(number % 2, range(number + 1), 'str_' || toString(number)) AS res
FROM numbers(4);

SELECT
    toTypeName(res),
    if(number % 2, range(number + 1), ('str_' || toString(number))::Nullable(String)) AS res
FROM numbers(4);

SELECT
    toTypeName(res),
    if(number % 2, range(number + 1), ('str_' || toString(number))::LowCardinality(String)) AS res
FROM numbers(4);

SELECT
    toTypeName(res),
    if(number % 2, range(number + 1), ('str_' || toString(number))::LowCardinality(Nullable(String))) AS res
FROM numbers(4);

SELECT
    toTypeName(res),
    multiIf(number % 3 = 0, range(number + 1), number % 3 = 1, number, 'str_' || toString(number)) AS res
FROM numbers(6);

SELECT
    toTypeName(res),
    multiIf(number % 3 = 0, range(number + 1), number % 3 = 1, number, ('str_' || toString(number))::Nullable(String)) AS res
FROM numbers(6);

SELECT
    toTypeName(res),
    multiIf(number % 3 = 0, range(number + 1), number % 3 = 1, number, ('str_' || toString(number))::LowCardinality(String)) AS res
FROM numbers(6);

SELECT
    toTypeName(res),
    multiIf(number % 3 = 0, range(number + 1), number % 3 = 1, number, ('str_' || toString(number))::LowCardinality(Nullable(String))) AS res
FROM numbers(6);

SELECT
    toTypeName(res),
    array(1, 'str_1', 2, 'str_2') AS res;

SELECT
    toTypeName(res),
    array([1, 2, 3], ['str_1', 'str_2', 'str_3']) AS res;

SELECT
    toTypeName(res),
    array(array([1, 2, 3], ['str_1', 'str_2', 'str_3']), [1, 2, 3]) AS res;

SELECT
    toTypeName(res),
    array([1, 2, 3], [[1, 2, 3]]) AS res;

SELECT
    toTypeName(res),
    map('a', 1, 'b', 'str_1') AS res;

SELECT
    toTypeName(res),
    map('a', 1, 'b', map('c', 2, 'd', 'str_1')) AS res;

SELECT
    toTypeName(res),
    map('a', 1, 'b', [1, 2, 3], 'c', [[4, 5, 6]]) AS res;