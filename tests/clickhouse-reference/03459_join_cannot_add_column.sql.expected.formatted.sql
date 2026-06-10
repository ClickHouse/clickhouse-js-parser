SET enable_analyzer = '1', max_threads = '1';

DROP TABLE IF EXISTS t1, t2, t3;

CREATE TABLE t1
(
    id UInt32,
    name String
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE t2
(
    id UInt32,
    name String
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO t1 (id, name);

INSERT INTO t2 (id, name);

SELECT *
FROM t1
ORDER BY `ALL` ASC;

SELECT *
FROM t2
ORDER BY `ALL` ASC;

SELECT *
FROM (
        SELECT
            rowNumberInAllBlocks() + 1 AS id,
            t1.id,
            t2.id
        FROM
            t1
        LEFT JOIN t2
            ON t1.id = t2.id
    )
ORDER BY `ALL` ASC;

SELECT *
FROM (
        SELECT
            rowNumberInAllBlocks() + 1 AS id,
            t1.id,
            t2.id,
            t1.name,
            t2.name
        FROM
            t1
        LEFT JOIN t2
            ON t1.id = t2.id
    )
ORDER BY `ALL` ASC;

CREATE TABLE t3
ENGINE = MergeTree()
ORDER BY id AS
SELECT
    rowNumberInAllBlocks() + 1 AS id,
    t1.id,
    t2.id,
    t1.name,
    t2.name
FROM
    t1
LEFT JOIN t2
    ON t1.id = t2.id;

SELECT *
FROM t3
ORDER BY `ALL` ASC;

DROP TABLE t1, t2, t3;