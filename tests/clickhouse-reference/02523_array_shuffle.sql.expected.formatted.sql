SELECT arrayShuffle([]);

SELECT arrayShuffle([], 195939070);

SELECT arrayShuffle([9223372036854775808]);

SELECT arrayShuffle([9223372036854775808], 195939070);

SELECT arrayShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 195939070);

SELECT arrayShuffle(materialize([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]), 195939070);

SELECT arrayShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10.1], 195939070);

SELECT arrayShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 9223372036854775808], 195939070);

SELECT arrayShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, NULL], 195939070);

SELECT arrayShuffle([toFixedString('123', 3), toFixedString('456', 3), toFixedString('789', 3), toFixedString('ABC', 3), toFixedString('000', 3)], 195939070);

SELECT arrayShuffle([toFixedString('123', 3), toFixedString('456', 3), toFixedString('789', 3), toFixedString('ABC', 3), NULL], 195939070);

SELECT arrayShuffle(['storage', 'tiger', 'imposter', 'terminal', 'uniform', 'sensation'], 195939070);

SELECT arrayShuffle(['storage', 'tiger', NULL, 'terminal', 'uniform', 'sensation'], 195939070);

SELECT arrayShuffle([NULL]);

SELECT arrayShuffle([NULL, NULL]);

SELECT arrayShuffle([[1, 2, 3, 4], [-1, -2, -3, -4], [10, 20, 30, 40], [100, 200, 300, 400, 500, 600, 700, 800, 900], [2, 4, 8, 16, 32, 64]], 195939070);

SELECT arrayShuffle(materialize([[1, 2, 3, 4], [-1, -2, -3, -4], [10, 20, 30, 40], [100, 200, 300, 400, 500, 600, 700, 800, 900], [2, 4, 8, 16, 32, 64]]), 195939070);

SELECT arrayShuffle([[1, 2, 3, 4], [NULL, -2, -3, -4], [10, 20, 30, 40], [100, 200, 300, 400, 500, 600, 700, 800, 900], [2, 4, 8, 16, 32, 64]], 195939070);

SELECT arrayShuffle(groupArray(x), 195939070)
FROM (
        SELECT number AS x
        FROM `system`.numbers
        LIMIT 100
    );

SELECT arrayShuffle(groupArray(toUInt64(x)), 195939070)
FROM (
        SELECT number AS x
        FROM `system`.numbers
        LIMIT 100
    );

SELECT arrayShuffle([tuple(1, -1), tuple(99999999, -99999999), tuple(3, -3)], 195939070);

SELECT arrayShuffle([tuple(1, NULL), tuple(2, 'a'), tuple(3, 'A')], 195939070);

SELECT arrayPartialShuffle([]); -- trivial cases (equivalent to arrayShuffle)

SELECT arrayPartialShuffle([], 0);

SELECT arrayPartialShuffle([], 0, 195939070);

SELECT arrayPartialShuffle([9223372036854775808]);

SELECT arrayPartialShuffle([9223372036854775808], 0);

SELECT arrayPartialShuffle([9223372036854775808], 0, 195939070);

SELECT arrayPartialShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 0, 195939070);

SELECT arrayPartialShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10.1], 0, 195939070);

SELECT arrayPartialShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 9223372036854775808], 0, 195939070);

SELECT arrayPartialShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, NULL], 0, 195939070);

SELECT arrayPartialShuffle([toFixedString('123', 3), toFixedString('456', 3), toFixedString('789', 3), toFixedString('ABC', 3), toFixedString('000', 3)], 0, 195939070);

SELECT arrayPartialShuffle([toFixedString('123', 3), toFixedString('456', 3), toFixedString('789', 3), toFixedString('ABC', 3), NULL], 0, 195939070);

SELECT arrayPartialShuffle(['storage', 'tiger', 'imposter', 'terminal', 'uniform', 'sensation'], 0, 195939070);

SELECT arrayPartialShuffle(['storage', 'tiger', NULL, 'terminal', 'uniform', 'sensation'], 0, 195939070);

SELECT arrayPartialShuffle([NULL]);

SELECT arrayPartialShuffle([NULL, NULL]);

