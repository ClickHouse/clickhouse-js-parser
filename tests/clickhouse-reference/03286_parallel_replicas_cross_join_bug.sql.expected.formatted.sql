DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    x UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab SELECT number
FROM numbers(10000000.);

SET enable_parallel_replicas = '1', max_parallel_replicas = '3', cluster_for_parallel_replicas = 'parallel_replicas', parallel_replicas_for_non_replicated_merge_tree = true;

SELECT *
FROM
    tab AS l,
    tab AS r
WHERE l.x < r.x
    AND r.x < 2;

SELECT
    sum(x),
    sum(r.x)
FROM (
        SELECT *
        FROM
            tab AS l,
            tab AS r
        WHERE r.x < 2
            AND l.x < 3
    );