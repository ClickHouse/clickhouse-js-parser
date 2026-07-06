SET group_by_two_level_threshold = '100000';

SET enable_positional_arguments = '1';

SET enable_analyzer = '1';

DROP TABLE IF EXISTS test;

DROP TABLE IF EXISTS test2;

CREATE TABLE test
(
    x1 Int,
    x2 Int,
    x3 Int
)
ENGINE = Memory();

INSERT INTO test;

-- { echo }
SELECT
    x3,
    x2,
    x1
FROM test
ORDER BY 1 ASC;

SELECT
    x3,
    x2,
    x1
FROM test
ORDER BY -3 ASC;

SELECT
    x3,
    x2,
    x1
FROM test
ORDER BY x3 ASC;

SELECT
    x3,
    x2,
    x1
FROM test
ORDER BY 3 ASC;

SELECT
    x3,
    x2,
    x1
FROM test
ORDER BY -1 ASC;

SELECT
    x3,
    x2,
    x1
FROM test
ORDER BY x1 ASC;

SELECT
    x3,
    x2,
    x1
FROM test
ORDER BY 1 DESC;

SELECT
    x3,
    x2,
    x1
FROM test
ORDER BY -3 DESC;

SELECT
    x3,
    x2,
    x1
FROM test
ORDER BY x3 DESC;

SELECT
    x3,
    x2,
    x1
FROM test
ORDER BY 3 DESC;

SELECT
    x3,
    x2,
    x1
FROM test
ORDER BY -1 DESC;

SELECT
    x3,
    x2,
    x1
FROM test
ORDER BY x1 DESC;

SELECT
    x3,
    x2
FROM test
GROUP BY
    x3,
    x2
ORDER BY x3 ASC;

SELECT
    x3,
    x2
FROM test
GROUP BY
    1,
    2
ORDER BY x3 ASC;

SELECT
    x1,
    x2,
    x3
FROM test
ORDER BY x3 ASC
LIMIT 1 BY x3;

SELECT
    x1,
    x2,
    x3
FROM test
ORDER BY 3 ASC
LIMIT 1 BY 3;

SELECT
    x1,
    x2,
    x3
FROM test
ORDER BY x3 ASC
LIMIT 1 BY x1;

SELECT
    x1,
    x2,
    x3
FROM test
ORDER BY 3 ASC
LIMIT 1 BY 1;

EXPLAIN SYNTAX
SELECT
    x3,
    x2,
    x1
FROM test
ORDER BY 1 ASC;

EXPLAIN SYNTAX
SELECT
    x3 + 1,
    x2,
    x1
FROM test
ORDER BY 1 ASC;

EXPLAIN SYNTAX
SELECT
    x3,
    x2,
    x1
FROM test
ORDER BY -1 ASC;

EXPLAIN SYNTAX
SELECT
    x3 + 1,
    x2,
    x1
FROM test
ORDER BY -1 ASC;

EXPLAIN SYNTAX
SELECT
    x3,
    x3 - x2,
    x2,
    x1
FROM test
ORDER BY 2 ASC;

EXPLAIN SYNTAX
SELECT
    x3,
    x3 - x2,
    x2,
    x1
FROM test
ORDER BY -2 ASC;

EXPLAIN SYNTAX
SELECT
    x3,
    if(x3 > 10, x3, plus(x1, x2)),
    x1 + x2
FROM test
ORDER BY 2 ASC;

EXPLAIN SYNTAX
SELECT
    x3,
    if(x3 > 10, x3, plus(x1, x2)),
    x1 + x2
FROM test
ORDER BY -2 ASC;

EXPLAIN SYNTAX
SELECT
    max(x1),
    x2
FROM test
GROUP BY 2
ORDER BY
    1 ASC,
    2 ASC;

EXPLAIN SYNTAX
SELECT
    max(x1),
    x2
FROM test
GROUP BY -1
ORDER BY
    -2 ASC,
    -1 ASC;

EXPLAIN SYNTAX
SELECT
    1 + greatest(x1, 1),
    x2
FROM test
GROUP BY
    1,
    2;

EXPLAIN SYNTAX
SELECT
    1 + greatest(x1, 1),
    x2
FROM test
GROUP BY
    -2,
    -1;

SELECT
    max(x1),
    x2
FROM test
GROUP BY
    1,
    2; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT, 184 }

