SELECT *
FROM (
        SELECT
            number,
            intDiv(number, 5) AS value
        FROM numbers(20)
        ORDER BY value ASC
        LIMIT 3 WITH TIES
    )
ORDER BY
    number ASC,
    value ASC;

DROP TABLE IF EXISTS wt;

CREATE TABLE wt
(
    a Int,
    b Int
)
ENGINE = Memory();

INSERT INTO wt SELECT
    0,
    number
FROM numbers(5);

SELECT 1
FROM wt
ORDER BY a ASC
LIMIT 3 WITH TIES;

SELECT b
FROM (
        SELECT b
        FROM wt
        ORDER BY a ASC
        LIMIT 3 WITH TIES
    )
ORDER BY b ASC;

SELECT *
FROM (
        SELECT *
        FROM (
                WITH a * 2 AS c

                SELECT
                    a,
                    b
                FROM wt
                ORDER BY c ASC
                LIMIT 3 WITH TIES
            )
        ORDER BY
            a ASC,
            b ASC
    );

SELECT *
FROM (
        SELECT *
        FROM (
                SELECT
                    a * 2 AS c,
                    b
                FROM wt
                ORDER BY c ASC
                LIMIT 3 WITH TIES
            )
        ORDER BY
            c ASC,
            b ASC
    );