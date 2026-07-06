-- https://github.com/ClickHouse/ClickHouse/issues/23104
SET enable_analyzer = '1';

DROP DATABASE IF EXISTS CLICKHOUSE_DATABASE;

CREATE DATABASE CLICKHOUSE_DATABASE;

CREATE TABLE CLICKHOUSE_DATABASE.base
(
    id UInt64,
    id2 UInt64,
    d UInt64,
    value UInt64
)
ENGINE = MergeTree()
ORDER BY (id, id2, d)
PARTITION BY d;

CREATE TABLE CLICKHOUSE_DATABASE.derived1
(
    id1 UInt64,
    d1 UInt64,
    value1 UInt64
)
ENGINE = MergeTree()
ORDER BY (id1, d1)
PARTITION BY d1;

CREATE TABLE CLICKHOUSE_DATABASE.derived2
(
    id2 UInt64,
    d2 UInt64,
    value2 UInt64
)
ENGINE = MergeTree()
ORDER BY (id2, d2)
PARTITION BY d2;

SELECT
    base.id AS `base.id`,
    derived2.id2 AS `derived2.id2`,
    derived2.value2 AS `derived2.value2`,
    derived1.value1 AS `derived1.value1`
FROM
    CLICKHOUSE_DATABASE.base AS base
LEFT JOIN CLICKHOUSE_DATABASE.derived2 AS derived2
    ON base.id2 = derived2.id2
LEFT JOIN CLICKHOUSE_DATABASE.derived1 AS derived1
    ON base.id = derived1.id1;