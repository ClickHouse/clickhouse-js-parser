SELECT CAST((), 'SimpleAggregateFunction(min, Tuple())');

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    c0 Tuple()
)
ENGINE = Memory();

INSERT INTO tab;

SELECT CAST(c0, 'SimpleAggregateFunction(min, Tuple())')
FROM tab;

DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 SimpleAggregateFunction(min, Tuple())
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO t0 (c0);

SELECT *
FROM t0;

DROP TABLE IF EXISTS t1;

CREATE TABLE t1
(
    c0 SimpleAggregateFunction(min, Tuple())
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS enable_block_number_column = '1', enable_block_offset_column = '1';

UPDATE t1 SET c0 = () WHERE true;

INSERT INTO t1 (c0);

SELECT *
FROM t1;