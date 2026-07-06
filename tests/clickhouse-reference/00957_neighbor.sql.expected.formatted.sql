SET allow_deprecated_error_prone_window_functions = '1';

-- no arguments
SELECT neighbor(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

-- single argument
SELECT neighbor(1); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

-- greater than 3 arguments
SELECT neighbor(1, 2, 3, 4); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

-- bad default value
SELECT neighbor(dummy, 1, 'hello'); -- { serverError NO_COMMON_TYPE }

-- types without common supertype (UInt64 and Int8)
SELECT
    number,
    neighbor(number, 1, -10)
FROM numbers(3); -- { serverError NO_COMMON_TYPE }

-- nullable offset is not allowed
SELECT
    number,
    if(number > 1, number, NULL) AS `offset`,
    neighbor(number, `offset`)
FROM numbers(3); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    number,
    neighbor(number, 0)
FROM numbers(3);

SELECT
    if(number > 1, number, NULL) AS value,
    number AS `offset`,
    neighbor(value, `offset`) AS neighbor
FROM numbers(3);

SELECT
    toInt32(number) AS n,
    neighbor(n, 1, -10)
FROM numbers(3);

SELECT
    number,
    neighbor(number, 10)
FROM numbers(3);

SELECT
    number,
    neighbor(number, -10)
FROM numbers(3);

SELECT
    number,
    neighbor(number, 1)
FROM numbers(3);

SELECT
    number,
    neighbor(number, 2, number + 10)
FROM numbers(4);

SELECT
    number,
    neighbor(number, -2, number + 10)
FROM numbers(4);

SELECT
    number,
    neighbor(number, 1, 1000)
FROM numbers(3);

SELECT
    number,
    neighbor(number, -1, 1000)
FROM numbers(3);

SELECT
    number,
    number * 2 AS `offset`,
    neighbor(number, `offset`, number * 10)
FROM numbers(4);

SELECT
    number,
    -number * 2 AS `offset`,
    neighbor(number, `offset`, number * 10)
FROM numbers(6);

SELECT
    number,
    -(number - 2) * 2 AS `offset`,
    neighbor(number, `offset`)
FROM numbers(6);

SELECT
    number,
    neighbor(1000, 10)
FROM numbers(3);