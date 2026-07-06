-- Tags: no-replicated-database, shard
-- Closes: https://github.com/ClickHouse/ClickHouse/issues/6571
SET enable_analyzer = '1';

CREATE TABLE LINEITEM_shard ON CLUSTER test_shard_localhost
(
    L_ORDERKEY UInt64,
    L_COMMITDATE UInt32,
    L_RECEIPTDATE UInt32
)
ENGINE = MergeTree()
ORDER BY L_ORDERKEY;

CREATE TABLE LINEITEM AS LINEITEM_shard
ENGINE = Distributed('test_shard_localhost', currentDatabase(), LINEITEM_shard, rand());

CREATE TABLE ORDERS_shard ON CLUSTER test_shard_localhost
(
    O_ORDERKEY UInt64,
    O_ORDERPRIORITY UInt32
)
ENGINE = MergeTree()
ORDER BY O_ORDERKEY;

CREATE TABLE ORDERS AS ORDERS_shard
ENGINE = Distributed('test_shard_localhost', currentDatabase(), ORDERS_shard, rand());

SET joined_subquery_requires_alias = '0';

SELECT
    O_ORDERPRIORITY,
    count(*) AS order_count
FROM
    ORDERS
INNER JOIN (
        SELECT L_ORDERKEY
        FROM LINEITEM_shard
        GROUP BY L_ORDERKEY
        HAVING any(L_COMMITDATE < L_RECEIPTDATE)
    )
    ON O_ORDERKEY = L_ORDERKEY
GROUP BY O_ORDERPRIORITY
ORDER BY O_ORDERPRIORITY ASC
LIMIT 1;

SET joined_subquery_requires_alias = '1';

SELECT
    O_ORDERPRIORITY,
    count(*) AS order_count
FROM
    ORDERS
INNER JOIN (
        SELECT L_ORDERKEY
        FROM LINEITEM_shard
        GROUP BY L_ORDERKEY
        HAVING any(L_COMMITDATE < L_RECEIPTDATE)
    ) AS x
    ON O_ORDERKEY = L_ORDERKEY
GROUP BY O_ORDERPRIORITY
ORDER BY O_ORDERPRIORITY ASC
LIMIT 1;