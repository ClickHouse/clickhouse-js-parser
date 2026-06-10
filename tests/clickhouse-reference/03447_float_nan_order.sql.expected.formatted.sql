SELECT '--- short array ASC NULLS FIRST';

SELECT number + number / number AS a
FROM numbers(3)
ORDER BY a ASC NULLS FIRST;

SELECT number + number / number AS a
FROM numbers(3)
ORDER BY a ASC NULLS LAST;

SELECT number + number / number AS a
FROM numbers(3)
ORDER BY a DESC NULLS FIRST;

SELECT number + number / number AS a
FROM numbers(3)
ORDER BY a DESC NULLS LAST;

SELECT number + number / number AS a
FROM numbers(256)
ORDER BY a ASC NULLS FIRST;

SELECT number + number / number AS a
FROM numbers(256)
ORDER BY a ASC NULLS LAST;

SELECT number + number / number AS a
FROM numbers(256)
ORDER BY a DESC NULLS FIRST;

SELECT number + number / number AS a
FROM numbers(256)
ORDER BY a DESC NULLS LAST;

SELECT number + number / number AS a
FROM numbers(3)
ORDER BY
    a ASC NULLS FIRST,
    1 ASC;

SELECT number + number / number AS a
FROM numbers(3)
ORDER BY
    a ASC NULLS LAST,
    1 ASC;

SELECT number + number / number AS a
FROM numbers(3)
ORDER BY
    a DESC NULLS FIRST,
    1 ASC;

SELECT number + number / number AS a
FROM numbers(3)
ORDER BY
    a DESC NULLS LAST,
    1 ASC;

SELECT number + number / number AS a
FROM numbers(256)
ORDER BY
    a ASC NULLS FIRST,
    1 ASC;

SELECT number + number / number AS a
FROM numbers(256)
ORDER BY
    a ASC NULLS LAST,
    1 ASC;

SELECT number + number / number AS a
FROM numbers(256)
ORDER BY
    a DESC NULLS FIRST,
    1 ASC;

SELECT number + number / number AS a
FROM numbers(256)
ORDER BY
    a DESC NULLS LAST,
    1 ASC;