DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    a Int64,
    b Int64,
    c Int64
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO test (a, b, c);

SELECT
    *,
    'original' AS orig
FROM test
ORDER BY
    a ASC,
    b ASC WITH FILL TO 20 STEP 2 STALENESS 3,
    c ASC WITH FILL TO 25 STEP 3;

DROP TABLE IF EXISTS test2;

CREATE TABLE test2
(
    a Int64,
    b Int64
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO test2 (a, b);

SELECT
    *,
    'original' AS orig
FROM test2
ORDER BY
    a ASC,
    b ASC WITH FILL;

SELECT
    *,
    'original' AS orig
FROM test2
ORDER BY
    a ASC WITH FILL TO 20 STALENESS 4,
    b ASC WITH FILL TO 15 STALENESS 7;

CREATE TABLE test3
(
    a Int64,
    b Int64
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO test3 (a, b);

SELECT
    a,
    b,
    'original' AS orig
FROM test3
ORDER BY
    a ASC WITH FILL TO 33 STEP 3,
    b ASC WITH FILL FROM -10 STEP 2;