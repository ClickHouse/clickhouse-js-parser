DROP TABLE IF EXISTS t1;

CREATE TABLE t1
(
    x Int32
)
ENGINE = Memory();

-- insert several blocks with 1 or 2 rows:
INSERT INTO t1;

INSERT INTO t1;

INSERT INTO t1;

INSERT INTO t1;

SET max_rows_in_join = '111';

SELECT
    x,
    sum(number),
    count()
FROM (
        SELECT
            t1.x,
            t2.number
        FROM
            t1
        CROSS JOIN numbers_mt(10000000) AS t2
        WHERE number <= x
    )
GROUP BY ALL
ORDER BY x ASC;