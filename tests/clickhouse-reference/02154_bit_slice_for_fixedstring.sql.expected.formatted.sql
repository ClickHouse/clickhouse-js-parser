SELECT
    1 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    2 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    3 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    4 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    5 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    6 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    7 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    8 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    9 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    10 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    11 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    12 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    13 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    14 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    15 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    16 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -1 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -2 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -3 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -4 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -5 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -6 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -7 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -8 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -9 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -10 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -11 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -12 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -13 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -14 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -15 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -16 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    49 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    -49 AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    1 AS `offset`,
    NULL AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    NULL AS `offset`,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    NULL AS `offset`,
    NULL AS s,
    substring(bin(s), `offset`),
    bin(bitSlice(s, `offset`));

SELECT
    1 AS `offset`,
    1 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    2 AS `offset`,
    2 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    3 AS `offset`,
    3 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    4 AS `offset`,
    4 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    5 AS `offset`,
    5 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    6 AS `offset`,
    6 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    7 AS `offset`,
    7 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    8 AS `offset`,
    8 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    9 AS `offset`,
    9 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    10 AS `offset`,
    10 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    11 AS `offset`,
    11 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    12 AS `offset`,
    12 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    13 AS `offset`,
    13 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    14 AS `offset`,
    14 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    15 AS `offset`,
    15 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    16 AS `offset`,
    16 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    1 AS `offset`,
    -1 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    2 AS `offset`,
    -2 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    3 AS `offset`,
    -3 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    4 AS `offset`,
    -4 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    5 AS `offset`,
    -5 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    6 AS `offset`,
    -6 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    7 AS `offset`,
    -7 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    8 AS `offset`,
    -8 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    9 AS `offset`,
    -9 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    10 AS `offset`,
    -10 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    11 AS `offset`,
    -11 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    12 AS `offset`,
    -12 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    13 AS `offset`,
    -13 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    14 AS `offset`,
    -14 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    15 AS `offset`,
    -15 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    16 AS `offset`,
    -16 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -1 AS `offset`,
    1 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -2 AS `offset`,
    2 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -3 AS `offset`,
    3 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -4 AS `offset`,
    4 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -5 AS `offset`,
    5 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -6 AS `offset`,
    6 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -7 AS `offset`,
    7 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -8 AS `offset`,
    8 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -9 AS `offset`,
    9 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -10 AS `offset`,
    10 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -11 AS `offset`,
    11 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -12 AS `offset`,
    12 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -13 AS `offset`,
    13 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -14 AS `offset`,
    14 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -15 AS `offset`,
    15 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -16 AS `offset`,
    16 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -1 AS `offset`,
    -16 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -2 AS `offset`,
    -15 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -3 AS `offset`,
    -14 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -4 AS `offset`,
    -13 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -5 AS `offset`,
    -12 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -6 AS `offset`,
    -11 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -7 AS `offset`,
    -10 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -8 AS `offset`,
    -9 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -9 AS `offset`,
    -8 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -10 AS `offset`,
    -7 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -11 AS `offset`,
    -6 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -12 AS `offset`,
    -5 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -13 AS `offset`,
    -4 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -14 AS `offset`,
    -3 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -15 AS `offset`,
    -2 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -16 AS `offset`,
    -1 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    36 AS `offset`,
    16 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    49 AS `offset`,
    1 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -52 AS `offset`,
    -44 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -49 AS `offset`,
    -48 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    -49 AS `offset`,
    49 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    1 AS `offset`,
    1 AS length,
    NULL AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    NULL AS `offset`,
    1 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    1 AS `offset`,
    NULL AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    NULL AS `offset`,
    NULL AS length,
    NULL AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length));

SELECT
    number AS `offset`,
    number AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length))
FROM numbers(16);

SELECT
    number AS `offset`,
    -number AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length))
FROM numbers(16);

SELECT
    -number AS `offset`,
    -16 + number AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length))
FROM numbers(16);

SELECT
    -number AS `offset`,
    number AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length))
FROM numbers(16);

SELECT
    number - 8 AS `offset`,
    8 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length))
FROM numbers(9);

SELECT
    -4 AS `offset`,
    number AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length))
FROM numbers(9);

SELECT
    -44 - number AS `offset`,
    8 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length))
FROM numbers(9);

SELECT
    -52 AS `offset`,
    number AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length))
FROM numbers(9);

SELECT
    -52 AS `offset`,
    number + 48 AS length,
    toFixedString('Hello', 6) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length))
FROM numbers(9);

SELECT
    if(number % 4 = 1
    OR number % 8 = 7, NULL, number) AS `offset`,
    if(number % 4 = 2
    OR number % 8 = 7, NULL, number) AS length,
    if(number % 4 = 3, NULL, toFixedString('Hello', 6)) AS s,
    substring(bin(s), `offset`, length),
    bin(bitSlice(s, `offset`, length))
FROM numbers(16);