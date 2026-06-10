DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    s UInt16,
    l UInt16,
    PROJECTION p (SELECT s, l ORDER BY l)
)
ENGINE = MergeTree()
ORDER BY s;

SELECT s
FROM
    t
INNER JOIN (
        SELECT toUInt16(1) AS s
    ) AS x
    USING (s)
ORDER BY s ASC
SETTINGS optimize_use_projections = '1';

SELECT s
FROM
    t
INNER JOIN (
        SELECT toUInt16(1) AS s
    ) AS x
    USING (s)
ORDER BY s ASC
SETTINGS optimize_use_projections = '0';

DROP TABLE t;

DROP TABLE IF EXISTS mt;

CREATE TABLE mt
(
    id1 Int8,
    id2 Int8
)
ENGINE = MergeTree()
ORDER BY tuple();

SELECT alias1
FROM
    (
        SELECT
            id1,
            id1 AS alias1
        FROM mt
    ) AS l
ALL INNER JOIN (
        SELECT id2 AS alias1
        FROM mt
    ) AS t
    USING (alias1)
ORDER BY l.id1 ASC
SETTINGS optimize_use_projections = '1';

SELECT id1
FROM
    mt
ALL INNER JOIN (
        SELECT id2 AS id1
        FROM mt
    ) AS t
    USING (id1)
ORDER BY id1 ASC
SETTINGS optimize_use_projections = '1';

SELECT id2 AS id1
FROM
    mt
ALL INNER JOIN (
        SELECT id1
        FROM mt
    ) AS t
    USING (id1)
ORDER BY id1 ASC
SETTINGS optimize_use_projections = '1';

DROP TABLE mt;

DROP TABLE IF EXISTS j;

CREATE TABLE j
(
    id1 Int8,
    id2 Int8,
    PROJECTION p (SELECT id1, id2 ORDER BY id2)
)
ENGINE = MergeTree()
ORDER BY id1
SETTINGS index_granularity = '1';

INSERT INTO j SELECT
    number,
    number
FROM numbers(10);

SELECT alias1
FROM
    (
        SELECT
            id1,
            id1 AS alias1
        FROM j
    ) AS l
ALL INNER JOIN (
        SELECT
            id2,
            id2 AS alias1
        FROM j
        WHERE id2 IN (1, 2, 3)
    ) AS t
    USING (alias1)
WHERE id2 IN (2, 3, 4)
ORDER BY id1 ASC
SETTINGS optimize_use_projections = '1';

DROP TABLE j;