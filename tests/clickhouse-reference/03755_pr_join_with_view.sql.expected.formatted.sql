DROP TABLE IF EXISTS v;

DROP TABLE IF EXISTS t0 SYNC;

DROP TABLE IF EXISTS t1 SYNC;

CREATE TABLE t0
(
    k UInt64,
    v String
)
ENGINE = ReplicatedMergeTree('/clickhouse/{database}/t0', '0')
ORDER BY tuple();

CREATE TABLE t1
(
    k UInt64,
    v String
)
ENGINE = ReplicatedMergeTree('/clickhouse/{database}/t1', '0')
ORDER BY tuple();

CREATE VIEW v
AS
SELECT *
FROM t0;

INSERT INTO t0 SELECT
    number,
    toString(number)
FROM numbers(10);

INSERT INTO t1 SELECT
    number,
    toString(number + 100)
FROM numbers(10);

SET enable_parallel_replicas = '1', max_parallel_replicas = '3', cluster_for_parallel_replicas = 'test_cluster_one_shard_three_replicas_localhost';

-- inner join
SELECT *
FROM
    v
INNER JOIN t1
    USING (k)
ORDER BY `all` ASC
EXCEPT
(SELECT *
FROM
    v
INNER JOIN t1
    USING (k)
ORDER BY `all` ASC
SETTINGS enable_parallel_replicas = '0');

SELECT
    v.k,
    v.v,
    t1.k,
    t1.v
FROM
    v
INNER JOIN t1
    USING (k)
ORDER BY `all` ASC
EXCEPT
(SELECT
    v.k,
    v.v,
    t1.k,
    t1.v
FROM
    t1
INNER JOIN v
    USING (k)
ORDER BY `all` ASC);

-- right join
SELECT *
FROM
    v
RIGHT JOIN t1
    USING (k)
ORDER BY `all` ASC
EXCEPT
(SELECT *
FROM
    v
RIGHT JOIN t1
    USING (k)
ORDER BY `all` ASC
SETTINGS enable_parallel_replicas = '0');

SELECT
    v.k,
    v.v,
    t1.k,
    t1.v
FROM
    v
RIGHT JOIN t1
    USING (k)
ORDER BY `all` ASC
EXCEPT
(SELECT
    v.k,
    v.v,
    t1.k,
    t1.v
FROM
    t1
RIGHT JOIN v
    USING (k)
ORDER BY `all` ASC);

-- left join
SELECT *
FROM
    v
LEFT JOIN t1
    USING (k)
ORDER BY `all` ASC
EXCEPT
(SELECT *
FROM
    v
LEFT JOIN t1
    USING (k)
ORDER BY `all` ASC
SETTINGS enable_parallel_replicas = '0');

SELECT
    v.k,
    v.v,
    t1.k,
    t1.v
FROM
    v
LEFT JOIN t1
    USING (k)
ORDER BY `all` ASC
EXCEPT
(SELECT
    v.k,
    v.v,
    t1.k,
    t1.v
FROM
    t1
LEFT JOIN v
    USING (k)
ORDER BY `all` ASC);