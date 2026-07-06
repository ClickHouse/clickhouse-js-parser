-- Tags: use-rocksdb, no-parallel-replicas
-- no-parallel-replicas: Can't execute any of specified algorithms for specified strictness/kind and right storage type. (NOT_IMPLEMENTED)
DROP TABLE IF EXISTS rdb;

DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE rdb
(
    key UInt32,
    value Array(UInt32),
    value2 String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY key;

INSERT INTO rdb SELECT
    toUInt32(sipHash64(number) % 10) AS key,
    [key, key + 1] AS value,
    'val2' || toString(key) AS value2
FROM numbers_mt(10);

CREATE TABLE t1
(
    k UInt32
)
ENGINE = TinyLog();

INSERT INTO t1 SELECT number AS k
FROM numbers_mt(10);

CREATE TABLE t2
(
    k UInt16
)
ENGINE = TinyLog();

INSERT INTO t2 SELECT number AS k
FROM numbers_mt(10);

SET join_algorithm = 'direct';

SELECT '-- key rename';

SELECT *
FROM
    (
        SELECT k AS key
        FROM t2
    ) AS t2
INNER JOIN rdb
    ON rdb.key = t2.key
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT k AS key
        FROM t2
    ) AS t2
INNER JOIN rdb
    USING (key)
ORDER BY key ASC;

SELECT k
FROM
    t2
SEMI LEFT JOIN rdb
    ON rdb.key = t2.k
ORDER BY k ASC;

SELECT k
FROM
    t2
ANTI LEFT JOIN rdb
    ON rdb.key = t2.k
ORDER BY k ASC;

SELECT
    k,
    key,
    toTypeName(value2),
    value2
FROM
    t2
LEFT JOIN rdb
    ON rdb.key = t2.k
ORDER BY k ASC
SETTINGS join_use_nulls = '1';

SELECT
    k,
    key,
    toTypeName(value2),
    value2
FROM
    t2
INNER JOIN rdb
    ON rdb.key = t2.k
ORDER BY k ASC
SETTINGS join_use_nulls = '1';

SELECT value2
FROM
    t2
LEFT JOIN rdb
    ON rdb.key = t2.k
ORDER BY k ASC;

SELECT *
FROM
    t2
INNER JOIN rdb
    ON rdb.key = t2.k
ORDER BY rdb.key ASC;

-- can't promote right table type
SELECT *
FROM
    (
        SELECT toUInt64(k) AS k
        FROM t2
    ) AS t2
INNER JOIN rdb
    ON rdb.key = t2.k; -- { serverError NOT_IMPLEMENTED,TYPE_MISMATCH }

SELECT
    rdb.key % 2,
    sum(k),
    max(value2)
FROM
    t2
INNER JOIN rdb
    ON rdb.key = t2.k
GROUP BY rdb.key % 2
WITH TOTALS;

SELECT *
FROM
    t1
RIGHT JOIN rdb
    ON rdb.key = t1.k; -- { serverError NOT_IMPLEMENTED }

SELECT *
FROM
    t1
RIGHT JOIN rdb
    ON rdb.key = t1.k
FORMAT Null
SETTINGS join_algorithm = 'direct,hash';

SELECT *
FROM
    t1
FULL JOIN rdb
    ON rdb.key = t1.k; -- { serverError NOT_IMPLEMENTED }

SELECT *
FROM
    t1
FULL JOIN rdb
    ON rdb.key = t1.k
FORMAT Null
SETTINGS join_algorithm = 'direct,hash';

SELECT *
FROM
    t1
INNER JOIN rdb
    ON rdb.key + 1 = t1.k; -- { serverError NOT_IMPLEMENTED }

SELECT *
FROM
    t1
INNER JOIN rdb
    ON rdb.key + 1 = t1.k
FORMAT Null
SETTINGS join_algorithm = 'direct,hash';

SELECT *
FROM
    t1
INNER JOIN (
        SELECT *
        FROM rdb
    ) AS rdb
    ON rdb.key = t1.k; -- { serverError NOT_IMPLEMENTED }

SELECT *
FROM
    t1
INNER JOIN (
        SELECT *
        FROM rdb
    ) AS rdb
    ON rdb.key = t1.k
FORMAT Null
SETTINGS join_algorithm = 'direct,hash';

SELECT *
FROM
    t1
SEMI RIGHT JOIN (
        SELECT *
        FROM rdb
    ) AS rdb
    ON rdb.key = t1.k; -- { serverError NOT_IMPLEMENTED }

SELECT *
FROM
    t1
ANTI RIGHT JOIN (
        SELECT *
        FROM rdb
    ) AS rdb
    ON rdb.key = t1.k; -- { serverError NOT_IMPLEMENTED }