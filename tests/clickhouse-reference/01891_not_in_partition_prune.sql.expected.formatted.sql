DROP TABLE IF EXISTS test1;

CREATE TABLE test1
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY i
SETTINGS index_granularity = '1';

INSERT INTO test1 SELECT
    number,
    number + 100
FROM numbers(10);

SELECT count()
FROM test1
WHERE NOT has([1, 2, 3], i);

SELECT count()
FROM test1
WHERE i NOT IN (1, 2, 3);

SET max_rows_to_read = '5';

SELECT *
FROM test1
WHERE NOT has([1, 2, 3, 4, 5], i)
ORDER BY i ASC;

SELECT *
FROM test1
WHERE i NOT IN (1, 2, 3, 4, 5)
ORDER BY i ASC;

DROP TABLE test1;

DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1
(
    date Date,
    a Float64,
    b String
)
ENGINE = MergeTree()
ORDER BY date;

CREATE TABLE t2
(
    date Date,
    a Float64,
    b String
)
ENGINE = MergeTree()
ORDER BY date;

INSERT INTO t1 (a, b);

INSERT INTO t2 (a, b);

SELECT
    date,
    a,
    b
FROM t1
WHERE NOT has((
        SELECT groupUniqArray(tuple(date, a, b))
        FROM t2
    ), tuple(date, a, b));

SELECT
    date,
    a,
    b
FROM t2
WHERE NOT has((
        SELECT groupUniqArray(tuple(date, a, b))
        FROM t1
    ), tuple(date, a, b));

SELECT
    date,
    a,
    b
FROM t1
WHERE (date, a, b) NOT IN (
        SELECT
            date,
            a,
            b
        FROM t2
    );

SELECT
    date,
    a,
    b
FROM t2
WHERE (date, a, b) NOT IN (
        SELECT
            date,
            a,
            b
        FROM t1
    );

DROP TABLE t1;

DROP TABLE t2;