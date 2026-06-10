-- Tags: zookeeper, no-replicated-database, no-parallel, no-object-storage
DROP TABLE IF EXISTS x;

CREATE TABLE x
(
    i int,
    INDEX mm LOG2(i) TYPE minmax() GRANULARITY 1,
    PROJECTION p (SELECT MAX(i))
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/x', 'r')
ORDER BY i;

ALTER TABLE x ADD INDEX nn LOG2(i) TYPE minmax() GRANULARITY 1, ADD PROJECTION p2 (SELECT MIN(i));

SHOW CREATE TABLE x;

SELECT value
FROM `system`.zookeeper
WHERE name = 'metadata'
    AND path = '/clickhouse/tables/' || currentDatabase() || '/x';

DROP TABLE x;