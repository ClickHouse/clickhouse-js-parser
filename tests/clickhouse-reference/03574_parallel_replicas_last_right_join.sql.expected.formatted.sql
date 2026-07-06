SET allow_experimental_parallel_reading_from_replicas = '1';

SET max_parallel_replicas = '3';

SET enable_analyzer = '1';

SET parallel_replicas_for_non_replicated_merge_tree = '1';

SET cluster_for_parallel_replicas = 'parallel_replicas';

DROP TABLE IF EXISTS t0;

DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t0
(
    c0 Int
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO t0;

CREATE TABLE t1
(
    c0 Int
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO t1;

CREATE TABLE t2
(
    c0 Int
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO t2;

SELECT *
FROM (
        SELECT 1
        FROM
            remote('localhost:9000', currentDatabase(), 't0') AS t0
        INNER JOIN t1
            ON t0.c0 = t1.c0
        RIGHT JOIN t2
            ON t2.c0 = t1.c0
    )
FORMAT Null;

SELECT *
FROM (
        SELECT 1
        FROM
            remote('localhost:9000', currentDatabase(), 't0') AS t0
        INNER JOIN t1
            ON true
        RIGHT JOIN t2
            ON true
    )
FORMAT Null;