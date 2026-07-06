SET single_join_prefer_left_table = '0';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    key UInt64,
    a UInt8,
    b String,
    c Float64
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO test SELECT
    number,
    number,
    toString(number),
    number
FROM numbers(4);

SET optimize_redundant_functions_in_order_by = '1';

SELECT groupArray(x)
FROM (
        SELECT number AS x
        FROM numbers(3)
        ORDER BY
            x ASC,
            exp(x) ASC
    );

SELECT groupArray(x)
FROM (
        SELECT number AS x
        FROM numbers(3)
        ORDER BY
            x ASC,
            exp(x) ASC
    )
SETTINGS enable_analyzer = '1';

SELECT groupArray(x)
FROM (
        SELECT number AS x
        FROM numbers(3)
        ORDER BY
            x ASC,
            exp(exp(x)) ASC
    );

SELECT groupArray(x)
FROM (
        SELECT number AS x
        FROM numbers(3)
        ORDER BY
            x ASC,
            exp(exp(x)) ASC
    )
SETTINGS enable_analyzer = '1';

SELECT groupArray(x)
FROM (
        SELECT number AS x
        FROM numbers(3)
        ORDER BY
            exp(x) ASC,
            x ASC
    );

SELECT groupArray(x)
FROM (
        SELECT number AS x
        FROM numbers(3)
        ORDER BY
            exp(x) ASC,
            x ASC
    )
SETTINGS enable_analyzer = '1';

SELECT *
FROM
    (
        SELECT number + 2 AS key
        FROM numbers(4)
    ) AS s
FULL JOIN test AS t
    USING (key)
ORDER BY
    s.key ASC,
    t.key ASC;

SELECT *
FROM
    (
        SELECT number + 2 AS key
        FROM numbers(4)
    ) AS s
FULL JOIN test AS t
    USING (key)
ORDER BY
    s.key ASC,
    t.key ASC
SETTINGS enable_analyzer = '1';

SELECT
    key,
    a
FROM test
ORDER BY
    key ASC,
    a ASC,
    exp(key + a) ASC;

SELECT
    key,
    a
FROM test
ORDER BY
    key ASC,
    a ASC,
    exp(key + a) ASC
SETTINGS enable_analyzer = '1';

SELECT
    key,
    a
FROM test
ORDER BY
    key ASC,
    exp(key + a) ASC;

SELECT
    key,
    a
FROM test
ORDER BY
    key ASC,
    exp(key + a) ASC
SETTINGS enable_analyzer = '1';

EXPLAIN SYNTAX
SELECT groupArray(x)
FROM (
        SELECT number AS x
        FROM numbers(3)
        ORDER BY
            x ASC,
            exp(x) ASC
    );

EXPLAIN QUERY TREE run_passes = '1'
SELECT groupArray(x)
FROM (
        SELECT number AS x
        FROM numbers(3)
        ORDER BY
            x ASC,
            exp(x) ASC
    )
SETTINGS enable_analyzer = '1';

EXPLAIN SYNTAX
SELECT groupArray(x)
FROM (
        SELECT number AS x
        FROM numbers(3)
        ORDER BY
            x ASC,
            exp(exp(x)) ASC
    );

EXPLAIN QUERY TREE run_passes = '1'
SELECT groupArray(x)
FROM (
        SELECT number AS x
        FROM numbers(3)
        ORDER BY
            x ASC,
            exp(exp(x)) ASC
    )
SETTINGS enable_analyzer = '1';

EXPLAIN SYNTAX
SELECT groupArray(x)
FROM (
        SELECT number AS x
        FROM numbers(3)
        ORDER BY
            exp(x) ASC,
            x ASC
    );

EXPLAIN QUERY TREE run_passes = '1'
SELECT groupArray(x)
FROM (
        SELECT number AS x
        FROM numbers(3)
        ORDER BY
            exp(x) ASC,
            x ASC
    )
SETTINGS enable_analyzer = '1';

EXPLAIN SYNTAX
SELECT *
FROM
    (
        SELECT number + 2 AS key
        FROM numbers(4)
    ) AS s
FULL JOIN test AS t
    USING (key)
ORDER BY
    s.key ASC,
    t.key ASC;

EXPLAIN QUERY TREE run_passes = '1'
SELECT *
FROM
    (
        SELECT number + 2 AS key
        FROM numbers(4)
    ) AS s
FULL JOIN test AS t
    USING (key)
ORDER BY
    s.key ASC,
    t.key ASC
SETTINGS enable_analyzer = '1';

EXPLAIN SYNTAX
SELECT
    key,
    a
FROM test
ORDER BY
    key ASC,
    a ASC,
    exp(key + a) ASC;

EXPLAIN QUERY TREE run_passes = '1'
SELECT
    key,
    a
FROM test
ORDER BY
    key ASC,
    a ASC,
    exp(key + a) ASC
SETTINGS enable_analyzer = '1';

EXPLAIN SYNTAX
SELECT
    key,
    a
FROM test
ORDER BY
    key ASC,
    exp(key + a) ASC;

EXPLAIN QUERY TREE run_passes = '1'
SELECT
    key,
    a
FROM test
ORDER BY
    key ASC,
    exp(key + a) ASC
SETTINGS enable_analyzer = '1';

EXPLAIN QUERY TREE run_passes = '1'
SELECT key
FROM test
GROUP BY key
ORDER BY
    avg(a) ASC,
    key ASC
SETTINGS enable_analyzer = '1';

DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1
(
    id UInt64
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE t2
(
    id UInt64
)
ENGINE = MergeTree()
ORDER BY id;

EXPLAIN QUERY TREE run_passes = '1'
SELECT *
FROM
    t1
INNER JOIN t2
    ON t1.id = t2.id
ORDER BY
    t1.id ASC,
    t2.id ASC
SETTINGS enable_analyzer = '1';

SET optimize_redundant_functions_in_order_by = '0';

DROP TABLE t1;

DROP TABLE t2;

DROP TABLE test;