DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

DROP TABLE IF EXISTS t3;

DROP TABLE IF EXISTS t4;

CREATE TABLE t1
(
    id String,
    name String,
    value UInt32
)
ENGINE = Join(`ANY`, `LEFT`, id)
SETTINGS join_use_nulls = '1';

CREATE TABLE t2
(
    id String,
    name String,
    value UInt32
)
ENGINE = Join(`ANY`, `LEFT`, id)
SETTINGS join_use_nulls = '0';

CREATE TABLE t3
(
    id Nullable(String),
    name String,
    value UInt32
)
ENGINE = Join(`ANY`, `LEFT`, id)
SETTINGS join_use_nulls = '1';

CREATE TABLE t4
(
    id String,
    name Nullable(String),
    value UInt32
)
ENGINE = Join(`ANY`, `LEFT`, id)
SETTINGS join_use_nulls = '0';

INSERT INTO t1;

INSERT INTO t2;

INSERT INTO t3;

INSERT INTO t4;

SELECT
    *,
    toTypeName(id),
    toTypeName(name)
FROM t1;

SELECT
    *,
    toTypeName(id),
    toTypeName(name)
FROM t2;

SELECT
    *,
    toTypeName(id),
    toTypeName(name)
FROM t3;

SELECT
    *,
    toTypeName(id),
    toTypeName(name)
FROM t4;

SET join_use_nulls = '1';

DROP TABLE t1;

DROP TABLE t2;

DROP TABLE t3;

DROP TABLE t4;