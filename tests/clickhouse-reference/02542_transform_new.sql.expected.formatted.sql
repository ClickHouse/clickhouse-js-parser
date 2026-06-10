SELECT transform(2, [1, 2], [9, 1], materialize(NULL));

SELECT transform(2, [1, 2], [9, 1], materialize(7));

SELECT transform(2, [1, 2], [9, 1], NULL);

SELECT transform(2, [1, 2], [9, 1], 7);

SELECT transform(1, [1, 2], [9, 1], NULL);

SELECT transform(1, [1, 2], [9, 1], 7);

SELECT transform(5, [1, 2], [9, 1], NULL);

SELECT transform(5, [1, 2], [9, 1], 7);

SELECT transform(2, [1, 2], [9, 1]);

SELECT transform(1, [1, 2], [9, 1]);

SELECT transform(7, [1, 2], [9, 1]);

SELECT transform(2, [1, 2], ['a', 'b'], materialize(NULL));

SELECT transform(2, [1, 2], ['a', 'b'], materialize('c'));

SELECT transform(2, [1, 2], ['a', 'b'], NULL);

SELECT transform(2, [1, 2], ['a', 'b'], 'c');

SELECT transform(1, [1, 2], ['a', 'b'], NULL);

SELECT transform(1, [1, 2], ['a', 'b'], 'c');

SELECT transform(5, [1, 2], ['a', 'b'], NULL);

SELECT transform(5, [1, 2], ['a', 'b'], 'c');

SELECT transform(number, [2], [toDecimal32(1, 1)], materialize(80000)) AS x
FROM numbers(2);

SELECT transform(number, [2], [toDecimal32(1, 1)], 80000) AS x
FROM numbers(2);

SELECT transform(toDecimal32(2, 1), [toDecimal32(2, 1)], [1]);

SELECT transform(8000, [1], [toDecimal32(2, 1)]);

SELECT transform(toDecimal32(8000, 0), [1], [toDecimal32(2, 1)]);

SELECT transform(-9223372036854775807, [-1], [toDecimal32(1024, 3)])
FROM `system`.numbers
LIMIT 7; -- { serverError BAD_ARGUMENTS }

SELECT
    [NULL, NULL, NULL, NULL],
    transform(number, [2147483648], [toDecimal32(1, 2)]) AS x
FROM numbers(257)
WHERE materialize(10); -- { serverError BAD_ARGUMENTS }

SELECT transform(-2147483649, [1], [toDecimal32(1, 2)])
GROUP BY [1]
WITH TOTALS; -- { serverError BAD_ARGUMENTS }

SELECT
    CAST(number AS String) AS v2,
    caseWithExpression('x', 'y', 0, cond2) AS cond1,
    toNullable('0' = v2) AS cond2
FROM numbers(2);

SELECT
    CAST(number AS String) AS v2,
    caseWithExpression('x', 'y', 0, cond2) AS cond1,
    toNullable('1' = v2) AS cond2
FROM numbers(2);