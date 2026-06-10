DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    n int,
    s String
)
ENGINE = MergeTree()
ORDER BY n;

INSERT INTO t;

SELECT
    count(),
    count(n),
    count(s)
FROM cluster('test_cluster_two_shards', currentDatabase(), t);

DROP TABLE t;