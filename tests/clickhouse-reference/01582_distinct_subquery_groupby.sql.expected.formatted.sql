DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS d;

CREATE TABLE t
(
    a String,
    b Int
)
ENGINE = TinyLog();

INSERT INTO t;

SELECT *
FROM t;

SELECT '---';

CREATE TABLE d
(
    a String,
    b Int
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), t);

SELECT DISTINCT b
FROM (
        SELECT
            a,
            b
        FROM d
        GROUP BY
            a,
            b
    )
ORDER BY b ASC;

DROP TABLE d;

CREATE TABLE d
(
    a String,
    b Int
)
ENGINE = Distributed(test_cluster_two_shards_localhost, currentDatabase(), t);

DROP TABLE t;