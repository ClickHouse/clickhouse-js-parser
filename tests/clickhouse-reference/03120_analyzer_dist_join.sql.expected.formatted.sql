-- Tags: no-replicated-database
-- https://github.com/ClickHouse/ClickHouse/issues/8547
SET enable_analyzer = '1';

SET distributed_foreground_insert = '1';

CREATE TABLE a1_replicated ON CLUSTER test_shard_localhost
(
    day Date,
    id UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/a1_replicated', '1_replica')
ORDER BY tuple();

CREATE TABLE a1
(
    day Date,
    id UInt32
)
ENGINE = Distributed('test_shard_localhost', currentDatabase(), a1_replicated, id);

CREATE TABLE b1_replicated ON CLUSTER test_shard_localhost
(
    day Date,
    id UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/b1_replicated', '1_replica')
ORDER BY tuple();

CREATE TABLE b1
(
    day Date,
    id UInt32
)
ENGINE = Distributed('test_shard_localhost', currentDatabase(), b1_replicated, id);

INSERT INTO a1 (day, id);

INSERT INTO b1 (day, id);

SET distributed_product_mode = 'local';

SELECT
    id,
    count()
FROM
    a1 AS a1
LEFT JOIN b1 AS b1
    ON a1.id = b1.id
GROUP BY id
ORDER BY id ASC;

SELECT
    id,
    count()
FROM
    a1 AS a1
LEFT JOIN (
        SELECT id
        FROM b1 AS b1
    ) AS b1
    ON a1.id = b1.id
GROUP BY id
ORDER BY id ASC;

SELECT
    id,
    count()
FROM
    (
        SELECT id
        FROM a1
    ) AS a1
LEFT JOIN (
        SELECT id
        FROM b1
    ) AS b1
    ON a1.id = b1.id
GROUP BY id
ORDER BY id ASC;

SET distributed_product_mode = 'global';