-- https://github.com/ClickHouse/ClickHouse/issues/54317
SET enable_analyzer = '1';

DROP DATABASE IF EXISTS CLICKHOUSE_DATABASE;

CREATE DATABASE CLICKHOUSE_DATABASE;

USE CLICKHOUSE_DATABASE;

CREATE TABLE l
(
    y String
)
ENGINE = Memory();

CREATE TABLE r
(
    d Date,
    y String,
    ty UInt16 MATERIALIZED toYear(d)
)
ENGINE = Memory();

SELECT *
FROM
    l AS L
LEFT JOIN r AS R
    ON L.y = R.y
WHERE R.ty >= 2019;

SELECT *
FROM
    l
LEFT JOIN r
    ON l.y = r.y
WHERE r.ty >= 2019;

SELECT *
FROM
    CLICKHOUSE_DATABASE.l
LEFT JOIN CLICKHOUSE_DATABASE.r
    ON l.y = r.y
WHERE r.ty >= 2019;