DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Int32,
    c1 Int32,
    c2 String
)
ENGINE = Log();

INSERT INTO t0 (c0, c1, c2);

SELECT *
FROM t0
FORMAT PrettyMonoBlock;

SELECT `left`.c2
FROM
    t0 AS `left`
ANTI LEFT JOIN t0 AS right_0
    ON `left`.c0 = right_0.c1
WHERE abs(-sign(right_0.c1));

SELECT SUM(check != 0)
FROM (
        SELECT abs(-sign(right_0.c1)) AS check
        FROM
            t0 AS `left`
        ANTI LEFT JOIN t0 AS right_0
            ON `left`.c0 = right_0.c1
    );

SELECT abs(-sign(right_0.c1)) AS check
FROM
    t0 AS `left`
ANTI LEFT JOIN t0 AS right_0
    ON `left`.c0 = right_0.c1;

SELECT abs(-sign(right_0.c1)) AS check
FROM
    t0 AS `left`
ANTI LEFT JOIN t0 AS right_0
    ON `left`.c0 = right_0.c1
WHERE check != 0;

DROP TABLE t0;