SELECT
    1 + max(x1),
    x2
FROM test
GROUP BY
    1,
    2; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT, 184 }

SELECT
    max(x1),
    x2
FROM test
GROUP BY
    -2,
    -1; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT, 184 }

SELECT
    1 + max(x1),
    x2
FROM test
GROUP BY
    -2,
    -1; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT, 184 }

EXPLAIN SYNTAX
SELECT
    x1 + x3,
    x3
FROM test
GROUP BY
    1,
    2;

EXPLAIN SYNTAX
SELECT
    x1 + x3,
    x3
FROM test
GROUP BY
    -2,
    -1;

CREATE TABLE test2
(
    x1 Int,
    x2 Int,
    x3 Int
)
ENGINE = Memory();

INSERT INTO test2;

SELECT
    x1,
    x1 * 2,
    max(x2),
    max(x3)
FROM test2
GROUP BY
    2,
    1,
    x1
ORDER BY
    1 ASC,
    2 ASC,
    4 DESC,
    3 ASC;

SELECT
    x1,
    x1 * 2,
    max(x2),
    max(x3)
FROM test2
GROUP BY
    2,
    1,
    x1
ORDER BY
    1 ASC,
    2 ASC,
    -1 DESC,
    -2 ASC;

SELECT
    a,
    b,
    c,
    d,
    e,
    f
FROM (
        SELECT
            44 AS a,
            88 AS b,
            13 AS c,
            14 AS d,
            15 AS e,
            16 AS f
    ) AS t
GROUP BY
    1,
    2,
    3,
    4,
    5,
    6
ORDER BY a ASC;

SELECT
    a,
    b,
    c,
    d,
    e,
    f
FROM (
        SELECT
            44 AS a,
            88 AS b,
            13 AS c,
            14 AS d,
            15 AS e,
            16 AS f
    ) AS t
GROUP BY
    1,
    2,
    3,
    -3,
    -2,
    -1
ORDER BY a ASC;

EXPLAIN SYNTAX
SELECT plus(1, 1) AS a
GROUP BY a;

SELECT substr('aaaaaaaaaaaaaa', 8) AS a
GROUP BY a
ORDER BY a ASC;

SELECT substr('aaaaaaaaaaaaaa', 8) AS a
GROUP BY substr('aaaaaaaaaaaaaa', 8)
ORDER BY a ASC;

SELECT b
FROM (
        SELECT
            5 AS a,
            'Hello' AS b
        ORDER BY a ASC
    );

SELECT b
FROM (
        SELECT
            5 AS a,
            'Hello' AS b
        GROUP BY a
    );

SELECT b
FROM (
        SELECT
            5 AS a,
            'Hello' AS b
        ORDER BY 1 ASC
    );

DROP TABLE IF EXISTS tp2;

CREATE TABLE tp2
(
    first_col String,
    second_col Int32
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tp2 SELECT
    'bbb',
    1;

INSERT INTO tp2 SELECT
    'aaa',
    2;

SELECT count(*)
FROM (
        SELECT
            first_col,
            count(second_col)
        FROM tp2
        GROUP BY 1
    );

SELECT total
FROM (
        SELECT
            first_col,
            count(second_col) AS total
        FROM tp2
        GROUP BY 1
    );

SELECT first_col
FROM (
        SELECT
            first_col,
            second_col AS total
        FROM tp2
        ORDER BY 1 DESC
    );

SELECT first_col
FROM (
        SELECT
            first_col,
            second_col AS total
        FROM tp2
        ORDER BY 2 DESC
    );

SELECT max
FROM (
        SELECT
            max(first_col) AS max,
            second_col AS total
        FROM tp2
        GROUP BY 2
    )
ORDER BY 1 ASC;

WITH res AS (
    SELECT first_col
    FROM (
            SELECT
                first_col,
                second_col AS total
            FROM tp2
            ORDER BY 2 DESC
        )
    LIMIT 1
)

SELECT *
FROM res;

CREATE TABLE test
(
    id UInt32,
    time UInt32,
    INDEX id id TYPE set(0) GRANULARITY 3,
    INDEX time time TYPE minmax() GRANULARITY 3
)
ENGINE = MergeTree()
ORDER BY time;

SELECT
    count(*) AS value,
    0 AS data
FROM test
GROUP BY data;

DROP TABLE test;