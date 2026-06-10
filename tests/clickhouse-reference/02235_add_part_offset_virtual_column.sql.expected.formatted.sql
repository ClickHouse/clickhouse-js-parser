DROP TABLE IF EXISTS t_1;

DROP TABLE IF EXISTS t_random_1;

CREATE TABLE t_1
(
    order_0 UInt64,
    ordinary_1 UInt32,
    p_time Date,
    computed ALIAS 'computed_' || CAST(p_time AS String),
    granule MATERIALIZED CAST(order_0 / 8192 AS UInt64) % 3,
    INDEX index_granule granule TYPE minmax() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY order_0
PARTITION BY toYYYYMM(p_time)
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

CREATE TABLE t_random_1
(
    ordinary_1 UInt32
)
ENGINE = GenerateRandom(1, 5, 3);

SET optimize_trivial_insert_select = '1';

INSERT INTO t_1 SELECT
    rowNumberInAllBlocks(),
    *,
    '1984-01-01'
FROM t_random_1
LIMIT 1000000;

OPTIMIZE TABLE t_1 FINAL;

ALTER TABLE t_1 ADD COLUMN foo String DEFAULT 'foo';

SELECT COUNTDistinct(_part)
FROM t_1;

SELECT
    min(_part_offset),
    max(_part_offset)
FROM t_1;

SELECT count(*)
FROM t_1
WHERE _part_offset != order_0;

SELECT count(*)
FROM t_1
WHERE order_0 IN (
        SELECT toUInt64(rand64() % 1000)
        FROM `system`.numbers
        LIMIT 100
    )
    AND _part_offset != order_0;

SELECT count(*)
FROM t_1
PREWHERE ordinary_1 > 5000
WHERE _part_offset != order_0;

SELECT
    order_0,
    _part_offset,
    _part
FROM t_1
ORDER BY order_0 ASC
LIMIT 3;

SELECT
    order_0,
    _part_offset,
    _part
FROM t_1
ORDER BY order_0 DESC
LIMIT 3;

SELECT
    order_0,
    _part_offset,
    _part
FROM t_1
WHERE order_0 <= 1
    OR order_0 >= 10000
    AND order_0 <= 10002
    OR order_0 >= 999998
ORDER BY order_0 ASC;

SELECT
    order_0,
    _part_offset,
    _part
FROM t_1
WHERE order_0 <= 1
    OR order_0 >= 10000
    AND order_0 <= 10002
    OR order_0 >= 999998
ORDER BY order_0 DESC;

SELECT
    order_0,
    _part_offset,
    computed
FROM t_1
ORDER BY
    order_0 ASC,
    _part_offset ASC,
    computed ASC
LIMIT 3;

SELECT
    order_0,
    _part_offset,
    computed
FROM t_1
ORDER BY
    order_0 DESC,
    _part_offset DESC,
    computed DESC
LIMIT 3;

SELECT
    order_0,
    _part_offset,
    _part
FROM t_1
WHERE order_0 <= 1
    OR order_0 >= 999998
ORDER BY order_0 ASC
LIMIT 3;

SELECT _part_offset
FROM t_1
ORDER BY order_0 ASC
LIMIT 3;

SELECT
    _part_offset,
    foo
FROM t_1
ORDER BY order_0 ASC
LIMIT 3;

SELECT
    count(*),
    sum(_part_offset),
    sum(order_0)
FROM t_1
WHERE granule = 0;

SELECT
    count(*),
    sum(_part_offset),
    sum(order_0)
FROM t_1
WHERE granule = 0
    AND _part_offset < 100000;

SELECT
    count(*),
    sum(_part_offset),
    sum(order_0)
FROM t_1
WHERE granule = 0
    AND _part_offset >= 100000;

SELECT _part_offset
FROM t_1
WHERE granule = 0
    AND _part_offset >= 100000
ORDER BY order_0 ASC
LIMIT 3;

SELECT
    _part_offset,
    foo
FROM t_1
WHERE granule = 0
    AND _part_offset >= 100000
ORDER BY order_0 ASC
LIMIT 3;

SELECT
    count(*),
    sum(_part_offset),
    sum(order_0)
FROM t_1
PREWHERE granule = 0
WHERE _part_offset >= 100000;

SELECT
    count(*),
    sum(_part_offset),
    sum(order_0)
FROM t_1
PREWHERE _part != ''
WHERE granule = 0;

SELECT
    count(*),
    sum(_part_offset),
    sum(order_0)
FROM t_1
PREWHERE _part_offset > 100000
WHERE granule = 0;

SELECT _part_offset
FROM t_1
PREWHERE order_0 % 10000 = 42
ORDER BY order_0 ASC
LIMIT 3;

SELECT
    _part_offset,
    foo
FROM t_1
PREWHERE order_0 % 10000 = 42
ORDER BY order_0 ASC
LIMIT 3;