SET insert_keeper_max_retries = '100';

SET insert_keeper_retry_max_backoff_ms = '10';

DROP TABLE IF EXISTS table1 SYNC;

CREATE TABLE table1
(
    id Int64,
    v UInt64
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{database}/test_table12', '1', v)
ORDER BY id
PARTITION BY id % 200;

INSERT INTO table1 SELECT
    number - 205,
    number
FROM numbers(10);

INSERT INTO table1 SELECT
    number - 205,
    number
FROM numbers(400, 10);

SELECT toInt64(`partition`) AS p
FROM `system`.parts
WHERE table = 'table1'
    AND database = currentDatabase()
ORDER BY p ASC;

SELECT id
FROM table1
WHERE id % 200 = 2
    OR id % 200 = -2
ORDER BY id ASC;

SELECT id
FROM table1
WHERE id % 200 > 0
ORDER BY id ASC;

SELECT id
FROM table1
WHERE id % 200 < 0
ORDER BY id ASC;

DROP TABLE IF EXISTS table2 SYNC;

CREATE TABLE table2
(
    id Int64,
    v UInt64
)
ENGINE = MergeTree()
ORDER BY id
PARTITION BY (toInt32(id / 2) % 3, id % 200);

INSERT INTO table2 SELECT
    number - 205,
    number
FROM numbers(10);

INSERT INTO table2 SELECT
    number - 205,
    number
FROM numbers(400, 10);

SELECT `partition` AS p
FROM `system`.parts
WHERE table = 'table2'
    AND database = currentDatabase()
ORDER BY p ASC;

DROP TABLE IF EXISTS table3 SYNC;

CREATE TABLE table3
(
    id Int64,
    v UInt64
)
ENGINE = MergeTree()
ORDER BY id
PARTITION BY (id % 200, id % 200 % 10, toInt32(round(id % 200 / 2, 0)));

INSERT INTO table3 SELECT
    number - 205,
    number
FROM numbers(10);

INSERT INTO table3 SELECT
    number - 205,
    number
FROM numbers(400, 10);

SELECT `partition` AS p
FROM `system`.parts
WHERE table = 'table3'
    AND database = currentDatabase()
ORDER BY p ASC;

DETACH TABLE table3;

ATTACH TABLE table3;

DROP TABLE IF EXISTS table4 SYNC;

CREATE TABLE table4
(
    id Int64,
    v UInt64,
    s String,
    INDEX a (id * 2, s) TYPE minmax() GRANULARITY 3
)
ENGINE = MergeTree()
ORDER BY v
PARTITION BY id % 10;

INSERT INTO table4 SELECT
    number,
    number,
    toString(number)
FROM numbers(1000);

SELECT count()
FROM table4
WHERE id % 10 = 7;

SELECT
    v,
    v - 205 AS vv,
    modulo(vv, 200),
    moduloLegacy(vv, 200)
FROM table1
ORDER BY v ASC;

DROP TABLE table1 SYNC;

DROP TABLE table2 SYNC;

DROP TABLE table3 SYNC;

DROP TABLE table4 SYNC;