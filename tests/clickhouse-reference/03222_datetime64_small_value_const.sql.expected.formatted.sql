-- Tags: shard
SET session_timezone = 'UTC'; -- don't randomize the session timezone

SET enable_analyzer = '1';

SELECT
    *,
    (
        SELECT toDateTime64(0, 3)
    )
FROM remote('127.0.0.1', `system`.one)
SETTINGS prefer_localhost_replica = '0';

SELECT
    *,
    (
        SELECT toDateTime64(5, 3)
    )
FROM remote('127.0.0.1', `system`.one)
SETTINGS prefer_localhost_replica = '0';

SELECT
    *,
    (
        SELECT toDateTime64('1970-01-01 00:45:25.456789', 6)
    )
FROM remote('127.0.0.1', `system`.one)
SETTINGS prefer_localhost_replica = '0';

SELECT
    *,
    (
        SELECT toDateTime64('1970-01-01 00:53:25.456789123', 9)
    )
FROM remote('127.0.0.1', `system`.one)
SETTINGS prefer_localhost_replica = '0';

SELECT
    *,
    (
        SELECT toDateTime64(NULL, 3)
    )
FROM remote('127.0.0.1', `system`.one)
SETTINGS prefer_localhost_replica = '0';

CREATE DATABASE IF NOT EXISTS shard_0;

CREATE DATABASE IF NOT EXISTS shard_1;

DROP TABLE IF EXISTS shard_0.dt64_03222;

DROP TABLE IF EXISTS shard_1.dt64_03222;

DROP TABLE IF EXISTS distr_03222_dt64;

CREATE TABLE shard_0.dt64_03222
(
    id UInt64,
    dt DateTime64(3)
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE shard_1.dt64_03222
(
    id UInt64,
    dt DateTime64(3)
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE distr_03222_dt64
(
    id UInt64,
    dt DateTime64(3)
)
ENGINE = Distributed(test_cluster_two_shards_different_databases, '', dt64_03222);

INSERT INTO shard_0.dt64_03222;

INSERT INTO shard_0.dt64_03222;

INSERT INTO shard_1.dt64_03222;

INSERT INTO shard_1.dt64_03222;

INSERT INTO shard_1.dt64_03222;

--Output : 1,5 2,3,4 4 1,2,3,5 0 0 5
SELECT
    id,
    dt
FROM distr_03222_dt64
WHERE dt = (
        SELECT toDateTime64(0, 3)
    )
ORDER BY id ASC;

SELECT
    id,
    dt
FROM distr_03222_dt64
WHERE dt > (
        SELECT toDateTime64(0, 3)
    )
ORDER BY id ASC;

SELECT
    id,
    dt
FROM distr_03222_dt64
WHERE dt > (
        SELECT toDateTime64('1970-01-01 00:10:00.000', 3)
    )
ORDER BY id ASC;

SELECT
    id,
    dt
FROM distr_03222_dt64
WHERE dt < (
        SELECT toDateTime64(5, 3)
    )
ORDER BY id ASC;

SELECT count(*)
FROM distr_03222_dt64
WHERE dt > (
        SELECT toDateTime64('2024-07-20 00:00:00', 3)
    );

SELECT count(*)
FROM distr_03222_dt64
WHERE dt > (
        SELECT now()
    );

SELECT count(*)
FROM distr_03222_dt64
WHERE dt < (
        SELECT toDateTime64('2004-07-20 00:00:00', 3)
    );

DROP DATABASE shard_0;

DROP DATABASE shard_1;