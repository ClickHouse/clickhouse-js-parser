SET enable_analyzer = '0';

DROP TABLE IF EXISTS `03667_t1`;

DROP TABLE IF EXISTS `03667_t2`;

DROP TABLE IF EXISTS `03667_t3`;

CREATE TABLE `03667_t1`
(
    key Int64,
    value Int64
)
ENGINE = ReplacingMergeTree()
ORDER BY key
PARTITION BY tuple()
SETTINGS index_granularity = '8192';

CREATE TABLE `03667_t2`
(
    key Int64,
    value Int64
)
ENGINE = ReplacingMergeTree()
ORDER BY key
PARTITION BY tuple()
SETTINGS index_granularity = '8192';

CREATE TABLE `03667_t3`
(
    key Int64,
    value Int64
)
ENGINE = ReplacingMergeTree()
ORDER BY key
PARTITION BY tuple()
SETTINGS index_granularity = '8192';

EXPLAIN
SELECT *
FROM
    `03667_t1` AS s FINAL
INNER JOIN (
        SELECT *
        FROM `03667_t2` FINAL
    ) AS r FINAL
    ON s.key = r.key
INNER JOIN (
        SELECT *
        FROM `03667_t3` FINAL
    ) AS c FINAL
    ON s.key = c.key
FORMAT Null;