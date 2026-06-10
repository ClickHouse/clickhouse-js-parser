SET optimize_sorting_by_input_stream_properties = '1';

DROP TABLE IF EXISTS optimize_sorting;

CREATE TABLE optimize_sorting
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO optimize_sorting;

INSERT INTO optimize_sorting;

-- { echoOn }
-- order by for MergeTree w/o sorting key
SELECT
    a,
    b
FROM optimize_sorting
ORDER BY
    a ASC,
    b ASC;

CREATE TABLE optimize_sorting
(
    a UInt64,
    b UInt64,
    c UInt64
)
ENGINE = MergeTree()
ORDER BY (a, b);

INSERT INTO optimize_sorting SELECT
    number,
    number % 5,
    number % 2
FROM numbers(0, 5);

INSERT INTO optimize_sorting SELECT
    number,
    number % 5,
    number % 2
FROM numbers(5, 5);

-- { echoOn }
SELECT a
FROM optimize_sorting
ORDER BY a ASC;

SELECT c
FROM optimize_sorting
ORDER BY c ASC;

-- queries with unary function in order by
SELECT a
FROM optimize_sorting
ORDER BY -a ASC;

SELECT a
FROM optimize_sorting
ORDER BY toFloat64(a) ASC;

-- queries with non-unary function in order by
SELECT
    a,
    a + 1
FROM optimize_sorting
ORDER BY a + 1 ASC;

SELECT
    a,
    a - 1
FROM optimize_sorting
ORDER BY a - 1 ASC;

SELECT
    a,
    sipHash64(a, 'a')
FROM optimize_sorting
ORDER BY sipHash64(a, 'a') ASC;

-- queries with aliases
SELECT a AS a
FROM optimize_sorting
ORDER BY a ASC;

SELECT a + 1 AS a
FROM optimize_sorting
ORDER BY a ASC;

SELECT toFloat64(a) AS a
FROM optimize_sorting
ORDER BY a ASC;

SELECT sipHash64(a) AS a
FROM optimize_sorting
ORDER BY a ASC;

-- queries with filter
SELECT a
FROM optimize_sorting
WHERE a > 0
ORDER BY a ASC;

SELECT a > 0
FROM optimize_sorting
WHERE a > 0;

SELECT a
FROM (
        SELECT a
        FROM optimize_sorting
    )
WHERE a != 0
ORDER BY a ASC;

SELECT a
FROM (
        SELECT sipHash64(a) AS a
        FROM optimize_sorting
    )
WHERE a != 0
ORDER BY a ASC;

-- queries with non-trivial action's chain in expression
SELECT
    a,
    z
FROM (
        SELECT
            sipHash64(a) AS a,
            a + 1 AS z
        FROM (
                SELECT a
                FROM optimize_sorting
                ORDER BY a + 1 ASC
            )
    )
ORDER BY a + 1 ASC;