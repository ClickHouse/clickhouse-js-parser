DROP TABLE IF EXISTS foo;

DROP TABLE IF EXISTS foo1;

DROP TABLE IF EXISTS foo_merge;

DROP TABLE IF EXISTS t2;

CREATE TABLE foo
(
    Id Int32,
    Val Int32
)
ENGINE = MergeTree()
ORDER BY Id
PARTITION BY Val;

CREATE TABLE foo1
(
    Id Int32,
    Val Decimal32(9)
)
ENGINE = MergeTree()
ORDER BY Id
PARTITION BY Val;

INSERT INTO foo SELECT
    number,
    number % 5
FROM numbers(100000);

INSERT INTO foo1 SELECT
    number,
    1
FROM numbers(100000);

CREATE TABLE foo_merge AS foo
ENGINE = Merge(currentDatabase(), '^foo');

CREATE TABLE t2
(
    Id Int32,
    Val Int64,
    X UInt256
)
ENGINE = Memory();

INSERT INTO t2;

SELECT *
FROM foo_merge
WHERE Val = 3
    AND Id = 3;

SELECT
    count(),
    X
FROM
    foo_merge
INNER JOIN t2
    USING (Val)
WHERE Val = 3
    AND Id = 3
    AND t2.X = 4
GROUP BY X;

SELECT
    count(),
    X
FROM
    foo_merge
INNER JOIN t2
    USING (Val)
WHERE Val = 3
    AND (Id = 3
    AND t2.X = 4)
GROUP BY X;

SELECT
    count(),
    X
FROM
    foo_merge
INNER JOIN t2
    USING (Val)
WHERE Val = 3
    AND Id = 3
GROUP BY X;

SELECT
    count(),
    X
FROM
    (
        SELECT *
        FROM foo_merge
    ) AS f
INNER JOIN t2
    USING (Val)
WHERE Val = 3
    AND Id = 3
GROUP BY X;

SELECT
    7,
    count(1000.0001),
    -9223372036854775807
FROM
    foo_merge
INNER JOIN t2
    USING (Val)
WHERE (((NULL
    AND -2
    AND Val = NULL)
    AND Id = NULL
    AND Val = NULL
    AND Id = NULL)
    AND Id = NULL
    AND Val
    AND NULL)
    AND ((3
    AND NULL
    AND -2147483648
    AND Val = NULL)
    AND Id = NULL
    AND Val = NULL)
    AND ((NULL
    AND -2
    AND Val = NULL)
    AND Id = NULL
    AND Val = NULL)
    AND 2147483647
WITH TOTALS;