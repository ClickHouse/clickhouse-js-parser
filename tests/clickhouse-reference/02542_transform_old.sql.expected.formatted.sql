SELECT transform(number, [2, 4, 6], ['google', 'yandex', 'yahoo'], 'other') AS x
FROM numbers(10)
GROUP BY x
ORDER BY x ASC;

SELECT transform(number, [2, 4, 6], [29, 20, 21], 22) AS x
FROM numbers(10)
GROUP BY x
ORDER BY x ASC;

SELECT transform(number, [2, 4, 6], [29, 20, 21]) AS x
FROM numbers(10)
GROUP BY x
ORDER BY x ASC;

SELECT transform(toString(number), ['2', '4', '6'], [29, 20, 21], 22) AS x
FROM numbers(10)
GROUP BY x
ORDER BY x ASC;

SELECT transform(toString(number), ['2', '4', '6'], ['google', 'yandex', 'yahoo'], 'other') AS x
FROM numbers(10)
GROUP BY x
ORDER BY x ASC;

SELECT transform(toString(number), ['2', '4', '6'], ['google', 'yandex', 'yahoo']) AS x
FROM numbers(10)
GROUP BY x
ORDER BY x ASC;

SELECT '----';

SELECT transform(number, [2, 4, 6], ['google', 'yandex', 'yahoo'], materialize('other')) AS x
FROM numbers(10)
GROUP BY x
ORDER BY x ASC;

SELECT transform(number, [2, 4, 6], [29, 20, 21], materialize(22)) AS x
FROM numbers(10)
GROUP BY x
ORDER BY x ASC;

SELECT transform(toString(number), ['2', '4', '6'], [29, 20, 21], materialize(22)) AS x
FROM numbers(10)
GROUP BY x
ORDER BY x ASC;

SELECT transform(toString(number), ['2', '4', '6'], ['google', 'yandex', 'yahoo'], materialize('other')) AS x
FROM numbers(10)
GROUP BY x
ORDER BY x ASC;

SELECT transform(number, [2, 4, 6], [2900, 2000, 2100], 2200) AS x
FROM numbers(10)
GROUP BY x
ORDER BY x ASC;

SELECT transform(number, [2, 4, 6], [2900, 2000, 2100], materialize(2200)) AS x
FROM numbers(10)
GROUP BY x
ORDER BY x ASC;

SELECT transform(number, [1], [NULL])
FROM `system`.numbers
LIMIT 1; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }