DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    n Int32,
    s String
)
ENGINE = MergeTree()
ORDER BY n;

INSERT INTO t SELECT
    number,
    'hello, world!'
FROM numbers(5);

SELECT array_agg(s)
FROM t;

SELECT aRray_Agg(s)
FROM t
GROUP BY n;

DROP TABLE t;