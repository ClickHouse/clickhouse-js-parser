SET optimize_on_insert = '0';

DROP TABLE IF EXISTS tags;

CREATE TABLE tags
(
    id String,
    seqs Array(UInt8),
    create_time DateTime DEFAULT now()
)
ENGINE = ReplacingMergeTree()
ORDER BY id;

INSERT INTO tags (id, seqs);

WITH (
        SELECT [0, 1, 2, 3]
    ) AS arr1

SELECT
    arraySort(arrayIntersect(argMax(seqs, create_time), arr1)) AS common,
    id
FROM tags
WHERE id LIKE 'id%'
GROUP BY id
ORDER BY id ASC;

DROP TABLE tags;

-- https://github.com/ClickHouse/ClickHouse/issues/15294
DROP TABLE IF EXISTS TestTable;

CREATE TABLE TestTable
(
    column String,
    start DateTime,
    `end` DateTime
)
ENGINE = MergeTree()
ORDER BY start;

INSERT INTO TestTable (column, start, `end`);

SELECT
    column,
    (
        SELECT d
        FROM (
                SELECT [1, 2, 3, 4] AS d
            )
    ) AS d
FROM TestTable
WHERE column = 'test'
GROUP BY column;

DROP TABLE TestTable;

-- https://github.com/ClickHouse/ClickHouse/issues/11407
DROP TABLE IF EXISTS aaa;

DROP TABLE IF EXISTS bbb;

CREATE TABLE aaa
(
    id UInt16,
    data String
)
ENGINE = MergeTree()
ORDER BY id
PARTITION BY tuple();

INSERT INTO aaa;

CREATE TABLE bbb
(
    id UInt16,
    data String
)
ENGINE = MergeTree()
ORDER BY id
PARTITION BY tuple();

INSERT INTO bbb;

WITH (
        SELECT groupArray(id)
        FROM bbb
    ) AS ids

SELECT *
FROM aaa
WHERE has(ids, id)
ORDER BY id ASC;

DROP TABLE aaa;

DROP TABLE bbb;