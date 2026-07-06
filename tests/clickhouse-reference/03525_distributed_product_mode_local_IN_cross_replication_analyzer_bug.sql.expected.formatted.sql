-- Tags: no-parallel
CREATE DATABASE IF NOT EXISTS shard_0;

CREATE DATABASE IF NOT EXISTS shard_1;

DROP TABLE IF EXISTS shard_0.test;

DROP TABLE IF EXISTS shard_1.test;

DROP TABLE IF EXISTS test_dist;

CREATE TABLE shard_0.test
(
    id UInt32,
    name String,
    dtm UInt32
)
ENGINE = MergeTree()
ORDER BY id
PARTITION BY dtm
SETTINGS index_granularity = '8192';

CREATE TABLE shard_1.test
(
    id UInt32,
    name String,
    dtm UInt32
)
ENGINE = MergeTree()
ORDER BY id
PARTITION BY dtm
SETTINGS index_granularity = '8192';

CREATE TABLE test_dist
(
    id UInt32,
    name String,
    dtm UInt32
)
ENGINE = Distributed('test_cluster_two_shards_different_databases', '', 'test');

INSERT INTO shard_0.test SELECT
    number,
    number,
    number % 3
FROM numbers(6);

INSERT INTO shard_1.test SELECT
    number + 3,
    number,
    (number + 1) % 3
FROM numbers(6);

-- { echoOn }
SELECT
    _shard_num,
    *
FROM test_dist
ORDER BY
    id ASC,
    _shard_num ASC;

SELECT count()
FROM test_dist AS a
WHERE id IN (
        SELECT id
        FROM test_dist
        WHERE dtm != 1
        SETTINGS distributed_product_mode = 'allow'
    )
SETTINGS enable_analyzer = '1';

SELECT count()
FROM test_dist AS a
WHERE id IN (
        SELECT id
        FROM test_dist
        WHERE dtm != 1
        SETTINGS distributed_product_mode = 'local'
    )
SETTINGS enable_analyzer = '1';

SELECT count()
FROM test_dist AS a
WHERE id IN (
        SELECT id
        FROM test_dist
        WHERE dtm != 1
        SETTINGS distributed_product_mode = 'local'
    )
    AND id IN (
        SELECT id
        FROM test_dist
        WHERE dtm != 2
        SETTINGS distributed_product_mode = 'local'
    )
SETTINGS enable_analyzer = '1';

SELECT count()
FROM test_dist AS a
WHERE id IN (
        SELECT id
        FROM test_dist
        WHERE dtm != 1
        SETTINGS distributed_product_mode = 'local'
    )
    AND id IN (
        SELECT id
        FROM test_dist
        WHERE dtm != 2
        SETTINGS distributed_product_mode = 'allow'
    )
SETTINGS enable_analyzer = '1';

SELECT count()
FROM test_dist AS a
WHERE id IN (
        SELECT id
        FROM test_dist
        WHERE dtm != 1
        SETTINGS distributed_product_mode = 'allow'
    )
    AND id IN (
        SELECT id
        FROM test_dist
        WHERE dtm != 2
        SETTINGS distributed_product_mode = 'local'
    )
SETTINGS enable_analyzer = '1';

SELECT count()
FROM test_dist AS a
WHERE id IN (
        SELECT id
        FROM test_dist
        WHERE dtm != 1
        SETTINGS distributed_product_mode = 'allow'
    )
    AND id IN (
        SELECT id
        FROM test_dist
        WHERE dtm != 2
        SETTINGS distributed_product_mode = 'allow'
    )
SETTINGS enable_analyzer = '1';