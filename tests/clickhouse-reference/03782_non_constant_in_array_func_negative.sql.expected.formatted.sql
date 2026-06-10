SET allow_experimental_analyzer = '1';

SELECT '-- Basic arrayMap tests --';

-- { echoOn }
-- Simple arrayMap identity
SELECT 1 IN (arrayMap((x -> x), [1]));

SELECT 1 IN (arrayMap((x -> x), [2]));

SELECT 1 IN (arrayMap((x -> x), [1, 2, 3]));

-- arrayMap with transformation
SELECT 2 IN (arrayMap((x -> x + 1), [1, 2, 3]));

SELECT 5 IN (arrayMap((x -> x * 2), [1, 2, 3]));

-- arrayMap with column reference
SELECT
    number,
    number IN (arrayMap((x -> x), [0, 2, 4]))
FROM numbers(5);

SELECT
    number,
    number IN (arrayMap((x -> x + number), [0, 1, 2]))
FROM numbers(3);

SELECT 2 IN (arrayFilter((x -> x > 1), [1, 2, 3]));

SELECT 1 IN (arrayFilter((x -> x > 1), [1, 2, 3]));

SELECT
    number,
    number IN (arrayFilter((x -> x % 2 = 0), [0, 1, 2, 3, 4]))
FROM numbers(5);

SELECT 3 IN (arrayConcat([1, 2], [3, 4]));

SELECT 5 IN (arrayConcat([1, 2], [3, 4]));

SELECT
    number,
    number IN (arrayConcat([0, 1], [number, number + 1]))
FROM numbers(3);

-- arrayReverse
SELECT 1 IN (arrayReverse([3, 2, 1]));

SELECT 4 IN (arrayReverse([3, 2, 1]));

-- arrayDistinct
SELECT 1 IN (arrayDistinct([1, 1, 2, 2, 3]));

SELECT 4 IN (arrayDistinct([1, 1, 2, 2, 3]));

-- arraySlice
SELECT 2 IN (arraySlice([1, 2, 3, 4], 2, 2));

SELECT 1 IN (arraySlice([1, 2, 3, 4], 2, 2));

-- arrayShuffle (deterministic seed)
SELECT 1 IN (arrayShuffle([1, 2, 3], 42));

-- range function
SELECT 5 IN (range(10));

SELECT 15 IN (range(10));

SELECT
    number,
    number IN (range(5))
FROM numbers(7);

SELECT 4 IN (arrayMap((x -> x * 2), arrayFilter((y -> y > 0), [0, 1, 2, 3])));

SELECT 1 IN (arrayMap((x -> x * 2), arrayFilter((y -> y > 0), [0, 1, 2, 3])));

SELECT
    number,
    number IN (arrayMap((x -> x + 1), arrayFilter((y -> y < number), [0, 1, 2, 3, 4])))
FROM numbers(5);

SET transform_null_in = '0';

-- NULL in arrayMap result
SELECT NULL IN (arrayMap((x -> x), [1, 2, 3]));

SELECT NULL IN (arrayMap((x -> x), [1, NULL, 3]));

SELECT 1 IN (arrayMap((x -> x), [1, NULL, 3]));

-- Nullable element search
SELECT toNullable(1) IN (arrayMap((x -> x), [1, 2, 3]));

SELECT toNullable(1) IN (arrayMap((x -> toNullable(x)), [1, 2, 3]));

-- NULL in array with column
SELECT
    number,
    NULL IN (arrayMap((x -> x), [number, number + 1]))
FROM numbers(2);

SELECT
    number,
    toNullable(number) IN (arrayMap((x -> x), [0, 1, 2]))
FROM numbers(3);

SET transform_null_in = '1';

-- Int vs UInt
SELECT CAST('1' AS Int32) IN (arrayMap((x -> x), [CAST('1' AS UInt64), CAST('2' AS UInt64)]));

SELECT CAST('-1' AS Int32) IN (arrayMap((x -> x), [CAST('1' AS UInt64), CAST('2' AS UInt64)]));

-- Float vs Int
SELECT 1. IN (arrayMap((x -> x), [1, 2, 3]));

SELECT 1.5 IN (arrayMap((x -> x), [1, 2, 3]));

-- String
SELECT 'a' IN (arrayMap((x -> x), ['a', 'b', 'c']));

SELECT 'd' IN (arrayMap((x -> x), ['a', 'b', 'c']));

-- Mixed types in arrayConcat
SELECT 1 IN (arrayConcat([CAST('1' AS Int32)], [CAST('2' AS Int64)]));

-- Empty array
SELECT 1 IN (arrayMap((x -> x), []));

SELECT 1 IN (arrayFilter((x -> x > 100), [1, 2, 3]));

SELECT 2 IN (arrayMap((x -> x), [1]));

-- Large array
SELECT 500 IN (range(1000));

SELECT 1500 IN (range(1000));

-- Array with duplicates
SELECT 1 IN (arrayMap((x -> 1), [1, 2, 3]));

-- Expression on left side
SELECT 1 + 1 IN (arrayMap((x -> x), [2, 3, 4]));

SELECT
    number * 2,
    number * 2 IN (arrayMap((x -> x), [0, 2, 4, 6]))
FROM numbers(5);

-- Subquery in arrayMap
SELECT 1 IN (arrayMap((x -> x), (
        SELECT [1, 2, 3]
    )));

