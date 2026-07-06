-- Tags: distributed
DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS td1;

DROP TABLE IF EXISTS td2;

DROP TABLE IF EXISTS td3;

CREATE TABLE t
(
    val UInt32
)
ENGINE = MergeTree()
ORDER BY val;

CREATE TABLE td1 AS t
ENGINE = Distributed(test_shard_localhost, currentDatabase(), 't');

CREATE TABLE td2 AS t
ENGINE = Distributed(test_shard_localhost, currentDatabase(), 't', xxHash32(val), default);

CREATE TABLE td3 AS t
ENGINE = Distributed(test_shard_localhost, currentDatabase(), 't', xxHash32(val), 'default');