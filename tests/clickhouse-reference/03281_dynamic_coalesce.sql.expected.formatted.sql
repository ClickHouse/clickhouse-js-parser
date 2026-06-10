SET enable_dynamic_type = '1';

SELECT coalesce(number % 2 ? NULL : number::Dynamic, 42) AS res
FROM numbers(5);

SELECT coalesce(number % 2 ? NULL : number::Dynamic, number % 3 ? NULL : 42) AS res
FROM numbers(5);

SELECT coalesce(number % 2 ? NULL : number, number % 3 ? NULL : CAST('42' AS Dynamic)) AS res
FROM numbers(5);

SELECT coalesce(number % 2 ? NULL : number::Dynamic, number % 3 ? NULL : CAST('42' AS Dynamic)) AS res
FROM numbers(5);

SELECT coalesce(number % 2 ? NULL : number::Dynamic, number % 3 ? NULL : 42, number % 4 = 1 ? NULL : 43) AS res
FROM numbers(10);

SELECT coalesce(number % 2 ? NULL : number, number % 3 ? NULL : CAST('42' AS Dynamic), number % 4 = 1 ? NULL : 43) AS res
FROM numbers(10);

SELECT coalesce(number % 2 ? NULL : number, number % 3 ? NULL : 42, number % 4 = 1 ? NULL : CAST('43' AS Dynamic)) AS res
FROM numbers(10);

SELECT coalesce(number % 2 ? NULL : number::Dynamic, number % 3 ? NULL : CAST('42' AS Dynamic), number % 4 = 1 ? NULL : 43) AS res
FROM numbers(10);

SELECT coalesce(number % 2 ? NULL : number, number % 3 ? NULL : CAST('42' AS Dynamic), number % 4 = 1 ? NULL : CAST('43' AS Dynamic)) AS res
FROM numbers(10);

SELECT coalesce(number % 2 ? NULL : number::Dynamic, number % 3 ? NULL : 42, number % 4 = 1 ? NULL : CAST('43' AS Dynamic)) AS res
FROM numbers(10);

SELECT coalesce(number % 2 ? NULL : number::Dynamic, number % 3 ? NULL : CAST('42' AS Dynamic), number % 4 = 1 ? NULL : CAST('43' AS Dynamic)) AS res
FROM numbers(10);