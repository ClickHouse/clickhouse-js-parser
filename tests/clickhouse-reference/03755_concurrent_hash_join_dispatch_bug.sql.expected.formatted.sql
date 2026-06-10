DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Int
)
ENGINE = Memory();

SELECT 1
FROM
    remote('localhost', currentDatabase(), t0) AS t0
INNER JOIN t0 AS t1
    ON false
RIGHT JOIN t0 AS t2
    ON false;

SET join_use_nulls = '1';

DROP TABLE t0;