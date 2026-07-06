SET enable_analyzer = '1';

SET optimize_extract_common_expressions = '1';

DROP TABLE IF EXISTS x;

CREATE TABLE x
(
    x Int64,
    A UInt8,
    B UInt8,
    C UInt8,
    D UInt8,
    E UInt8,
    F UInt8
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO x SELECT
    cityHash64(number) AS x,
    cityHash64(number + 1) % 2 AS A,
    cityHash64(number + 2) % 2 AS B,
    cityHash64(number + 3) % 2 AS C,
    cityHash64(number + 4) % 2 AS D,
    cityHash64(number + 5) % 2 AS E,
    cityHash64(number + 6) % 2 AS F
FROM numbers(2000);

EXPLAIN QUERY TREE dump_ast = '1'
SELECT count()
FROM x
WHERE A
    OR B
    OR B
    AND C
SETTINGS optimize_extract_common_expressions = '0';

SELECT count()
FROM x
WHERE A
    OR B
    OR B
    AND C
SETTINGS optimize_extract_common_expressions = '0';

EXPLAIN QUERY TREE dump_ast = '1'
SELECT count()
FROM x
WHERE A
    OR B
    OR B
    AND C
SETTINGS optimize_extract_common_expressions = '1';

SELECT count()
FROM x
WHERE A
    OR B
    OR B
    AND C
SETTINGS optimize_extract_common_expressions = '1';

EXPLAIN QUERY TREE dump_ast = '1'
SELECT count()
FROM x
WHERE A
    AND B
    OR B
    AND C
    OR B
    AND D
    AND A
SETTINGS optimize_extract_common_expressions = '1';

SELECT count()
FROM x
WHERE A
    AND B
    OR B
    AND C
    OR B
    AND D
    AND A
SETTINGS optimize_extract_common_expressions = '1';

EXPLAIN QUERY TREE dump_ast = '1'
SELECT count()
FROM x
WHERE A
    AND B
    OR B
    AND C
    OR B
    AND D
    AND A
SETTINGS optimize_extract_common_expressions = '0';

SELECT count()
FROM x
WHERE A
    AND B
    OR B
    AND C
    OR B
    AND D
    AND A
SETTINGS optimize_extract_common_expressions = '0';

EXPLAIN QUERY TREE dump_ast = '1'
SELECT count()
FROM x
WHERE A
    AND B
    OR A
    AND B
    AND C
    OR D
    AND E
SETTINGS optimize_extract_common_expressions = '1';

SELECT count()
FROM x
WHERE A
    AND B
    OR A
    AND B
    AND C
    OR D
    AND E
SETTINGS optimize_extract_common_expressions = '1';

EXPLAIN QUERY TREE dump_ast = '1'
SELECT count()
FROM x
WHERE A
    AND B
    OR A
    AND B
    AND C
    OR D
    AND E
SETTINGS optimize_extract_common_expressions = '0';

SELECT count()
FROM x
WHERE A
    AND B
    OR A
    AND B
    AND C
    OR D
    AND E
SETTINGS optimize_extract_common_expressions = '0';

EXPLAIN QUERY TREE dump_ast = '1'
SELECT count()
FROM x
WHERE A
    AND B
    OR A
    AND B
    AND C
    OR B
    AND C
SETTINGS optimize_extract_common_expressions = '1';

SELECT count()
FROM x
WHERE A
    AND B
    OR A
    AND B
    AND C
    OR B
    AND C
SETTINGS optimize_extract_common_expressions = '1';

EXPLAIN QUERY TREE dump_ast = '1'
SELECT count()
FROM x
WHERE A
    AND B
    OR A
    AND B
    AND C
    OR B
    AND C
SETTINGS optimize_extract_common_expressions = '0';

SELECT count()
FROM x
WHERE A
    AND B
    OR A
    AND B
    AND C
    OR B
    AND C
SETTINGS optimize_extract_common_expressions = '0';