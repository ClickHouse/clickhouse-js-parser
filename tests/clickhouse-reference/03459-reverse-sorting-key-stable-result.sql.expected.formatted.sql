-- { echo ON }
DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    A Int64
)
ORDER BY A DESC
PARTITION BY A % 64
SETTINGS allow_experimental_reverse_key = '1' AS
SELECT intDiv(number, 11111)
FROM numbers(700000.)
UNION ALL
SELECT number
FROM numbers(700000.);

SET max_threads = '1';

SELECT cityHash64(groupArray(A))
FROM (
        SELECT A
        FROM t
        ORDER BY A DESC
        LIMIT 10
    );

SELECT cityHash64(groupArray(A))
FROM (
        SELECT A
        FROM t
        ORDER BY identity(A) DESC
        LIMIT 10
    );

DROP TABLE t;