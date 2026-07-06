-- Tags: no-parallel-replicas
SET enable_analyzer = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x UInt64,
    n Nullable(UInt32),
    t Tuple(a UInt32, b UInt32),
    json JSON
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '4';

INSERT INTO test SELECT
    number,
    number < 4 ? NULL : number,
    tuple(number, number),
    toJSONString(map('a', number, 'b', number))
FROM numbers(12);

EXPLAIN actions = '1'
SELECT *
FROM test
WHERE n.`null`
SETTINGS optimize_move_to_prewhere = '1';

SELECT *
FROM test
WHERE n.`null`
SETTINGS optimize_move_to_prewhere = '1';

EXPLAIN actions = '1'
SELECT *
FROM test
WHERE n.`null`
SETTINGS optimize_move_to_prewhere = '0';

SELECT *
FROM test
WHERE n.`null`
SETTINGS optimize_move_to_prewhere = '0';

EXPLAIN actions = '1'
SELECT *
FROM test
WHERE t.a < 4
SETTINGS optimize_move_to_prewhere = '1';

SELECT *
FROM test
WHERE t.a < 4
SETTINGS optimize_move_to_prewhere = '1';

EXPLAIN actions = '1'
SELECT *
FROM test
WHERE t.a < 4
SETTINGS optimize_move_to_prewhere = '0';

SELECT *
FROM test
WHERE t.a < 4
SETTINGS optimize_move_to_prewhere = '0';

EXPLAIN actions = '1'
SELECT *
FROM test
WHERE json.a::Int64 < 4
SETTINGS optimize_move_to_prewhere = '1';

SELECT *
FROM test
WHERE json.a::Int64 < 4
SETTINGS optimize_move_to_prewhere = '1';

EXPLAIN actions = '1'
SELECT *
FROM test
WHERE json.a::Int64 < 4
SETTINGS optimize_move_to_prewhere = '0';

SELECT *
FROM test
WHERE json.a::Int64 < 4
SETTINGS optimize_move_to_prewhere = '0';

DROP TABLE test;