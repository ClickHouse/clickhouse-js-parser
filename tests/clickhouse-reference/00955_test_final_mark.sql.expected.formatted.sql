-- Tags: no-random-merge-tree-settings
SET send_logs_level = 'fatal';

DROP TABLE IF EXISTS mt_with_pk;

CREATE TABLE mt_with_pk
(
    d Date DEFAULT '2000-01-01',
    x DateTime,
    y Array(UInt64),
    z UInt64,
    n Nested(Age UInt8, Name String),
    w Int16 DEFAULT 10
)
ENGINE = MergeTree()
ORDER BY (x, z)
PARTITION BY toYYYYMM(d)
SETTINGS index_granularity_bytes = '10000'; -- write_final_mark=1 by default

INSERT INTO mt_with_pk (d, x, y, z, `n.Age`, `n.Name`);

SELECT COUNT(*)
FROM mt_with_pk
WHERE x > toDateTime('2018-10-01 23:57:57');

SELECT sum(marks)
FROM `system`.parts
WHERE table = 'mt_with_pk'
    AND database = currentDatabase()
    AND active = 1
    AND database = currentDatabase();

INSERT INTO mt_with_pk (d, x, y, z, `n.Age`, `n.Name`);

OPTIMIZE TABLE mt_with_pk FINAL;

ALTER TABLE mt_with_pk MODIFY COLUMN y Array(String);

INSERT INTO mt_with_pk (d, x, y, z, `n.Age`, `n.Name`);

ALTER TABLE mt_with_pk UPDATE w = 0 WHERE 1 SETTINGS mutations_sync = '2';

ALTER TABLE mt_with_pk UPDATE y = ['q', 'q', 'q'] WHERE 1 SETTINGS mutations_sync = '2';

SELECT sum(w)
FROM mt_with_pk;

SELECT DISTINCT y
FROM mt_with_pk;

ALTER TABLE mt_with_pk ADD INDEX idx1 z + w TYPE minmax() GRANULARITY 1;

INSERT INTO mt_with_pk (d, x, y, z, `n.Age`, `n.Name`, w);

SELECT COUNT(*)
FROM mt_with_pk
WHERE z + w > 5000;

DROP TABLE IF EXISTS alter_attach;

CREATE TABLE alter_attach
(
    x UInt64,
    p UInt8
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY p
SETTINGS index_granularity_bytes = '10000', write_final_mark = '1';

INSERT INTO alter_attach;

ALTER TABLE alter_attach DETACH PARTITION 1;

ALTER TABLE alter_attach ADD COLUMN s String;

INSERT INTO alter_attach;

ALTER TABLE alter_attach ATTACH PARTITION 1;

SELECT *
FROM alter_attach
ORDER BY x ASC;

ALTER TABLE alter_attach DETACH PARTITION 2;

ALTER TABLE alter_attach DROP COLUMN s;

INSERT INTO alter_attach;

ALTER TABLE alter_attach ATTACH PARTITION 2;

DROP TABLE IF EXISTS alter_update_00806;

CREATE TABLE alter_update_00806
(
    d Date,
    e Enum8('foo' = 1, 'bar' = 2)
)
ENGINE = MergeTree()
ORDER BY d
PARTITION BY d
SETTINGS index_granularity_bytes = '10000', write_final_mark = '1';

INSERT INTO alter_update_00806 (d, e);

INSERT INTO alter_update_00806 (d, e);

ALTER TABLE alter_update_00806 UPDATE e = CAST('foo' AS Enum8('foo' = 1, 'bar' = 2)) WHERE d = '2018-01-02' SETTINGS mutations_sync = '2';

SELECT e
FROM alter_update_00806
ORDER BY d ASC;

DROP TABLE IF EXISTS mt_without_pk;

CREATE TABLE mt_without_pk
(
    d Date DEFAULT '2000-01-01',
    x DateTime,
    y Array(UInt64),
    z UInt64,
    n Nested(Age UInt8, Name String),
    w Int16 DEFAULT 10
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY toYYYYMM(d)
SETTINGS index_granularity_bytes = '10000', write_final_mark = '1';

INSERT INTO mt_without_pk (d, x, y, z, `n.Age`, `n.Name`);

SELECT COUNT(*)
FROM mt_without_pk
WHERE x > toDateTime('2018-10-01 23:57:57');

SELECT sum(marks)
FROM `system`.parts
WHERE table = 'mt_without_pk'
    AND active = 1
    AND database = currentDatabase();

INSERT INTO mt_without_pk (d, x, y, z, `n.Age`, `n.Name`);

OPTIMIZE TABLE mt_without_pk FINAL;

DROP TABLE IF EXISTS mt_with_small_granularity;

CREATE TABLE mt_with_small_granularity
(
    d Date DEFAULT '2000-01-01',
    x DateTime,
    y Array(UInt64),
    z UInt64,
    n Nested(Age UInt8, Name String),
    w Int16 DEFAULT 10
)
ENGINE = MergeTree()
ORDER BY (x, z)
PARTITION BY toYYYYMM(d)
SETTINGS index_granularity_bytes = '30', min_index_granularity_bytes = '20', write_final_mark = '1';

INSERT INTO mt_with_small_granularity (d, x, y, z, `n.Age`, `n.Name`);

SELECT COUNT(*)
FROM mt_with_small_granularity
WHERE x > toDateTime('2018-10-01 23:57:57');

SELECT sum(marks)
FROM `system`.parts
WHERE table = 'mt_with_small_granularity'
    AND active = 1
    AND database = currentDatabase();

INSERT INTO mt_with_small_granularity (d, x, y, z, `n.Age`, `n.Name`);

OPTIMIZE TABLE mt_with_small_granularity FINAL;