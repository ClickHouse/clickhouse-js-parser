-- Tags: no-parallel-replicas
-- no-parallel-replicas because the output of explain is different.
-- add_minmax_index_for_numeric_columns=0: Different plan
SET enable_analyzer = '1';

CREATE TABLE points
(
    x Int64,
    y Int64
)
ENGINE = MergeTree()
ORDER BY (x, y)
SETTINGS add_minmax_index_for_numeric_columns = '0';

INSERT INTO points;

EXPLAIN indexes = '1'
SELECT *
FROM points
WHERE pointInPolygon((x, y), [(0, 0), (0, 150), (150, 150), (150, 0)]);

EXPLAIN indexes = '1'
SELECT *
FROM points
WHERE plus(minus(x, 1), 10) < 10;

EXPLAIN indexes = '1'
SELECT *
FROM points
WHERE (plus(minus(x, 1), 10), minus(plus(y, 2), 20)) IN (10, 20);

EXPLAIN indexes = '1'
SELECT *
FROM points
WHERE (plus(minus(x, 1), 10), minus(plus(x, 2), 20)) IN (10, 20);

CREATE TABLE morton
(
    x UInt64,
    y UInt64
)
ENGINE = MergeTree()
ORDER BY mortonEncode(x, y)
SETTINGS add_minmax_index_for_numeric_columns = '0';

INSERT INTO morton;

EXPLAIN indexes = '1'
SELECT *
FROM morton
WHERE x > 100;

EXPLAIN indexes = '1'
SELECT x + y
FROM morton
WHERE x + 1 = 101;

SELECT x + y
FROM morton
WHERE x + 1 = 101;