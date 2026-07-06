-- Tags: no-parallel-replicas
-- Tag no-parallel-replicas: result of explain is different
SET enable_analyzer = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(d Date)
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY json.d;

INSERT INTO test SELECT '{"d" : "2020-01-01"}';

INSERT INTO test SELECT '{"d" : "2021-01-01"}';

INSERT INTO test SELECT '{"d" : "2022-01-01"}';

INSERT INTO test SELECT '{"d" : "2023-01-01"}';

SELECT *
FROM test
ORDER BY json.d ASC;

EXPLAIN indexes = '1'
SELECT *
FROM test
WHERE json.d = '2020-01-01';

DROP TABLE test;

CREATE TABLE test
(
    c0 Array(Nullable(Int)),
    c1 Int,
    c2 Int
)
ENGINE = MergeTree()
ORDER BY c1
PARTITION BY c0.`null`;

INSERT INTO test;

SELECT *
FROM test
ORDER BY `all` ASC;