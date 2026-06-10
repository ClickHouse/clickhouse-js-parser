SELECT argMaxIf(number, number + 1, number != 99)
FROM numbers(100);

SELECT sumIf(number, number % 2 = 0)
FROM numbers(100);

SELECT sumIfOrNullIf(number, number % 2 = 1, 0)
FROM numbers(100);

SELECT sumIfOrNullIf(number, number % 2 = 1, 1)
FROM numbers(100);