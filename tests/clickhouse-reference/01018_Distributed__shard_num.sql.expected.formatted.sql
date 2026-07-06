-- Tags: shard
-- make the order static
SET max_threads = '1';

-- data should be inserted into Distributed table synchronously
SET distributed_foreground_insert = '1';

DROP TABLE IF EXISTS mem1;

DROP TABLE IF EXISTS mem2;

DROP TABLE IF EXISTS mem3;

DROP TABLE IF EXISTS dist_1;

DROP TABLE IF EXISTS dist_2;

DROP TABLE IF EXISTS dist_3;

CREATE TABLE mem1
(
    key Int
)
ENGINE = Memory();

INSERT INTO mem1;

CREATE TABLE dist_1 AS mem1
ENGINE = Distributed(test_shard_localhost, currentDatabase(), mem1);

INSERT INTO dist_1;

CREATE TABLE mem2
(
    key Int
)
ENGINE = Memory();

INSERT INTO mem2;

CREATE TABLE dist_2 AS mem2
ENGINE = Distributed(test_cluster_two_shards_localhost, currentDatabase(), mem2);

CREATE TABLE mem3
(
    key Int,
    _shard_num String
)
ENGINE = Memory();

INSERT INTO mem3;

CREATE TABLE dist_3 AS mem3
ENGINE = Distributed(test_shard_localhost, currentDatabase(), mem3);

SELECT *
FROM remote('127.0.0.1', `system`.one);

SELECT *
FROM remote('127.0.0.{1,2}', `system`.one);

SELECT
    _shard_num,
    *
FROM remote('127.0.0.1', `system`.one);

SELECT
    _shard_num,
    *
FROM remote('127.0.0.{1,2}', `system`.one)
ORDER BY _shard_num ASC;

SELECT
    _shard_num,
    *
FROM remote('127.0.0.{1,2}', `system`.one)
WHERE _shard_num = 1;

SELECT _shard_num
FROM dist_1
ORDER BY _shard_num ASC;

SELECT
    _shard_num,
    key
FROM dist_1
ORDER BY _shard_num ASC;

SELECT key
FROM dist_1;

SELECT
    _shard_num,
    key
FROM dist_1
ORDER BY
    _shard_num ASC,
    key ASC;

SELECT _shard_num
FROM dist_2
ORDER BY _shard_num ASC;

SELECT
    _shard_num,
    key
FROM dist_2
ORDER BY
    _shard_num ASC,
    key ASC;

SELECT key
FROM dist_2;

SELECT
    _shard_num,
    key
FROM remote('127.0.0.1', currentDatabase(), dist_2)
ORDER BY
    _shard_num ASC,
    key ASC
SETTINGS serialize_query_plan = '0';

-- distributed over distributed does not work, because _shard_num is not analyzed from QueryPlan.
SELECT
    _shard_num,
    key
FROM remote('127.0.0.1', currentDatabase(), dist_2)
ORDER BY
    _shard_num ASC,
    key ASC
SETTINGS
    serialize_query_plan = '1',
    prefer_localhost_replica = '0',
    enable_analyzer = '1';

SELECT
    a._shard_num,
    a.key,
    b.host_name,
    b.host_address IN ('::1', '127.0.0.1'),
    b.port
FROM
    (
        SELECT
            *,
            _shard_num
        FROM dist_1
    ) AS a
INNER JOIN `system`.clusters AS b
    ON a._shard_num = b.shard_num
WHERE b.cluster = 'test_cluster_two_shards_localhost';

SELECT
    _shard_num,
    key,
    b.host_name,
    b.host_address IN ('::1', '127.0.0.1'),
    b.port
FROM
    dist_1 AS a
INNER JOIN `system`.clusters AS b
    ON _shard_num = b.shard_num
WHERE b.cluster = 'test_cluster_two_shards_localhost'
ORDER BY key ASC
SETTINGS enable_analyzer = '1';

SELECT
    a._shard_num,
    key
FROM dist_1 AS a;

-- the same with JOIN, just in case
SELECT
    a._shard_num,
    a.key,
    b.host_name,
    b.host_address IN ('::1', '127.0.0.1'),
    b.port
FROM
    dist_1 AS a
INNER JOIN `system`.clusters AS b
    ON a._shard_num = b.shard_num
WHERE b.cluster = 'test_cluster_two_shards_localhost'
ORDER BY key ASC
SETTINGS enable_analyzer = '1';

SELECT *
FROM dist_3;

SELECT
    _shard_num,
    *
FROM dist_3
ORDER BY _shard_num ASC;