SELECT arrayPartialShuffle([[1, 2, 3, 4], [-1, -2, -3, -4], [10, 20, 30, 40], [100, 200, 300, 400, 500, 600, 700, 800, 900], [2, 4, 8, 16, 32, 64]], 0, 195939070);

SELECT arrayPartialShuffle([[1, 2, 3, 4], [NULL, -2, -3, -4], [10, 20, 30, 40], [100, 200, 300, 400, 500, 600, 700, 800, 900], [2, 4, 8, 16, 32, 64]], 0, 195939070);

SELECT arrayPartialShuffle(groupArray(x), 0, 195939070)
FROM (
        SELECT number AS x
        FROM `system`.numbers
        LIMIT 100
    );

SELECT arrayPartialShuffle(groupArray(toUInt64(x)), 0, 195939070)
FROM (
        SELECT number AS x
        FROM `system`.numbers
        LIMIT 100
    );

SELECT arrayPartialShuffle([tuple(1, -1), tuple(99999999, -99999999), tuple(3, -3)], 0, 195939070);

SELECT arrayPartialShuffle([tuple(1, NULL), tuple(2, 'a'), tuple(3, 'A')], 0, 195939070);

SELECT arrayPartialShuffle([NULL, NULL, NULL], 2); -- other, mostly non-trivial cases

SELECT arrayPartialShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 1, 195939070);

SELECT arrayPartialShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 2, 195939070);

SELECT arrayPartialShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 4, 195939070);

SELECT arrayPartialShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 8, 195939070);

SELECT arrayPartialShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 9, 195939070);

SELECT arrayPartialShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 10, 195939070);

SELECT arrayPartialShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 100, 195939070);

SELECT arrayPartialShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10.1], 4, 195939070);

SELECT arrayPartialShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 9223372036854775808], 4, 195939070);

SELECT arrayPartialShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, NULL], 4, 195939070);

SELECT arrayPartialShuffle([toFixedString('123', 3), toFixedString('456', 3), toFixedString('789', 3), toFixedString('ABC', 3), toFixedString('000', 3)], 3, 195939070);

SELECT arrayPartialShuffle([toFixedString('123', 3), toFixedString('456', 3), toFixedString('789', 3), toFixedString('ABC', 3), NULL], 3, 195939070);

SELECT arrayPartialShuffle(['storage', 'tiger', 'imposter', 'terminal', 'uniform', 'sensation'], 3, 195939070);

SELECT arrayPartialShuffle(['storage', 'tiger', NULL, 'terminal', 'uniform', 'sensation'], 3, 195939070);

SELECT arrayPartialShuffle([[1, 2, 3, 4], [-1, -2, -3, -4], [10, 20, 30, 40], [100, 200, 300, 400, 500, 600, 700, 800, 900], [2, 4, 8, 16, 32, 64]], 2, 195939070);

SELECT arrayPartialShuffle([[1, 2, 3, 4], [NULL, -2, -3, -4], [10, 20, 30, 40], [100, 200, 300, 400, 500, 600, 700, 800, 900], [2, 4, 8, 16, 32, 64]], 2, 195939070);

SELECT arrayPartialShuffle(groupArray(x), 20, 195939070)
FROM (
        SELECT number AS x
        FROM `system`.numbers
        LIMIT 100
    );

SELECT arrayPartialShuffle(groupArray(toUInt64(x)), 20, 195939070)
FROM (
        SELECT number AS x
        FROM `system`.numbers
        LIMIT 100
    );

SELECT arrayPartialShuffle([tuple(1, -1), tuple(99999999, -99999999), tuple(3, -3)], 2, 195939070);

SELECT arrayPartialShuffle([tuple(1, NULL), tuple(2, 'a'), tuple(3, 'A')], 2, 195939070);

SELECT arrayShuffle([1, 2, 3], 42)
FROM numbers(10);

SELECT arrayShuffle(materialize([1, 2, 3]), 42)
FROM numbers(10);

SELECT arrayShuffle(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT arrayShuffle([1], 'a'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT arrayShuffle([1], 1.1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT arrayShuffle([1], 51966, 1); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }