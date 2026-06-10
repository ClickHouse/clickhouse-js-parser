-- Tags: no-parallel, no-random-merge-tree-settings
SET rows_before_aggregation = '1', exact_rows_before_limit = '1', output_format_write_statistics = '0', max_block_size = '100';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    i int
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT arrayJoin(range(10000));

SELECT *
FROM test
WHERE i < 10
GROUP BY i
ORDER BY i ASC
FORMAT JSONCompact;

SELECT *
FROM test
WHERE i < 10
GROUP BY i
ORDER BY i ASC
FORMAT XML;

SELECT *
FROM test
GROUP BY i
HAVING i IN (10, 11, 12)
ORDER BY i ASC
FORMAT JSONCompact;

SELECT *
FROM test
WHERE i < 20
GROUP BY i
ORDER BY i ASC
FORMAT JSONCompact;

SELECT max(i)
FROM test
WHERE i < 20
LIMIT 1
FORMAT JSONCompact;

SET prefer_localhost_replica = '0';

SELECT *
FROM cluster(test_cluster_two_shards, currentDatabase(), test)
WHERE i < 30
GROUP BY i
ORDER BY i ASC
FORMAT JSONCompact;

SELECT *
FROM cluster(test_cluster_two_shards, currentDatabase(), test)
WHERE i < 20
GROUP BY i
ORDER BY i ASC
FORMAT JSONCompact;

SET prefer_localhost_replica = '1';

SELECT max(i)
FROM cluster(test_cluster_two_shards, currentDatabase(), test)
WHERE i < 20
FORMAT JSONCompact;

SELECT *
FROM (
        SELECT *
        FROM cluster(test_cluster_two_shards, currentDatabase(), test)
        WHERE i < 10
    )
GROUP BY i
ORDER BY i ASC
LIMIT 10
FORMAT JSONCompact;

CREATE TABLE test
(
    i int
)
ENGINE = MergeTree()
ORDER BY i;

SET optimize_aggregation_in_order = '1';