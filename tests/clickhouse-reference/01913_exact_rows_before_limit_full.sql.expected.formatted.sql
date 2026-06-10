-- Tags: no-parallel, no-random-merge-tree-settings, no-parallel-replicas
DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    i int
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT arrayJoin(range(10000));

SET exact_rows_before_limit = '1', output_format_write_statistics = '0', max_block_size = '100';

SELECT *
FROM test
LIMIT 1
FORMAT JSONCompact;

SELECT *
FROM test
WHERE i < 10
GROUP BY i
ORDER BY i ASC
LIMIT 1
FORMAT JSONCompact;

SELECT *
FROM test
GROUP BY i
HAVING i IN (10, 11, 12)
ORDER BY i ASC
LIMIT 1
FORMAT JSONCompact;

SELECT *
FROM test
WHERE i < 20
ORDER BY i ASC
LIMIT 1
FORMAT JSONCompact;

SET prefer_localhost_replica = '0';

SELECT *
FROM cluster(test_cluster_two_shards, currentDatabase(), test)
WHERE i < 30
ORDER BY i ASC
LIMIT 1
FORMAT JSONCompact;

SELECT *
FROM cluster(test_cluster_two_shards, currentDatabase(), test)
WHERE i < 20
ORDER BY i ASC
LIMIT 1
FORMAT JSONCompact;

SET prefer_localhost_replica = '1';

SELECT *
FROM (
        SELECT *
        FROM cluster(test_cluster_two_shards, currentDatabase(), test)
        WHERE i < 10
    )
ORDER BY i ASC
LIMIT 1
FORMAT JSONCompact;