-- Multiple IN with arrayMap in same query
SELECT
    1 IN (arrayMap((x -> x), [1, 2])),
    2 IN (arrayMap((x -> x), [1, 2])),
    3 IN (arrayMap((x -> x), [1, 2]));

-- These should produce identical results
SELECT
    number,
    number IN (arrayMap((x -> x), [0, 2, 4])),
    has(arrayMap((x -> x), [0, 2, 4]), number)
FROM numbers(5);

SELECT
    number,
    number IN (arrayFilter((x -> x % 2 = 0), range(10))),
    has(arrayFilter((x -> x % 2 = 0), range(10)), number)
FROM numbers(5);

SELECT 1 NOT IN (arrayMap((x -> x), [2, 3, 4]));

SELECT 1 NOT IN (arrayMap((x -> x), [1, 2, 3]));

SELECT
    number,
    number NOT IN (arrayMap((x -> x), [0, 2, 4]))
FROM numbers(5);

-- NOT IN with various array functions
SELECT 5 NOT IN (arrayFilter((x -> x < 5), range(10)));

SELECT 3 NOT IN (arrayFilter((x -> x < 5), range(10)));

SELECT 1 NOT IN (arrayConcat([2, 3], [4, 5]));

SELECT 2 NOT IN (arrayConcat([2, 3], [4, 5]));

SELECT 1 NOT IN (arrayReverse([2, 3, 4]));

SELECT 2 NOT IN (arrayReverse([2, 3, 4]));

SELECT 1 NOT IN (range(5));

SELECT 10 NOT IN (range(5));

-- NOT IN with NULL handling (transform_null_in = 0)
SELECT NULL NOT IN (arrayMap((x -> x), [1, 2, 3]))
SETTINGS transform_null_in = '0';

SELECT NULL NOT IN (arrayMap((x -> x), [1, NULL, 3]))
SETTINGS transform_null_in = '0';

SELECT 1 NOT IN (arrayMap((x -> x), [1, NULL, 3]))
SETTINGS transform_null_in = '0';

SELECT toNullable(1) NOT IN (arrayMap((x -> x), [2, 3, 4]))
SETTINGS transform_null_in = '0';

SELECT toNullable(1) NOT IN (arrayMap((x -> x), [1, 2, 3]))
SETTINGS transform_null_in = '0';

-- NOT IN with transform_null_in = 1 is not yet fully supported for array-returning functions
-- SELECT 1 NOT IN arrayMap(x -> x, [1, NULL, 3]) SETTINGS transform_null_in = 1;
-- SELECT toNullable(1) NOT IN arrayMap(x -> x, [2, 3, 4]) SETTINGS transform_null_in = 1;
-- SELECT toNullable(1) NOT IN arrayMap(x -> x, [1, 2, 3]) SETTINGS transform_null_in = 1;
-- NOT IN with column references
SELECT
    number,
    number NOT IN (arrayMap((x -> x + 1), [0, 1, 2]))
FROM numbers(5);

SELECT
    number,
    number NOT IN (arrayFilter((x -> x % 2 = 0), range(10)))
FROM numbers(5);

-- NOT IN with nested array functions
SELECT 5 NOT IN (arrayMap((x -> x * 2), arrayFilter((y -> y > 0), [0, 1, 2, 3])));

SELECT 4 NOT IN (arrayMap((x -> x * 2), arrayFilter((y -> y > 0), [0, 1, 2, 3])));

-- NOT IN consistency with has()
SELECT
    number,
    number NOT IN (arrayMap((x -> x), [0, 2, 4])),
    NOT has(arrayMap((x -> x), [0, 2, 4]), number)
FROM numbers(5);

SELECT 1 GLOBAL IN (arrayMap((x -> x), [1, 2, 3]));

SELECT (1, 2).1 IN (arrayMap((x -> x), [1, 2, 3]));

SELECT (1, 2).2 IN (arrayMap((x -> x), [1, 3, 5]));

SELECT
    number,
    number + 1 IN (arrayMap((x -> x * number), [1, 2, 3]))
FROM numbers(4);

-- These pairs should produce identical results
SELECT
    number,
    number IN ([0, 2, 4]),
    number IN (arrayMap((x -> x), [0, 2, 4]))
FROM numbers(5);

SELECT
    number,
    number IN (0, 2, 4),
    number IN (arrayMap((x -> x), [0, 2, 4]))
FROM numbers(5);

SELECT 2 IN (arrayFlatten([[1], [2, 3], [4]]));

SELECT 5 IN (arrayFlatten([[1], [2, 3], [4]]));

SELECT 2 IN (arraySort([3, 1, 2]));

SELECT 2 IN (arrayReverseSort([3, 1, 2]));

SELECT 3 IN ([arrayUniq([1, 2, 3])]); -- arrayUniq returns UInt64, wrap in array

SELECT (1, 'a') IN (arrayZip([1, 2], ['a', 'b']));

SELECT (1, 'b') IN (arrayZip([1, 2], ['a', 'b']));

SELECT
    number,
    number IN (arrayMap((x -> if(x > 1, x, 0)), [0, 1, 2, 3]))
FROM numbers(4);

-- Type mismatch: tuple IN array of scalars
SELECT (1, 2) IN (arrayMap((x -> x), [1, 2, 3])); -- { serverError NO_COMMON_TYPE }
-- { echoOff }