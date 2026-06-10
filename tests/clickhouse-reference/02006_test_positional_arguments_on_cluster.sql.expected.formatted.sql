-- Tags: no-ordinary-database, no-replicated-database, distributed, zookeeper
DROP TABLE IF EXISTS t02006 ON CLUSTER test_shard_localhost FORMAT Null;

DROP TABLE IF EXISTS m02006 ON CLUSTER test_shard_localhost FORMAT Null;

CREATE TABLE t02006 ON CLUSTER test_shard_localhost
(
    d Date
)
ENGINE = MergeTree()
ORDER BY d
FORMAT Null;

CREATE MATERIALIZED VIEW m02006 ON CLUSTER test_shard_localhost
ENGINE = MergeTree()
ORDER BY tuple()
AS
SELECT
    d,
    0 AS i
FROM t02006
GROUP BY
    d,
    i
FORMAT Null;

ALTER TABLE t02006 ON CLUSTER test_shard_localhost ADD COLUMN IF NOT EXISTS f UInt64 FORMAT Null;

DESCRIBE TABLE t02006;

DROP TABLE IF EXISTS tt02006 ON CLUSTER test_shard_localhost FORMAT Null;

SET enable_analyzer = '1';

CREATE TABLE t02006 ON CLUSTER test_shard_localhost
(
    a String,
    b UInt32
)
ENGINE = ReplicatedMergeTree()
PRIMARY KEY a
ORDER BY a
FORMAT Null;

CREATE TABLE tt02006 ON CLUSTER test_shard_localhost
(
    a String,
    total SimpleAggregateFunction(sum, UInt64)
)
ENGINE = ReplicatedAggregatingMergeTree()
ORDER BY a
FORMAT Null;

CREATE MATERIALIZED VIEW m02006 ON CLUSTER test_shard_localhost
TO tt02006
AS
SELECT
    a,
    sum(b) AS total
FROM t02006
GROUP BY 1
ORDER BY 1 ASC
FORMAT Null;

DESCRIBE TABLE m02006;