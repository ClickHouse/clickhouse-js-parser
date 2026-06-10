SELECT dummy
FROM `system`.one;

SELECT *
FROM `system`.one;

SELECT one.dummy
FROM `system`.one;

SELECT one.*
FROM `system`.one;

SELECT `system`.one.dummy
FROM `system`.one;

SELECT `system`.one.*
FROM `system`.one;

SELECT t.dummy
FROM `system`.one AS t;

SELECT t.*
FROM `system`.one AS t;

SELECT t.dummy
FROM `system`.one AS t;

SELECT t.*
FROM `system`.one AS t;

SELECT one.dummy
FROM `system`.one AS one;

SELECT one.*
FROM `system`.one AS one;

USE `system`;

SELECT dummy
FROM one;

SELECT *
FROM one;

SELECT one.dummy
FROM one;

SELECT one.*
FROM one;

SELECT `system`.one.dummy
FROM one;

SELECT `system`.one.*
FROM one;

SELECT `system`.one.dummy
FROM one AS t;

SELECT `system`.one.*
FROM one AS t;

USE CLICKHOUSE_DATABASE;

DROP TABLE IF EXISTS nested;

CREATE TABLE nested
(
    nest Nested(a UInt8, b String)
)
ENGINE = Memory();

INSERT INTO nested;

SELECT
    nest.a,
    nest.b,
    nested.nest.a,
    nested.nest.b,
    t.nest.a,
    t.nest.b,
    t.*
FROM nested AS t;

DROP TABLE nested;

SELECT number
FROM numbers(2);

SELECT t.number
FROM numbers(2) AS t;

SELECT x
FROM (
        SELECT 1 AS x
    );

SELECT t.x
FROM (
        SELECT 1 AS x
    ) AS t;