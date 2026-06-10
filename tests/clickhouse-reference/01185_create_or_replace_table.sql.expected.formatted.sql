-- Tags: no-ordinary-database
DROP TABLE IF EXISTS t1;

REPLACE TABLE t1
(
    n UInt64,
    s String
)
ENGINE = MergeTree()
ORDER BY n; -- { serverError UNKNOWN_TABLE }

SHOW TABLES;

CREATE OR REPLACE TABLE t1
(
    n UInt64,
    s String
)
ENGINE = MergeTree()
ORDER BY n;

SHOW CREATE TABLE t1;

INSERT INTO t1;

CREATE OR REPLACE TABLE t1
(
    n UInt64,
    s Nullable(String)
)
ENGINE = MergeTree()
ORDER BY n;

INSERT INTO t1;

SELECT *
FROM t1;

REPLACE TABLE t1
(
    n UInt64
)
ENGINE = MergeTree()
ORDER BY n;

INSERT INTO t1;

DROP TABLE t1;