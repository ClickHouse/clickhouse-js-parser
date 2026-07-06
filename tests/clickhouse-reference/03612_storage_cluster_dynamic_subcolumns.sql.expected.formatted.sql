-- Tags: no-fasttest
DROP TABLE IF EXISTS test;

DROP TABLE IF EXISTS test_cluster;

CREATE TABLE test
(
    json JSON,
    d Dynamic
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT
    '{"a" : 42}',
    CAST('42' AS Int64);

CREATE TABLE test_cluster AS cluster(test_cluster_one_shard_three_replicas_localhost, currentDatabase(), 'test');

SELECT *
FROM test_cluster;

SELECT
    json.a,
    d.Int64
FROM test_cluster;

DROP TABLE test_cluster;

DROP TABLE test;