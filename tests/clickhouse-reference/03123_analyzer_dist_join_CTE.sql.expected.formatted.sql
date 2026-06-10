-- https://github.com/ClickHouse/ClickHouse/issues/22923
SET enable_analyzer = '1';

SET prefer_localhost_replica = '0';

CREATE TABLE t0
(
    a Int64,
    b Int64
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a;

CREATE TABLE dist_t0
(
    a Int64,
    b Int64
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), t0);

INSERT INTO t0;

SELECT *
FROM (
        WITH b AS (
            SELECT toInt64(number) AS a
            FROM numbers(10)
        ),

        c AS (
            SELECT toInt64(number) AS a
            FROM numbers(10)
        )

        SELECT *
        FROM
            dist_t0 AS a
        LEFT JOIN b AS b
            ON a.a = b.a
        LEFT JOIN c AS c
            ON a.a = c.a
    )
ORDER BY `ALL` ASC;