SELECT clamp(1, 10, 20);

SELECT clamp(30, 10, 20);

SELECT clamp(15, 10, 20);

SELECT clamp('a', 'b', 'c');

SELECT clamp(today(), yesterday() - 10, yesterday() + 10) - today();

SELECT clamp([], ['hello'], ['world']);

SELECT clamp(-1., -1000., 18446744073709552000.);

SELECT clamp(toNullable(123), 234, 456);

SELECT clamp(1, NULL, 5);

SELECT clamp(1, 6, NULL);

SELECT clamp(1, 5, nan);

SELECT clamp(toInt64(number), toInt64(number - 1), toInt64(number + 1))
FROM numbers(3);

SELECT clamp(number, number - 1, number + 1)
FROM numbers(3); -- { serverError NO_COMMON_TYPE }

SELECT clamp(1, 3, 2); -- { serverError BAD_ARGUMENTS } 

SELECT clamp(1, data[1], data[2])
FROM (
        SELECT arrayJoin([[1, 2], [2, 3], [3, 2], [4, 4]]) AS data
    ); -- { serverError BAD_ARGUMENTS } 