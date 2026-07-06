-- https://github.com/ClickHouse/ClickHouse/issues/64543
DROP TABLE IF EXISTS foo;

DROP TABLE IF EXISTS bar;

CREATE TABLE foo
(
    id UInt64,
    seq UInt64
)
ENGINE = Memory();

CREATE TABLE bar
(
    id UInt64,
    seq UInt64,
    name String
)
ENGINE = ReplacingMergeTree()
ORDER BY id;

INSERT INTO foo;

INSERT INTO bar;

INSERT INTO bar;

SELECT *
FROM
    bar
INNER JOIN foo
    USING (id)
WHERE bar.seq > foo.seq
SETTINGS final = '1';

-- Same problem possible can happen with array join
DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    k1 UInt64,
    k2 UInt64,
    v UInt64
)
ENGINE = ReplacingMergeTree()
ORDER BY (k1, k2);

SET optimize_on_insert = '0';

INSERT INTO t;

-- { echo ON }
SELECT
    arrayJoin([(k1, v), (k2, v)]) AS `row`,
    (`row`).1 AS k
FROM t FINAL
WHERE k1 != 3
    AND k = 1
ORDER BY `row` ASC
SETTINGS enable_vertical_final = '0';

SELECT
    arrayJoin([(k1, v), (k2, v)]) AS `row`,
    (`row`).1 AS k
FROM t FINAL
WHERE k1 != 3
    AND k = 1
ORDER BY `row` ASC
SETTINGS enable_vertical_final = '1';

SELECT
    arrayJoin([(k1, v), (k2, v)]) AS `row`,
    (`row`).1 AS k
FROM t FINAL
WHERE k1 != 3
    AND k = 2
ORDER BY `row` ASC
SETTINGS enable_vertical_final = '0';

SELECT
    arrayJoin([(k1, v), (k2, v)]) AS `row`,
    (`row`).1 AS k
FROM t FINAL
WHERE k1 != 3
    AND k = 2
ORDER BY `row` ASC
SETTINGS enable_vertical_final = '1';

SELECT
    arrayJoin([(k1, v), (k2, v)]) AS `row`,
    (`row`).1 AS k
FROM t FINAL
WHERE k1 != 3
    AND k = 3
ORDER BY `row` ASC
SETTINGS enable_vertical_final = '0';

SELECT
    arrayJoin([(k1, v), (k2, v)]) AS `row`,
    (`row`).1 AS k
FROM t FINAL
WHERE k1 != 3
    AND k = 3
ORDER BY `row` ASC
SETTINGS enable_vertical_final = '1';