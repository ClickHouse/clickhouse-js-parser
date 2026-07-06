SELECT
    number,
    leadInFrame(number) OVER w AS W
FROM numbers(10)
WINDOW w AS (ORDER BY number ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
LIMIT 3;

WITH arrayJoin(['a', 'a', 'b', 'b']) AS field

SELECT
    field,
    count() OVER (PARTITION BY field)
ORDER BY field ASC
LIMIT 1;

SELECT *
FROM (
        SELECT
            *,
            count() OVER () AS cnt
        FROM (
                SELECT *
                FROM numbers(10000000)
            )
    )
LIMIT 3;

SELECT *
FROM (
        SELECT
            *,
            count() OVER () AS cnt
        FROM (
                SELECT *
                FROM numbers(10000000)
            )
    )
ORDER BY number ASC
LIMIT 3;