-- Tags: no-parallel
SET send_logs_level = 'fatal';

--
-- Atomic no SYNC
-- (should go first to check that thread for DROP TABLE does not hang)
--
DROP DATABASE IF EXISTS db_01517_atomic;

CREATE DATABASE db_01517_atomic
ENGINE = Atomic();

CREATE TABLE db_01517_atomic.source
(
    key Int
)
ENGINE = Null();

CREATE MATERIALIZED VIEW db_01517_atomic.mv
ENGINE = Null()
AS
SELECT *
FROM db_01517_atomic.source;

DROP TABLE db_01517_atomic.mv;

-- ensure that the inner had been removed after sync drop
DROP TABLE db_01517_atomic.source SYNC;

SHOW TABLES FROM db_01517_atomic;

--
-- Atomic
--
DROP DATABASE IF EXISTS db_01517_atomic_sync;

CREATE DATABASE db_01517_atomic_sync
ENGINE = Atomic();

CREATE TABLE db_01517_atomic_sync.source
(
    key Int
)
ENGINE = Null();

CREATE MATERIALIZED VIEW db_01517_atomic_sync.mv
ENGINE = Null()
AS
SELECT *
FROM db_01517_atomic_sync.source;

-- drops it and hangs with Atomic engine, due to recursive DROP
DROP TABLE db_01517_atomic_sync.mv SYNC;

SHOW TABLES FROM db_01517_atomic_sync;

--
-- Ordinary
---
DROP DATABASE IF EXISTS db_01517_ordinary;

SET allow_deprecated_database_ordinary = '1';

-- Creation of a database with Ordinary engine emits a warning.
CREATE DATABASE db_01517_ordinary
ENGINE = Ordinary();

CREATE TABLE db_01517_ordinary.source
(
    key Int
)
ENGINE = Null();

CREATE MATERIALIZED VIEW db_01517_ordinary.mv
ENGINE = Null()
AS
SELECT *
FROM db_01517_ordinary.source;

-- drops it and hangs with Atomic engine, due to recursive DROP
DROP TABLE db_01517_ordinary.mv SYNC;

SHOW TABLES FROM db_01517_ordinary;

DROP TABLE db_01517_atomic_sync.source;

DROP TABLE db_01517_ordinary.source;

DROP DATABASE db_01517_atomic;

DROP DATABASE db_01517_atomic_sync;

DROP DATABASE db_01517_ordinary;