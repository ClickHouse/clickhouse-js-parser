SELECT
    toDate(toDateTime(number * 10 * 86400, 'Asia/Istanbul')) AS d1,
    toDate(toDateTime(number * 86400, 'Asia/Istanbul')) AS d2,
    'original' AS source
FROM numbers(10)
WHERE number % 3 = 1
ORDER BY
    d2 ASC WITH FILL,
    d1 ASC WITH FILL STEP 5;

SELECT
    toDate(toDateTime(number * 10 * 86400, 'Asia/Istanbul')) AS d1,
    toDate(toDateTime(number * 86400, 'Asia/Istanbul')) AS d2,
    'original' AS source
FROM numbers(10)
WHERE number % 3 = 1
ORDER BY
    d1 ASC WITH FILL STEP 5,
    d2 ASC WITH FILL;