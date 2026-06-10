SET enable_analyzer = '1';

DROP TABLE IF EXISTS test, src;

SELECT
    count(),
    plus((-9, 0), (number, number)) AS k
FROM remote('127.0.0.{3,2}', numbers(2))
GROUP BY k
ORDER BY k ASC;

SELECT
    count(),
    mapAdd(map(CAST('1' AS UInt128), 1), map(CAST('1' AS UInt128), number)) AS k
FROM remote('127.0.0.{3,2}', numbers(2))
GROUP BY k
ORDER BY k ASC;

CREATE TABLE test
(
    s String
)
ORDER BY ();

INSERT INTO test;

SELECT transform(s, ['a', 'b'], [(1, 2), (3, 4)], (0, 0)) AS k
FROM test
ORDER BY k ASC;

SELECT s != '' ? (1, 2) : (0, 0) AS k
FROM test
ORDER BY k ASC;

CREATE TABLE src
(
    id UInt32,
    type String,
    data String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO src;

SELECT
    id,
    tuple(replaceAll(data, 'a', 'e') AS col_a, type) AS a,
    tuple(replaceAll(data, 'a', 'e') AS col_b, type) AS b
FROM src;