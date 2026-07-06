SELECT number
FROM numbers(10)
LIMIT 0 + 1;

SELECT number
FROM numbers(10)
LIMIT 1 - 1;

SELECT number
FROM numbers(10)
LIMIT 2 - 1;

SELECT number
FROM numbers(10)
LIMIT 0 - 1;

SELECT number
FROM numbers(10)
LIMIT 1.;

SELECT number
FROM numbers(10)
LIMIT 1.5; -- { serverError INVALID_LIMIT_EXPRESSION }

SELECT number
FROM numbers(10)
LIMIT '1'; -- { serverError INVALID_LIMIT_EXPRESSION }

SELECT number
FROM numbers(10)
LIMIT now(); -- { serverError INVALID_LIMIT_EXPRESSION }

SELECT number
FROM numbers(10)
LIMIT today(); -- { serverError INVALID_LIMIT_EXPRESSION }

SELECT number
FROM numbers(10)
LIMIT toUInt8('1');

SELECT number
FROM numbers(10)
LIMIT toFloat32('1');

SELECT number
FROM numbers(10)
LIMIT rand(); -- { serverError BAD_ARGUMENTS, INVALID_LIMIT_EXPRESSION }

SELECT count() <= 1
FROM (
        SELECT number
        FROM numbers(10)
        LIMIT randConstant() % 2
    );

SELECT number
FROM numbers(10)
LIMIT 0 + 1 BY number;

SELECT number
FROM numbers(10)
LIMIT 0 BY number;

SELECT *
FROM numbers(10)
LIMIT 5;

SELECT *
FROM numbers(10)
LIMIT 0.33 / 0.165 - 0.33 + 0.67; -- { serverError INVALID_LIMIT_EXPRESSION }

SELECT *
FROM numbers(10)
LIMIT toDate('0000-00-02')
OFFSET LENGTH('NNN') + COS(0); -- { serverError INVALID_LIMIT_EXPRESSION }

SELECT *
FROM numbers(10)
LIMIT a + 5 - a; -- { serverError UNKNOWN_IDENTIFIER }

SELECT *
FROM numbers(10)
LIMIT a + b; -- { serverError UNKNOWN_IDENTIFIER }

SELECT *
FROM numbers(10)
LIMIT 'Hello'; -- { serverError INVALID_LIMIT_EXPRESSION }

SELECT number
FROM numbers(10)
ORDER BY number ASC
LIMIT (
    SELECT
        sum(number),
        count()
    FROM numbers(3)
).1;