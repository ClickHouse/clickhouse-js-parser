-- Tags: shard
DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

DROP TABLE IF EXISTS t3;

DROP TABLE IF EXISTS t4;

CREATE TABLE t1
(
    x UInt32,
    y UInt32
)
ENGINE = TinyLog();

CREATE TABLE t2
(
    x UInt32,
    y UInt32 DEFAULT x + 1
)
ENGINE = TinyLog();

CREATE TABLE t3
(
    x UInt32,
    y UInt32 MATERIALIZED x + 1
)
ENGINE = TinyLog();

CREATE TABLE t4
(
    x UInt32,
    y UInt32 ALIAS x + 1
)
ENGINE = TinyLog();

INSERT INTO t1;

INSERT INTO t2;

INSERT INTO t3;

INSERT INTO t4;

INSERT INTO FUNCTION remote('127.0.0.2', currentDatabase(), t1);

INSERT INTO FUNCTION remote('127.0.0.2', currentDatabase(), t2);

--TODO: INSERT into remote tables with MATERIALIZED columns.
--INSERT INTO FUNCTION remote('127.0.0.2', currentDatabase(), t3) VALUES (2);
INSERT INTO FUNCTION remote('127.0.0.2', currentDatabase(), t4);

SELECT *
FROM remote('127.0.0.2', currentDatabase(), t1)
ORDER BY x ASC;

SELECT *
FROM remote('127.0.0.2', currentDatabase(), t2)
ORDER BY x ASC;

SELECT *
FROM remote('127.0.0.2', currentDatabase(), t3)
ORDER BY x ASC;

SELECT
    x,
    y
FROM remote('127.0.0.2', currentDatabase(), t3)
ORDER BY x ASC;

SELECT *
FROM remote('127.0.0.2', currentDatabase(), t4)
ORDER BY x ASC;

SELECT
    x,
    y
FROM remote('127.0.0.2', currentDatabase(), t4)
ORDER BY x ASC;

DROP TABLE t1;

DROP TABLE t2;

DROP TABLE t3;

DROP TABLE t4;